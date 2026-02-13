{
  lib,
  hostname,
  ...
}:
let
  hostModule = ./hosts + "/${hostname}.nix";
  hostHardware = ./hosts + "/${hostname}-hardware.nix";
  etcHardware = /etc/nixos/hardware-configuration.nix;

  hasHostModule = builtins.pathExists hostModule;
  hasHostHardware = builtins.pathExists hostHardware;
  hasEtcHardware = (!hasHostHardware) && builtins.pathExists etcHardware;
  useHardwareFallback = (!hasHostHardware) && (!hasEtcHardware);
in
{
  imports =
    [ ./modules/base.nix ]
    ++ lib.optional hasHostModule hostModule
    ++ lib.optional hasHostHardware hostHardware
    ++ lib.optional hasEtcHardware etcHardware
    ++ lib.optional useHardwareFallback ./modules/hardware-fallback.nix;

  warnings = lib.optional useHardwareFallback ''
    No hardware configuration found for host "${hostname}".
    Checked ${toString hostHardware} and /etc/nixos/hardware-configuration.nix.
    Using nixos/modules/hardware-fallback.nix for evaluation only.
  '';
}
