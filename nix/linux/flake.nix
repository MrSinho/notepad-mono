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
    
      pkgs = import nixpkgs { inherit system; }; # Evaluate package set
  
      pipeline = import ./pipeline.nix { inherit pkgs; };

    in rec {

      defaultPackage = pipeline.notepad-mono;

      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };

      devShell = pkgs.mkShell {
        buildInputs = pipeline.buildInputs;
        shellHook   = pipeline.environmentSetup;
      };

    }

  );# outputs

}
