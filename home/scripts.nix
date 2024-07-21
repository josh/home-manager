{ pkgs, ... }:
let
  deadsymlinks = pkgs.writeShellScriptBin "deadsymlinks" ''
    find . -type l ! -exec test -r {} \; -print 2>/dev/null
  '';
in
{
  home.packages = [ deadsymlinks ];
}
