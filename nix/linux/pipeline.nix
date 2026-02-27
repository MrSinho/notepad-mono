{ pkgs, ... }:

let

  buildInputs = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake

    pkgs.flutter

    pkgs.patchelf

    pkgs.pango
    pkgs.cairo
    pkgs.glib
    pkgs.libepoxy
    pkgs.fontconfig
    pkgs.gdk-pixbuf
    pkgs.harfbuzz
    pkgs.libX11
    pkgs.libdeflate
  ];

  environmentSetup = ''
    export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
    export HOME=$TMPDIR
    mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR
  '';

  buildPhase = ''
    ${environmentSetup}

    cd app
    flutter pub get
    flutter create .
    
    flutter build linux --release
  '';

  installPhase = ''# $PWD starts from app directory
    mkdir -p $out
    
    # Get current architecture
    SYS_ARCH=$(uname -m)

    ARCH=""

    # Never seen in my life...
    case "$SYS_ARCH" in
      x86_64)
      ARCH="x64"
      cp -r $PWD/build/linux/x64/release/bundle/* $out/
      ;;
      aarch64)
      ARCH="arm64"
      ;;
      *)
      echo "Unknown architecture: $SYS_ARCH"
      ;;
    esac

    # Replace broken shared library paths with safe packages from nix store
    for so in $PWD/build/linux/$ARCH/release/bundle/lib/*.so; do
      if readelf -d "$so" | grep -q RUNPATH; then
      patchelf --set-rpath ${pkgs.pango}/lib "$so"
      patchelf --add-rpath ${pkgs.cairo}/lib "$so"
      patchelf --add-rpath ${pkgs.glib}/lib "$so"
      patchelf --add-rpath ${pkgs.libepoxy}/lib "$so"
      patchelf --add-rpath ${pkgs.fontconfig.lib}/lib "$so"
      patchelf --add-rpath ${pkgs.gdk-pixbuf}/lib "$so"
      patchelf --add-rpath ${pkgs.harfbuzz}/lib "$so"
      patchelf --add-rpath ${pkgs.libX11}/lib "$so"
      patchelf --add-rpath ${pkgs.libdeflate}/lib "$so"
      fi
    done

    # Copy build files
    cp -r $PWD/build/linux/$ARCH/release/bundle/* $out/

    # Patch also executable to find shared libraries
    # readelf -d $out/notepad_mono
    patchelf --add-rpath ${pkgs.cairo}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.glib}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.libepoxy}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.fontconfig.lib}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.gdk-pixbuf}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.harfbuzz}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.libX11}/lib $out/notepad_mono
    patchelf --add-rpath ${pkgs.libdeflate}/lib $out/notepad_mono

    mv $out/notepad_mono $out/NotepadMono

  '';

in {
  buildInputs      = buildInputs;
  buildPhase       = buildPhase;
  installPhase     = installPhase;
  environmentSetup = environmentSetup;
}
