{ pkgs, inputs, ... }:

with pkgs;
[
  any-nix-shell
  fish
  fzf
  direnv
  zoxide
  nixfmt
  iperf3
  grc
  eza
  bat
  gnupg1
  iftop
  ripgrep
  ripgrep-all
  starship
  comma
  nerd-fonts.jetbrains-mono
  nerd-fonts.meslo-lg
  go
  fvm
  fnm
  bun
  uv
  python3
  lazydocker
  lazygit
  gh
  jujutsu
  jjui
  sl
  k3d
  k9s
  kubectl
  kubernetes-helm

  # codinng agents
  codex
]
