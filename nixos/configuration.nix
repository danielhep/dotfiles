{
  lib,
  hostname,
  ...
}:
let
  hostModule = ./hosts + "/${hostname}.nix";
  hostHardware = ./hosts + "/${hostname}-hardware.nix";

  hasHostModule = builtins.pathExists hostModule;
  hasHostHardware = builtins.pathExists hostHardware;
  useHardwareFallback = !hasHostHardware;
in
{
  imports =
    [ ./modules/base.nix ]
    ++ lib.optional hasHostModule hostModule
    ++ lib.optional hasHostHardware hostHardware
    ++ lib.optional useHardwareFallback ./modules/hardware-fallback.nix;

  warnings = lib.optional useHardwareFallback ''
    No hardware configuration found for host "${hostname}".
    Checked ${toString hostHardware}.
    Using nixos/modules/hardware-fallback.nix for evaluation only.
  '';
}
