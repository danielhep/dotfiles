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
  inputs.opencode-flake.packages.${pkgs.system}.default
]
