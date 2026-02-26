{ pkgs, ... }:

let
  flake = builtins.getFlake ./.;
in
  flake.defaultPackage
