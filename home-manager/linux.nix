# work.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  nixgl = pkgs.nixgl;
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec ${lib.getExe nixgl.nixGLIntel} $bin \$@" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';

  # Create a shell script that wraps the wezterm call with nixGL
  wrappedWezterm = nixGLWrap pkgs.wezterm;

in
{
  imports = [
    ./home.nix # Import home.nix to use its settings as a base
  ];

  programs.wezterm = {
    # programs.wezterm.enable and .extraConfig are inherited from home.nix
    # Override the package to use our nixGL wrapped version for Linux
    package = wrappedWezterm;
  };

  # These packages are additional to those defined in home.nix.
  # The module system will concatenate them.
  home.packages = with pkgs; [
    aider-chat
  ];
}
