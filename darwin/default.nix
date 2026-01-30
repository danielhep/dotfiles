{
  config,
  username,
  pkgs,
  system,
  inputs,
  ...
}:
{

  imports = [ ./homebrew.nix ];
  # It me
  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.fish;
  };

  # nixpkgs.config = {
  #   allowUnfree = true;
  # };

  programs.fish.enable = true;
  programs.zsh.enable = true;
  # Setup user, packages, programs
  nix = {
    enable = false;
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    fswatch
  ];

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;

    activationScripts.activateFishShell.enable = true;
    activationScripts.activateFishShell.text = ''
      dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
    '';
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
