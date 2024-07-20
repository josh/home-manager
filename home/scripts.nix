{ pkgs, ... }:
let
  deadsymlinks = pkgs.writeShellScriptBin "deadsymlinks" ''
    find . -type l ! -exec test -r {} \; -print 2>/dev/null
  '';
  hm-up = pkgs.writeShellScriptBin "hm-up" ''
    if [ -d .git ] && [ "$(${pkgs.git}/bin/git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
        FLAKE="$(pwd)"
    else
        FLAKE="github:josh/home-manager"
    fi
    export FLAKE
    echo "Using $FLAKE as home manager flake" >&2

    exec ${pkgs.nh}/bin/nh home switch --backup-extension backup
  '';
in
{
  home.packages = [
    deadsymlinks
    hm-up
  ];
}
