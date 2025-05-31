{ pkgs, ... }:

with pkgs;
[
  any-nix-shell
  fish
  fzf
  direnv
  zoxide
  nixfmt-rfc-style
  iperf3
  grc
  eza
  bat
  iftop
  ripgrep
  ripgrep-all
  starship
  comma
  nerd-fonts.jetbrains-mono
  nerd-fonts.meslo-lg
  fnm
  lazydocker
  lazygit
  gh
  sl
]
