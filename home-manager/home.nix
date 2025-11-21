# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{
  inputs,
  lib,
  config,
  pkgs,
  system,
  nixgl ? null,
  ...
}:
let
  isMac = (lib.systems.elaborate system).isDarwin;
  nixGLWrap = if nixgl != null then config.lib.nixGL.wrap else (pkg: pkg);
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

  nixGL = lib.mkIf (nixgl != null) {
    packages = import nixgl { inherit pkgs; };
    defaultWrapper = "mesa"; # or the driver you need
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };
  programs.zed-editor = {
    package = (if isMac then pkgs.zed-editor else (nixGLWrap pkgs.zed-editor));
    enable = true;
    extensions = [
      "nix"
      "swift"
      "html"
      "toml"
      "dockerfile"
      "java"
      "astro"
      "graphql"
      "dart"
      "catppuccin-icons"
      "biome"
      "docker-compose"
    ];
    userSettings = {
      vim_mode = true;
      buffer_font_size = 14;
      ui_font_size = 16;
      theme = {
        mode = "system";
        light = "Ayu Light";
        dark = "Ayu Dark";
      };
      minimap = {
        show = "auto";
      };
      terminal = {
        shell = {
          program = "fish";
        };
      };
    };
  };
  programs.ghostty = {
    enable = true;
    package = (if isMac then pkgs.ghostty-bin else (nixGLWrap pkgs.ghostty));
    enableFishIntegration = true;
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
