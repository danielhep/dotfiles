{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = (with pkgs.vscode-extensions; [
      brettm12345.nixfmt-vscode
      vscodevim.vim
      jnoortheen.nix-ide
      ms-python.python
      ms-toolsai.jupyter
      graphql.vscode-graphql
      eamodio.gitlens
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
    ]);
    userSettings = {
      update.mode = "none";
      window.zoomLevel = 0;
      editor = {
        fontFamily =
          "'JetbrainsMono Nerd Font', 'monospace', monospace, 'Droid Sans Fallback'";
        fontLigatures = true;
        inlineSuggest.enabled = true;
        bracketPairColorization.enabled = true;
        fontSize = 14;
      };
      terminal.integrated.defaultProfile.osx = "fish";
      terminal.integrated.defaultProfile.linux = "fish";
    };
  };
}