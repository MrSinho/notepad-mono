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
  
      notepad-mono = pkgs.flutter.buildFlutterApplication {
        pname = "Notepad-Mono";
        version = "1.1.1";
  
        src = ./../../app/.;
        
        pubspecLock = pkgs.lib.importJSON ./../../app/pubspec.lock.json; # To convert pubspec.lock into json: `yq -o json pubspec.lock > pubspec.lock.json`
  
        pubspecLockHash = pkgs.lib.fakeSha256;
  
        meta = {
          description = "Notepad Mono Flutter App";
          platforms = pkgs.lib.platforms.linux;
        };
  
      };

    in rec {

      defaultPackage = notepad-mono;

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
