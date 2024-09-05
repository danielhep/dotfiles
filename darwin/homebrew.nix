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
      "proton-mail"
      "rectangle"
      "bitwarden"

      # Utils
      "syncthing"
      "raycast"
      "stats"

      # Browsers
      "firefox"
    ];
  };
}
