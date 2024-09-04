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
            "vanilla"
            "stats"

            # Browsers
            "firefox"
        ];
    };
}
