{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

      direnv hook fish | source
    '';
    functions = {
      sync_files = ''
        # Check if the correct number of arguments is provided
        if test (count $argv) -ne 2
            echo "Usage: sync_files [local|remote] <subfolder>"
            return 1
        end

        # Extract the arguments
        set dest_type $argv[1]
        set subfolder $argv[2]

        # Set the destination based on the first argument
        if test $dest_type = "local"
            set DEST "$HOME/sync_files/$subfolder"
        else if test $dest_type = "remote"
            set DEST "danielhep@tower:/$subfolder"
        else
            echo "Invalid destination type. Use 'local' or 'remote'."
            return 1
        end

        # Run the rsync command
        rsync -avPh --stats --remove-source-files -e "ssh -p 2022 -i ~/.ssh/id_rsa" ./ $DEST
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
