{pkgs, ...}:

with pkgs; [
    any-nix-shell
    fzf
    direnv
    zoxide
    grc
    eza
    bat
    iftop
    ripgrep
    ripgrep-all
    starship
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Meslo" ]; })
    fnm
    lazydocker
    lazygit
    gh
    sl
    inputs.devenv.packages."${system}".devenv
    cachix
    wezterm
]
