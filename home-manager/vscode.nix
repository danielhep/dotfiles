{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = (with pkgs.vscode-extensions; [
      brettm12345.nixfmt-vscode
      vscodevim.vim
      jnoortheen.nix-ide
      ms-toolsai.jupyter
      graphql.vscode-graphql
      eamodio.gitlens
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      usernamehw.errorlens
      # vadimcn.vscode-lldb
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "oh-lucy-vscode";
        publisher = "hermitter";
        version = "0.0.1";
        sha256 = "sha256-Z8WGLboC79/1K1WathegEtpR7hqrpUu20p4VN/67MG0=";
      }
    ]);
    userSettings = {
      update.mode = "none";
      workbench.colorTheme = "oh-lucy";
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