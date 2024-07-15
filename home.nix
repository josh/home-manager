{ config, pkgs, ... }:

{
  home.username = "codespace";
  home.homeDirectory = "/home/codespace";

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.git
    pkgs.hello
    pkgs.nixfmt-rfc-style
    pkgs.nodePackages.prettier
    pkgs.shellcheck
    pkgs.shfmt
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "josh@users.noreply.github.com";
    userName = "Joshua Peek";
  };

  programs.home-manager.enable = true;
}
