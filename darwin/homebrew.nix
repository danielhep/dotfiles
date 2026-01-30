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
      "protonmail-bridge"
      "rectangle"
      "tailscale"

      # Utils
      "syncthing"
      "raycast"
      "stats"

      # Browsers
      "firefox"
    ];
  };
}
