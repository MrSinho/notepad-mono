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

            pkgs.makeWrapper
            pkgs.pango
            pkgs.cairo
            pkgs.glib
            pkgs.libepoxy
            pkgs.fontconfig
            pkgs.gdk-pixbuf
            pkgs.harfbuzz
            pkgs.xorg.libX11
            pkgs.libdeflate
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

          #postFixup = ''
          #  patchelf --set-rpath $out/lib $out/bin/notepad_mono
          #'';

          installPhase = ''# $PWD starts from app directory

            mkdir -p $out/linux
            mkdir -p $out/linux/lib

            # I'll remove this later
            echo $PWD >> $out/pwd-directory.txt
            tree >> $out/tree.txt
            tree $PWD >> $out/pwd-tree.txt
            tree $TMP >> $out/tmp-tree.txt
            dir $TMP >> $out/dir-tmp.txt

            # Print required libraries for each .so file
            
            #echo "Required libraries for libapp.so" >> $out/readelf.txt
            #readelf -d $PWD/build/linux/x64/release/bundle/lib/libapp.so                       | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/readelf.txt
            
            #echo "Required libraries for libflutter_linux_gtk.so" >> $out/readelf.txt
            #readelf -d $PWD/build/linux/x64/release/bundle/lib/libflutter_linux_gtk.so         | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/readelf.txt
            #
            #echo "Required libraries for libgtk_plugin.so" >> $out/readelf.txt
            #readelf -d $PWD/build/linux/x64/release/bundle/lib/libgtk_plugin.so | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/readelf.txt
            #
            #echo "Required libraries for liburl_launcher_linux_plugin.so" >> $out/readelf.txt
            #readelf -d $PWD/build/linux/x64/release/bundle/lib/liburl_launcher_linux_plugin.so | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/readelf.txt


            for so in $PWD/build/linux/x64/release/bundle/lib/*.so; do
              echo "Required libraries for $(basename "$so")" >> $out/readelf.txt
              
              if readelf -d "$so" | grep -q RUNPATH; then
                readelf -d "$so" | grep RUNPATH | tr ":" "\n" | tr "[" "\n" | tr "]" "\n" >> $out/readelf.txt

                #echo "Fixing broken paths"
                patchelf --remove-rpath $so
                patchelf --add-rpath ${pkgs.pango}/lib $so
                patchelf --add-rpath ${pkgs.cairo}/lib $so
                patchelf --add-rpath ${pkgs.glib}/lib $so
                patchelf --add-rpath ${pkgs.libepoxy}/lib $so
                patchelf --add-rpath ${pkgs.fontconfig}/lib $so
                patchelf --add-rpath ${pkgs.gdk-pixbuf}/lib $so
                patchelf --add-rpath ${pkgs.harfbuzz}/lib $so
                patchelf --add-rpath ${pkgs.xorg.libX11}/lib $so
                patchelf --add-rpath ${pkgs.libdeflate}/lib $so

              else
                  echo "(no RUNPATH)" >> $out/readelf.txt
                  echo " " >> $out/readelf.txt
              fi
                            
            done

            #patchelf --remove-rpath $PWD/build/linux/x64/release/bundle/lib/libapp.so
            #patchelf --remove-rpath $PWD/build/linux/x64/release/bundle/lib/libflutter_linux_gtk.so
            #patchelf --remove-rpath $PWD/build/linux/x64/release/bundle/lib/libgtk_plugin.so
            #patchelf --remove-rpath $PWD/build/linux/x64/release/bundle/lib/liburl_launcher_linux_plugin.so

            cp $PWD/build/linux/x64/release/bundle/notepad_mono  $out/linux/notepad_mono
            cp -r $PWD/build/linux/x64/release/bundle/lib/*         $out/linux/lib
          '';
          
          postFixup = ''# Patch executable to find shared libraries
            # patchelf -d $out/linux/notepad_mono
            patchelf --add-rpath ${pkgs.libepoxy}/lib $out/linux/notepad_mono
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
