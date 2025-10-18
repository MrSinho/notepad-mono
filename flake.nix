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

      linuxPipeline   = import ./nix/x86_64-linux-pipeline.nix { inherit system nixpkgs; };
      windowsPipeline = import ./nix/x86_64-windows-pipeline.nix { inherit system nixpkgs; };
      androidPipeline = import ./nix/aarch64-android-pipeline.nix { inherit system nixpkgs; };

      buildTarget = builtins.readFile ./flake-targets;

      #
      # Evaluate platform
      #

      platformBuildInputs = 
        if buildTarget == "linux" then linuxPipeline.buildInputs
        else if buildTarget == "windows" then windowsPipeline.buildInputs
        else if buildTarget == "android" then androidPipeline.buildInputs
        else throw "Unsupported target platform: ${buildTarget}";

      platformBuildPhase = 
        if buildTarget == "linux" then linuxPipeline.buildPhase
        else if buildTarget == "windows" then windowsPipeline.buildPhase
        else if buildTarget == "android" then androidPipeline.buildPhase
        else throw "Unsupported target platform: ${buildTarget}";

      platformInstallPhase = 
        if buildTarget == "linux" then linuxPipeline.installPhase
        else if buildTarget == "windows" then windowsPipeline.installPhase
        else if buildTarget == "android" then androidPipeline.installPhase
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
