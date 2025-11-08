{
    inputs = {# Flake imports
        nixpkgs = {
            url = "github:nixos/nixpkgs/nixos-unstable";
        };
        flake-utils = {
            url = "github:numtide/flake-utils";
        };
    };

    outputs = { nixpkgs, flake-utils, ... }:
    
    flake-utils.lib.eachDefaultSystem (
            
    system: let

        pipeline = import ./pipeline.nix { inherit system nixpkgs; };

        notepad-mono = (
            pipeline.pkgs.stdenv.mkDerivation {

                pname   = "Notepad Mono";
                version = "1.1.1";
                
                src = ./../../.;

                buildInputs  = pipeline.buildInputs;
                buildPhase   = pipeline.buildPhase;
                installPhase = pipeline.installPhase;
            }
        );
        
    in rec {

        defaultPackage = notepad-mono;

        defaultApp = flake-utils.lib.mkApp {
            drv = defaultPackage;
        };

        devShell = pipeline.pkgs.mkShell {
            buildInputs = pipeline.buildInputs;
            shellHook   = pipeline.environmentSetup;
        };


    }

    );# outputs

}
