{pkgs, ...}:

{
  programs.fish = {
    enable = true;
    shellInit = ''
     # nix
     if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
         bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
     end

    fnm env --use-on-cd | source

    starship init fish | source

    fish_add_path ~/.local/bin
    '';
    plugins = [
      { name="bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "fish-exa"; src = pkgs.fetchFromGitHub {
        owner = "gazorby";
        repo = "fish-exa";
        rev = "29077c16dcdba0019cda5cf596b54be113fbe47d";
        sha256 = "tvU2SxhqccDPj+uzASFyqAnrBXc7bv+pblKdHcnfa8w=";
      };}
    ];
  };
}