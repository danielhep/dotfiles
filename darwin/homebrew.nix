{
  config,
  username,
  pkgs,
  ...
}:
{
  homebrew = {
    enable = true;
    casks = [
      "discord"
      "signal"
      "whatsapp"

      # Utils
      "syncthing"
      "raycast"
      "stats"

      # Browsers
      "firefox"
    ];
  };
}
