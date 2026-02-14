{
  lib,
  pkgs,
  hostname,
  username,
  ...
}:
{
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      username
    ];
  };

  networking.hostName = lib.mkDefault hostname;
  networking.networkmanager.enable = lib.mkDefault true;

  time.timeZone = lib.mkDefault "America/Los_Angeles";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = lib.mkDefault {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = lib.mkDefault true;
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  services.xserver.xkb.layout = lib.mkDefault "us";
  services.xserver.xkb.variant = lib.mkDefault "";

  services.printing.enable = lib.mkDefault true;
  services.pulseaudio.enable = lib.mkDefault false;
  security.rtkit.enable = lib.mkDefault true;
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  services.openssh.enable = lib.mkDefault true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    home = "/home/${username}";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.firefox.enable = lib.mkDefault true;

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = lib.mkDefault "24.05";
}
