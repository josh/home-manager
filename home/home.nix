# Configure user and home directory itself.
{
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
  home.packages = [ pkgs.josh.home-path ];
}
