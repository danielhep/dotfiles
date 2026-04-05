{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      direnv hook fish | source
    '';
    functions = {
      kill-port = ''
        # Check if a port number is provided
        if test (count $argv) -eq 0
            echo "Usage: kill-port <port>"
            return 1
        end

        set port $argv[1]

        # Find the process running on the specified port
        set pid (lsof -ti:$port)

        if test -z "$pid"
            echo "No process found running on port $port"
            return 1
        end

        # Get process name for display
        set process_name (ps -p $pid -o comm=)

        echo "Killing process $process_name (PID: $pid) running on port $port"

        # Kill the process
        kill -9 $pid

        if test $status -eq 0
            echo "Successfully killed process on port $port"
        else
            echo "Failed to kill process on port $port"
            return 1
        end
      '';

      sync_photos = ''
        if test (count $argv) -ne 1
            echo "Usage: sync_photos <directory_name>"
            return 1
        end

        set directory_name $argv[1]

        echo "Syncing photos to tower-travel-media:/travel_media/$directory_name ..."
        rclone move ./ tower-travel-media:/travel_media/$directory_name -v
      '';
    };
    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      if test -e /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv)"
      end

      fnm env --use-on-cd | source

      starship init fish | source

      fish_add_path ~/.local/bin
    '';
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fish-exa";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-exa";
          rev = "29077c16dcdba0019cda5cf596b54be113fbe47d";
          sha256 = "tvU2SxhqccDPj+uzASFyqAnrBXc7bv+pblKdHcnfa8w=";
        };
      }
    ];
  };
}
