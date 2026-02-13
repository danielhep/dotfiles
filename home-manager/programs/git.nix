{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "danielhep";
      user.email = "dh@danielheppner.com";
      alias = {
        st = "status";
      };
    };
    includes = [
      {
        contents = {
          push = {
            autoSetupRemote = true;
          };
        };
      }
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
