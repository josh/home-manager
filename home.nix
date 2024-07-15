{ config, pkgs, ... }:

{
  home.username = "codespace";
  home.homeDirectory = "/home/codespace";

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.hello
    pkgs.nixfmt-rfc-style
    pkgs.nodePackages.prettier
    pkgs.shellcheck
    pkgs.shfmt
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
