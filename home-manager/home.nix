# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    ./programs/vscode.nix
    ./programs/fish/fish.nix
    ./programs/git.nix
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.packages = with pkgs; [ ] ++ import ../shared/packages.nix { inherit pkgs; };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./programs/wezterm/wezterm.lua;
  };
  xdg.configFile = {
    "wezterm" = {
      source = ./programs/wezterm;
      recursive = true;
      enable = true;
    };
  };
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      update_check = false;
      sync_frequency = "10m";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
