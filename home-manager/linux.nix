# work.nix
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
  imports = baseConfig.imports;

  programs = baseConfig.programs // {
    # Add or override program settings specific to work
  };

  home.packages = baseConfig.home.packages ++ (with pkgs; [ signal-desktop ]);

  systemd = baseConfig.systemd;

  home.stateVersion = baseConfig.home.stateVersion;
}
