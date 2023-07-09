{pkgs, ...}:

{
  programs.git = {
    enable = true;
    userName = "danielhep";
    userEmail = "dh@danielheppner.com";
    aliases = {
      st = "status";
    };
  };
}