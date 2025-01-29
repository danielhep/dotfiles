{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "danielhep";
    userEmail = "dh@danielheppner.com";
    aliases = {
      st = "status";
    };
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:danielhep/**";
        contents = {
          core = {
            sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/personal_id_rsa";
          };
        };
      }
    ];
  };
}
