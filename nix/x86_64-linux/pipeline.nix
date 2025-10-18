{ nixpkgs, system }:

let

    pkgs = import nixpkgs {
        inherit system;
    };

    buildInputs = [
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
    ];

    buildPhase = ''
        export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
        export HOME=$TMPDIR
        mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR
        
        cd app
        flutter pub get
        flutter create .
        
        flutter build linux --release
    '';

    installPhase = ''# $PWD starts from app directory
        mkdir -p $out/linux

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

in {
    pkgs         = pkgs;
    buildInputs  = buildInputs;
    buildPhase   = buildPhase;
    installPhase = installPhase;
}
