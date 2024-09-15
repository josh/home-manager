# Tools for developing and managing nix itself
args@{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  isNixOS = builtins.hasAttr "nixosConfig" args;

  nixos-detect =
    if isNixOS then
      (pkgs.writeShellScriptBin "nixos-detect" ''
        echo "You're running NixOS"
      '')
    else
      (pkgs.writeShellScriptBin "nixos-detect" ''
        echo "You're running Home Manager standalone"
      '');

  patchShellScript = (import ./lib.nix).patchShellScript pkgs;

  cachix-push = patchShellScript ./bin/cachix-push.sh [ pkgs.cachix ];
  os-up = patchShellScript ./bin/os-up.sh [
    cachix-push
    pkgs.nh
    pkgs.nix
  ];
  hm-up = patchShellScript ./bin/hm-up.sh [
    cachix-push
    pkgs.git
    pkgs.nh
    pkgs.nix
  ];
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.my = {
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

        # Test program
        nixos-detect
      ]
      ++
        # Allow cachix to be disabled in CI where it might be already installed
        (lib.lists.optional config.my.cachix.enable pkgs.cachix);
  };
}
