{ nixpkgs, system }:

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

    buildInputs = [
        pkgs.flutter
        androidSdk
        pkgs.gradle
        pkgs.jdk17
    ];

    buildPhase = ''
        export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
        export HOME=$TMPDIR

        export XDG_CACHE_HOME=$TMPDIR/.cache
        export XDG_CONFIG_HOME=$TMPDIR/config
        export GRADLE_USER_HOME=$TMPDIR/.gradle
        export ANDROID_USER_HOME=$TMPDIR/.android
        
        export JAVA_HOME="${pkgs.jdk17}/lib/openjdk"
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
        mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR $XDG_CACHE_HOME $XDG_CONFIG_HOME $GRADLE_USER_HOME $ANDROID_USER_HOME 

        cd app
        flutter pub get
        flutter create .

        flutter build apk --release
        '';

    installPhase = ''# $PWD starts from app directory
        mkdir -p $out
        cp -r $PWD/build/app/outputs/flutter-apk/app-release.apk $out/Notepad_Mono.apk
    '';

in {
    pkgs         = pkgs;
    buildInputs  = buildInputs;
    buildPhase   = buildPhase;
    installPhase = installPhase;
}