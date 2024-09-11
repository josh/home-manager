# Tools for developing and managing nix itself
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cachix-push = pkgs.writeShellScriptBin "cachix-push" ''
    if [ -n "$CACHIX_AUTH_TOKEN" ] || [ -f "$HOME/.config/cachix/cachix.dhall" ]; then
      exec ${pkgs.cachix}/bin/cachix push josh "$1"
    else
      echo "cachix not configured, run cachix authtoken <TOKEN>" >&2
      exit 0
    fi
  '';

  os-up = pkgs.writeShellScriptBin "os-up" ''
    set -euo pipefail

    ${pkgs.nh}/bin/nh os switch --out-link /tmp/os-up-result
    ${cachix-push}/bin/cachix-push /tmp/hm-up-result
  '';

  hm-up = pkgs.writeShellScriptBin "hm-up" ''
    set -euo pipefail

    if [ -d .git ] && [ "$(${pkgs.git}/bin/git remote get-url origin)" = "https://github.com/josh/home-manager" ]; then
        FLAKE="$(pwd)"
    else
        FLAKE="github:josh/home-manager"
    fi
    export FLAKE
    echo "Using $FLAKE as home manager flake" >&2

    ${pkgs.nh}/bin/nh home switch --backup-extension backup --out-link /tmp/hm-up-result -- --refresh
    ${cachix-push}/bin/cachix-push /tmp/hm-up-result
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
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        accept-flake-config = true;
        substituters = [
          "https://cache.nixos.org"
          "https://josh.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
        ];
      };
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

        # tool to build/switch to my NixOS config
        os-up

        # linter
        statix
      ]
      ++
        # Allow cachix to be disabled in CI where it might be already installed
        (lib.lists.optional config.cachix.enable pkgs.cachix);
  };
}
