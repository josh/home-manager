# Tools for developing and managing nix itself
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  hm-up = pkgs.writeShellScriptBin "hm-up" ''
    set -e

    if [ -d .git ] && [ "$(${pkgs.git}/bin/git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
        FLAKE="$(pwd)"
    else
        FLAKE="github:josh/home-manager"
    fi
    export FLAKE
    echo "Using $FLAKE as home manager flake" >&2

    ${pkgs.nh}/bin/nh home switch --backup-extension backup --out-link /tmp/hm-up-result -- --refresh

    if [ -n "$CACHIX_AUTH_TOKEN" ] || [ -f "$HOME/.config/cachix/cachix.dhall" ]; then
      ${pkgs.cachix}/bin/cachix push josh /tmp/hm-up-result
    else
      echo "cachix not configured, run cachix authtoken <TOKEN>" >&2
    fi
  '';
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options = {
    cachix.enable = lib.mkEnableOption "cachix";
  };

  config = {
    nix = {
      package = lib.mkDefault pkgs.nix;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Enable nix-index and prebuilt nix-index-database.
    # $ , cowsay "hello"
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.nix-index-database.comma.enable = true;

    home.packages =
      with pkgs;
      [
        # find dead nix code
        deadnix

        # tool to build/switch to my home-manager config
        hm-up

        # nicer nix cli wrapper
        nh

        nix-tree

        # nix language server
        nixd

        # formatter
        # nixfmt
        nixfmt-rfc-style

        # build nixos based images
        nixos-generators

        # fetch resource nar hash
        nurl

        # linter
        statix
      ]
      ++
        # Allow cachix to be disabled in CI where it might be already installed
        (lib.lists.optional config.cachix.enable pkgs.cachix);
  };
}
