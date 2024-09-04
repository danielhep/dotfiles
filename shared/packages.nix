{ pkgs, ... }:

with pkgs;
[
  any-nix-shell
  fish
  fzf
  direnv
  zoxide
  nixfmt-rfc-style
  grc
  eza
  bat
  iftop
  ripgrep
  ripgrep-all
  starship
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Meslo"
    ];
  })
  fnm
  lazydocker
  lazygit
  gh
  sl
  # inputs.devenv.packages."${system}".devenv
  cachix
  wezterm
]
