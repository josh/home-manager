{ lib, config, ... }:
{
  imports = [
    ./home/git.nix
    ./home/neovim.nix
    ./home/scripts.nix
    ./home/shell.nix
    ./home/theme.nix
    ./home/utils.nix
  ];

  home = {
    username = lib.mkDefault "josh";
    homeDirectory =
      if "${config.home.username}" == "root" then "/root" else "/home/${config.home.username}";
    stateVersion = "24.05";
  };

  news.display = "silent";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
