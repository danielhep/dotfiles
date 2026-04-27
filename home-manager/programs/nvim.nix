{ pkgs, lib, ... }:

let
  nvimDeps = with pkgs; [
    # Build tools (for treesitter parsers, telescope-fzf-native, etc.)
    gcc
    gnumake
    unzip
    # Telescope dependencies
    ripgrep
    fd
    # Git (needed by lazy.nvim)
    git
  ];

  # Build a custom neovim wrapper with deps on PATH
  # Using neovim-unwrapped to avoid default ruby/python provider issues
  neovimWrapped =
    pkgs.runCommand "neovim-wrapped"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.neovim-unwrapped}/bin/nvim $out/bin/nvim \
          --suffix PATH : ${lib.makeBinPath nvimDeps}
        ln -s ${pkgs.neovim-unwrapped}/bin/nvim $out/bin/vi
        ln -s ${pkgs.neovim-unwrapped}/bin/nvim $out/bin/vim
      '';
in
{
  # Install our custom-wrapped neovim
  home.packages = [ neovimWrapped ];

  # Set as default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Symlink our nvim config directory to ~/.config/nvim
  # This works because lazy.nvim writes to stdpath("data"), not stdpath("config")
  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };
}
