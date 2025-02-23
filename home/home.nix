# Configure user and home directory itself.
args@{
  lib,
  config,
  pkgs,
  ...
}:
{
  home = {
    username = lib.mkDefault "josh";
    homeDirectory =
      if "${config.home.username}" == "root" then "/root" else "/home/${config.home.username}";
  };
  home.packages =
    with pkgs;
    [
      hello
      nixbits.deadsymlinks
      nixbits.test-fonts
      nixbits.touch-cachedir-tag

      # vcs
      gh
      nixbits.git
      (nixbits.lazygit.override { useNerdFonts = config.my.nerd-fonts; })

      # nix tools
      cachix
      deadnix
      devenv
      nh
      nix-tree
      nixd
      # nixfmt
      nixfmt-rfc-style
      nixos-generators
      nurl
      statix
    ]
    ++ (lib.lists.optional (builtins.hasAttr "nixosConfig" args) pkgs.josh.os-up);
}
