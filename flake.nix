{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      # https://discourse.nixos.org/t/android-ndk-and-sdk-licenses-not-accepted/68215/2
      androidComposition = pkgs.androidenv.composeAndroidPackages {
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

      notepad-mono = (with pkgs; stdenv.mkDerivation {
          pname = "Notepad Mono";
          version = "1.0.0";
          
          src = ./.;

          #src = pkgs.fetchgit {
          #  url = "https://github.com/mrsinho/notepad-mono.git";
          #  rev = "9b053e06b2aa55ba25d467d284f0ef62dbffdf9c";
          #  sha256 = "0000000000000000000000000000000000000000000000000000";# dummy 0000000000000000000000000000000000000000000000000000
          #  fetchSubmodules = true;
          #};

          nativeBuildInputs = [
            pkgs.flutter

            pkgs.patchelf

            pkgs.pango
            pkgs.cairo
            pkgs.glib
            pkgs.libepoxy
            pkgs.fontconfig
            pkgs.gdk-pixbuf
            pkgs.harfbuzz
            pkgs.xorg.libX11
            pkgs.libdeflate

            androidSdk
            pkgs.gradle
            pkgs.jdk
          ];

          buildPhase = ''
            export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage

            export HOME=$TMPDIR
            export XDG_CACHE_HOME=$TMPDIR/.cache
            export XDG_CONFIG_HOME=$TMPDIR/config
            export GRADLE_USER_HOME=$TMPDIR/.gradle
            export ANDROID_USER_HOME=$TMPDIR/.android
            
            export JAVA_HOME="${jdk17}/lib/openjdk"
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
            mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR  $XDG_CACHE_HOME $XDG_CONFIG_HOME $GRADLE_USER_HOME $ANDROID_USER_HOME 

            #flutter doctor

            cd app
            flutter pub get
            flutter create .
            
            flutter build apk --debug
            flutter build linux --release
          '';

          installPhase = ''# $PWD starts from app directory

            mkdir -p $out/linux
            mkdir -p $out/android

            #
            # ANDROID
            #

            cp $PWD/android/app/src/main/AndroidManifest.xml $out/android/main.xml
            cp $PWD/android/app/src/debug/AndroidManifest.xml $out/android/debug.xml
            #cp -r $PWD/build/app/outputs/flutter-apk/app-release.apk $out/android/notepad_mono-release.apk
            cp -r $PWD/build/app/outputs/flutter-apk/app-debug.apk $out/android/notepad_mono-debug.apk

            #
            # LINUX
            #

            # Replace broken shared library paths with safe packages from nix store
            for so in $PWD/build/linux/x64/release/bundle/lib/*.so; do
              echo "Required libraries for $(basename "$so")" >> $out/linux/readelf.txt
              
              if readelf -d "$so" | grep -q RUNPATH; then
                readelf -d "$so" | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/linux/readelf.txt

                patchelf --set-rpath ${pkgs.pango}/lib $so
                patchelf --add-rpath ${pkgs.cairo}/lib $so
                patchelf --add-rpath ${pkgs.glib}/lib $so
                patchelf --add-rpath ${pkgs.libepoxy}/lib $so
                patchelf --add-rpath ${pkgs.fontconfig.lib}/lib $so
                patchelf --add-rpath ${pkgs.gdk-pixbuf}/lib $so
                patchelf --add-rpath ${pkgs.harfbuzz}/lib $so
                patchelf --add-rpath ${pkgs.xorg.libX11}/lib $so
                patchelf --add-rpath ${pkgs.libdeflate}/lib $so
                
              else
                  echo "(no RUNPATH)" >> $out/linux/readelf.txt
                  echo " " >> $out/linux/readelf.txt
              fi
                            
            done

            # Copy bundle folder to output
            cp -r $PWD/build/linux/x64/release/bundle/* $out/linux

            # Patch also executable to find shared libraries
            # readelf -d $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.cairo}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.glib}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.libepoxy}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.fontconfig.lib}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.gdk-pixbuf}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.harfbuzz}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.xorg.libX11}/lib $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.libdeflate}/lib $out/linux/notepad_mono
          '';

        }
      );
    in rec {
      defaultPackage = notepad-mono;

      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };

    }
  );
}
