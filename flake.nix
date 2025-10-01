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
          #src = pkgs.lib.cleanSourceWith {
          #  src = ./.;
          #  filter = path: type: true;  # include everything
          #};

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
            #pkgs.pkg-config
          ];

          #buildInputs = [
          #  pkgs.flutter
          #  pkgs.vulkan-tools
          #  pkgs.vulkan-loader
          #  pkgs.vulkan-helper
          #  pkgs.vulkan-headers
          #  pkgs.glfw-wayland
          #  pkgs.wayland
          #  pkgs.wayland-protocols
          #  pkgs.wayland-scanner
          #  pkgs.libxkbcommon
          #  pkgs.xorg.libX11
          #  pkgs.xorg.libXi
          #  pkgs.xorg.libXrandr
          #  pkgs.xorg.libXinerama
          #  pkgs.xorg.libXcursor
          #  pkgs.xorg.libXext
          #  pkgs.doxygen
          #];

          #cmakeFlags = [
          #  "-Wno-dev"
          #  "-U'*'"
          #  "-DSH_VULKAN_BUILD_EXAMPLES=ON"############
          #  "-DSH_VULKAN_BUILD_DOCS=ON"
          #  
          #  "-DVulkan_INCLUDE_DIR=${pkgs.vulkan-headers}/include"
          #  "-DVulkan_LIBRARY=${pkgs.vulkan-loader}/lib/libvulkan.so"
          #
          #  "-DX11_X11_INCLUDE_PATH=examples/external/libx11/include"
          #  "-DX11_X11_LIB=${pkgs.xorg.libX11}/lib/libX11.so"
          #
          #  "-DX11_Xrandr_INCLUDE_PATH=examples/external/libxrandr/include"
          #  "-DX11_Xrandr_LIB=${pkgs.xorg.libXrandr}/lib/libXrandr.so"
          #
          #  "-DX11_Xinerama_INCLUDE_PATH=examples/external/libxinerama/include"
          #  "-DX11_Xinerama_LIB=${pkgs.xorg.libXinerama}/lib/libXinerama.so"
          #
          #  "-DX11_Xkb_INCLUDE_PATH=examples/external/libxkbcommon/include"
          #
          #  "-DX11_Xcursor_INCLUDE_PATH=examples/external/libxcursor/include"
          #  "-DX11_Xcursor_LIB=${pkgs.xorg.libXcursor}/lib/libXcursor.so"
          #
          #  "-DX11_Xi_INCLUDE_PATH=examples/external/libxi/include"
          #  "-DX11_Xi_LIB=${pkgs.xorg.libXi}/lib/libXi.so"
          #
          #  "-DX11_Xshape_INCLUDE_PATH=examples/external/libxext/include"
          #
          #  "-DPKG_CONFIG_PATH=${pkgs.wayland.dev}/lib/pkgconfig:${pkgs.wayland-protocols}/lib/pkgconfig:${pkgs.libxkbcommon.dev}/lib/pkgconfig:${pkgs.xorg.libX11}/lib/pkgconfig:${pkgs.xorg.libXi}/lib/pkgconfig:${pkgs.xorg.libXrandr}/lib/pkgconfig:${pkgs.xorg.libXinerama}/lib/pkgconfig:${pkgs.xorg.libXcursor}/lib/pkgconfig"
          #];

          buildPhase = ''
            # Writable directory for storing settings and downloaded artifacts
            export HOME=$TMPDIR
            export FLUTTER_STORAGE_BASE_DIR=$TMPDIR/flutter_storage
            export XDG_CONFIG_HOME=$TMPDIR/config
            mkdir -p $HOME $FLUTTER_STORAGE_BASE_DIR $XDG_CONFIG_HOME

            cd app
            flutter create .
            flutter build linux --release
          '';

          #installPhase = '' # Starts from build directory (equal to $PWD)
          #  mkdir -p $out/lib
          #  mkdir -p $out/include
          #  mkdir -p $out/docs
          #  cp -r $PWD/../lib              $out/
          #  cp -r $PWD/../shvulkan/include $out/
          #  cp -r $PWD/../docs/docs        $out/
          #
          #  # Copy examples binaries and shaders
          #  mkdir -p $out/examples/bin
          #  mkdir -p $out/examples/shaders/bin
          #  cp -r $PWD/../examples/shaders/bin $out/examples/shaders/
          #  cp -r $PWD/../bin/examples/*       $out/examples/bin/
          #'';

        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };

      defaultPackage = notepad-mono;
    }
  );
}
