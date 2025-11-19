{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  baseConfig = import ./home.nix {
    inherit
      inputs
      lib
      config
      pkgs
      ;
  };
in
{
  home.packages = [
    pkgs.colima
    pkgs.docker
    pkgs.sops
    pkgs.awscli2
  ];
}
