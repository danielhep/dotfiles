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
