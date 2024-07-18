{ pkgs, ... }:
let
  deadsymlinks = pkgs.writeShellScriptBin "deadsymlinks" ''
    find . -type l ! -exec test -r {} \; -print 2>/dev/null
  '';
  hm-up = pkgs.writeShellScriptBin "hm-up" ''
    if [ -d .git ] && [ "$(${pkgs.git}/bin/git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
        FLAKE_URI="$(pwd)"
    else
        FLAKE_URI="github:josh/home-manager"
    fi
    echo "Using $FLAKE_URI as home manager flake" >&2

    exec ${pkgs.home-manager}/bin/home-manager switch --refresh --flake "$FLAKE_URI" -b backup
  '';
in
{
  home.packages = [
    deadsymlinks
    hm-up
  ];
}
