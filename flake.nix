{
  inputs = {# Flake imports
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let

      linuxPipeline = import ./nix/linuxPipeline.nix { inherit system nixpkgs; };

      buildTarget = 
        let
          _buildTarget = builtins.getEnv "build_target";
        in
          if _buildTarget == "" || _buildTarget == null then "linux"
          else _buildTarget;

      #
      # Package imports
      #

      windowsPkgs = import nixpkgs {
        inherit system;
      };

      androidPkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      # https://discourse.nixos.org/t/android-ndk-and-sdk-licenses-not-accepted/68215/2
      androidComposition = androidPkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [ "34.0.0" "35.0.0" ];
        platformVersions = [ "34" "35" "36" ];
        
        # includeCmdlineTools and includePlatformTools are true by default
        # when using composeAndroidPackages like this.
        # cmdline-tools will be the latest available.
        #
        # You can add other components if needed:
        # includeEmulator = true;
        # includeSystemImages = true;
        # systemImageTypes = [ "google_apis_playstore" ]; 
        # abiVersions = [ "x86_64" ]; # Ensure x86_64 system images are included
        includeNDK = true;
        ndkVersions = [ "27.0.12077973" ]; # specify the version from grande configs in your project
        cmakeVersions = [ "3.22.1" ]; # the same
      };

      androidSdk = androidComposition.androidsdk;

      #
      # Build inputs
      #

      windowsBuildInputs = [
        windowsPkgs.flutter
        windowsPkgs.wineWowPackages.full
        windowsPkgs.wineWowPackages.waylandFull
        windowsPkgs.winetricks
      ];

      androidBuildInputs = [
        androidPkgs.flutter
        androidSdk
        androidPkgs.gradle
        androidPkgs.jdk17
      ];
      
      #
      # Build phases
      #

      androidBuildPhase = ''
        export XDG_CACHE_HOME=$TMPDIR/.cache
        export XDG_CONFIG_HOME=$TMPDIR/config
        export GRADLE_USER_HOME=$TMPDIR/.gradle
        export ANDROID_USER_HOME=$TMPDIR/.android
        
        export JAVA_HOME="${androidPkgs.jdk17}/lib/openjdk"
        export PATH="$JAVA_HOME/bin:$PATH"
        
        export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
        export PATH="${androidSdk}/platform-tools:$PATH"
        export PATH="${androidSdk}/cmdline-tools/latest/bin:$PATH"
        
        # Add build-tools so we can use the Nix-packaged aapt2 instead of Maven’s
        export PATH="${androidSdk}/build-tools/35.0.0:$PATH" # !
        export PATH="${androidSdk}/build-tools/34.0.0:$PATH" # !

        # Force AGP to use aapt2 from SDK/build-tools rather than Maven cache (fixes NixOS stub-ld issue)
        export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/35.0.0/aapt2 $GRADLE_OPTS"

        # Ensure directories exist and are writable
        mkdir -p $XDG_CACHE_HOME $XDG_CONFIG_HOME $GRADLE_USER_HOME $ANDROID_USER_HOME 

        cd app
        flutter pub get
        flutter create .

        flutter build apk --release
      '';

      #
      # Install phases
      #

      androidInstallPhase = ''# $PWD starts from app directory
        mkdir -p $out/android
        cp -r $PWD/build/app/outputs/flutter-apk/app-release.apk $out/android/notepad_mono.apk
        #cp -r $PWD/build/app/outputs/flutter-apk/app-debug.apk $out/android/notepad_mono-debug.apk
      '';

      #
      # Evaluate platform
      #

      platformBuildInputs = 
        if buildTarget == "linux" then linuxPipeline.buildInputs
        else if buildTarget == "android" then androidBuildInputs
        else throw "Unsupported target platform: ${buildTarget}";

      platformBuildPhase = 
        if buildTarget == "linux" then linuxPipeline.buildPhase
        else if buildTarget == "android" then androidBuildPhase
        else throw "Unsupported target platform: ${buildTarget}";

      platformInstallPhase = 
        if buildTarget == "linux" then linuxPipeline.installPhase
        else if buildTarget == "android" then androidInstallPhase
        else throw "Unsupported target platform: ${buildTarget}";

      #
      # Pipeline
      #

      notepad-mono = (linuxPipeline.pkgs.stdenv.mkDerivation {

        pname = "Notepad Mono";
        version = "1.0.0";
        
        src = ./.;

        #src = pkgs.fetchgit {
        #  url = "https://github.com/mrsinho/notepad-mono.git";
        #  rev = "9b053e06b2aa55ba25d467d284f0ef62dbffdf9c";
        #  sha256 = "0000000000000000000000000000000000000000000000000000";# dummy 0000000000000000000000000000000000000000000000000000
        #  fetchSubmodules = true;
        #};

        nativeBuildInputs = platformBuildInputs;

        buildPhase = ''
          export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
          export HOME=$TMPDIR
          mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR

          ${platformBuildPhase}
        '';
        
        installPhase = ''
          ${platformInstallPhase}
        '';

      });# notepad-mono

    in rec {

      defaultPackage = notepad-mono;

      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };

    }

  );# outputs

}
