{ lib, ... }:
{
  # Evaluation-safe defaults for non-NixOS hosts or fresh flake checks.
  # Real hosts should provide either:
  # - nixos/hosts/<hostname>-hardware.nix, or
  # - /etc/nixos/hardware-configuration.nix
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.device = lib.mkDefault "/dev/sda";
  swapDevices = lib.mkDefault [ ];
}
