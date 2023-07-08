{pkgs, ...}:

{
  programs.fish = {
    enable = true;
    shellInit = import ./fish/fish_variables.nix + ''
     # nix
     if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
         bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
     end
    '';
    plugins = [
      { name="bass"; src = pkgs.fishPlugins.bass.src; }
      { name="tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
    ];
  };
}