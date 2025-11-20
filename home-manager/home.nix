# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  system,
  ...
}:
let
  isMac = (lib.systems.elaborate system).isDarwin;
in
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

  programs.ghostty = {
    enable = true;
    package =  (if isMac then pkgs.ghostty-bin else pkgs.ghostty);
    settings = {
      # Font
      font-family = "MesloLGS Nerd Font Mono";
      font-size = 14;
      command = "${pkgs.fish}/bin/fish";
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
