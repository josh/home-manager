# Configure user and home directory itself.
args@{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    username = lib.mkDefault "josh";
    homeDirectory =
      if "${config.home.username}" == "root" then "/root" else "/home/${config.home.username}";
  };
  home.packages = [
    (pkgs.josh.home-path.override {
      installationEnv = if (builtins.hasAttr "nixosConfig" args) then "nixos" else "home-manager";
      useNerdFonts = config.my.nerd-fonts;
    })
  ];
}
