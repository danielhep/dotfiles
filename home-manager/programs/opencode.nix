{ ... }:

{
  # Symlink opencode config files to ~/.config/opencode/
  # Note: We symlink individual files/dirs rather than the whole directory
  # because opencode writes runtime files (node_modules, package.json, bun.lock) there.
  xdg.configFile = {
    "opencode/opencode.json".source = ../opencode/opencode.json;
    "opencode/oh-my-opencode-slim.jsonc".source = ../opencode/oh-my-opencode-slim.jsonc;
    "opencode/skills" = {
      source = ../opencode/skills;
      recursive = true;
    };
  };
}
