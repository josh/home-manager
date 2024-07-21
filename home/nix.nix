# Tools for developing and managing nix itself
{ pkgs, ... }:
let
  hm-up = pkgs.writeShellScriptBin "hm-up" ''
    if [ -d .git ] && [ "$(${pkgs.git}/bin/git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
        FLAKE="$(pwd)"
    else
        FLAKE="github:josh/home-manager"
    fi
    export FLAKE
    echo "Using $FLAKE as home manager flake" >&2

    exec ${pkgs.nh}/bin/nh home switch --backup-extension backup -- --refresh
  '';
in
{
  home.packages = with pkgs; [
    # tool to build/switch to my home-manager config
    hm-up

    # nicer nix cli wrapper
    nh

    # formatter
    nixfmt-rfc-style

    # fetch resource nar hash
    nurl
  ];
}
