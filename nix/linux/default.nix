{ pkgs, ... }:

let
  pipeline = import ./pipeline.nix { inherit pkgs; };
in
  
pkgs.stdenv.mkDerivation {

  pname = "Notepad-Mono";
  version = "1.1.1";
                
  src = ./../../.;

  buildInputs  = pipeline.buildInputs;
  buildPhase   = pipeline.buildPhase;
  installPhase = pipeline.installPhase;
}
