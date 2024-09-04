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

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  home.packages = with pkgs; [ ] ++ import ../shared/packages.nix { inherit pkgs; };

  programs.tmux = {
    enable = true;
  };
  programs.wezterm = {
    enable = true;
  };
  home.file.".config" = {
    source = ../config;
    recursive = true;
  };
  xdg.configFile = {
    "wezterm" = {
      source = ./programs/wezterm;
      recursive = true;
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

  # programs.zellij = {
  #   enable = true;
  #   enableFishIntegration = true;
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
