{
  lib,
  pkgs,
  hostname,
  username,
  ...
}:
{
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

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = lib.mkDefault "24.05";
}
