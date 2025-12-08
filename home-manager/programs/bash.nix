{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    
    # This runs for interactive shells
    initExtra = ''
      # Source nix-daemon if it exists (for non-NixOS systems)
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # Initialize fnm for Node.js version management
      eval "$(fnm env --use-on-cd)"

      # Add ~/.local/bin to PATH
      export PATH="$HOME/.local/bin:$PATH"

      # Initialize direnv
      eval "$(direnv hook bash)"
    '';
  };
}

