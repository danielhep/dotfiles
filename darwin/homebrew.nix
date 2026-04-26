{
  config,
  username,
  pkgs,
  ...
}:
{
  homebrew = {
    enable = true;
    brews = [
      "dockutil"
    ];
    casks = [
      "discord"
      "signal"
      "whatsapp"
      "rectangle"
      "tailscale"

      # Utils
      "syncthing"
      "raycast"
      "stats"

      # Browsers
      "firefox"

      # Editors (not cached for aarch64-darwin in nixpkgs)
      "zed"
    ];
  };
}
