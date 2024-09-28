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
  mypkgs = import ../pkgs pkgs;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.my = {
    cachix.enable = lib.mkOption {
      default = false;
      example = true;
      description = "Whether to enable cachix.";
      type = lib.types.bool;
    };
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
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    programs.nix-index-database.comma.enable = true;

    home.packages =
      with pkgs;
      [
        # find dead nix code
        deadnix

        devenv

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

        # tools to build/switch to my NixOS and home-manager config
        (if isNixOS then mypkgs.os-up else mypkgs.hm-up)
      ]
      ++
        # Allow cachix to be disabled in CI where it might be already installed
        (lib.lists.optional config.my.cachix.enable pkgs.cachix);
  };
}
