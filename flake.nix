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
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };

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
            pkgs.jdk
            androidenv.androidPkgs.tools
            pkgs.patchelf
            pkgs.tree
          ];

          buildPhase = ''
            # Writable directory for storing settings and downloaded artifacts
            export HOME=$TMPDIR
            export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
            export XDG_CONFIG_HOME=$TMPDIR/config
            mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR $XDG_CONFIG_HOME

            flutter doctor

            cd app
            flutter create .
            flutter build linux --release
          '';

          installPhase = ''
            #dir >> $out/dir-locations.txt
            #dir >> $TMP/dir-locations.txt
            #dir $TMP >> $TMP/dir-locations.txt
            
            dir
            mkdir -p $out/bin
            echo $PWD >> $out/pwd-directory.txt
            tree >> $out/tree.txt
            tree $PWD >> $out/pwd-tree.txt
            tree $TMP >> $out/tmp-tree.txt
            dir $TMP >> $out/dir-tmp.txt

            # $PWD starts from app directory
            cp $PWD/build/linux/x64/release/bundle/notepad_mono $out/bin/notepad_mono

            #cp -r app/build/linux/x64/release/bundle/* $out/bin/

            # fix RPATH of all shared libraries
            #find $out/bin -name "*.so" -exec patchelf --set-rpath \$ORIGIN {} \;
            #patchelf --set-rpath \$ORIGIN $out/bin/notepad_mono
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
