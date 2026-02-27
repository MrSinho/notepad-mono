{ pkgs, ... }:

let
  pipeline = import ./pipeline.nix { inherit pkgs; };
in
  
pipeline.notepad-mono
