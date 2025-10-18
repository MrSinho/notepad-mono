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

        pipeline = import ./pipeline.nix { inherit self nixpkgs; };

        notepad-mono = (pipeline.pkgs.stdenv.mkDerivation {

            pname = "Notepad Mono";
            version = "1.0.0";
            
            src = ./../../.;

            buildPhase = pipeline.buildPhase;
            
            installPhase = pipeline.installPhase;

        });# notepad-mono

    in rec {

        defaultPackage = notepad-mono;

        defaultApp = flake-utils.lib.mkApp {
            drv = defaultPackage;
        };

    }

    );# outputs

}
