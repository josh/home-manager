{
  lib,
  config,
  pkgs,
  ...
}:
let
  shellAliases = {
    "g" = "git";
  };
in
{
  home.username = lib.mkDefault "josh";
  home.homeDirectory =
    if "${config.home.username}" == "root" then "/root" else "/home/${config.home.username}";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bash
    cowsay
    direnv
    fzf
    git
    hello
    jq
    neofetch
    nixfmt-rfc-style
    nodePackages.prettier
    ripgrep
    shellcheck
    shfmt
    starship
    wget
    zsh
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
    aliases = {
      ci = "commit";
    };
  };

  programs.bash = {
    enable = true;
    inherit shellAliases;
  };

  programs.zsh = {
    enable = true;
    inherit shellAliases;
  };

  programs.starship = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.home-manager.enable = true;
}
