{ config, pkgs, ... }:

{
  # home.username = "josh";
  # home.homeDirectory = "/home/josh";

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.git
    pkgs.hello
    pkgs.jq
    pkgs.neovim
    pkgs.nixfmt-rfc-style
    pkgs.nodePackages.prettier
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.wget
    pkgs.zsh
  ];

  home.file = { };

  home.sessionVariables = { };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userEmail = "josh@users.noreply.github.com";
    userName = "Joshua Peek";
  };

  programs.home-manager.enable = true;
}
