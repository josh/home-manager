{
  config,
  pkgs,
  username,
  ...
}:

{
  home.username = "${username}";
  home.homeDirectory = if "${username}" == "root" then "/root" then "/home/${username}";

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.bash
    pkgs.direnv
    pkgs.fzf
    pkgs.git
    pkgs.hello
    pkgs.jq
    pkgs.nixfmt-rfc-style
    pkgs.nodePackages.prettier
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.starship
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

  programs.bash = {
    enable = true;

    shellAliases = {
      "g" = "git";
    };
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      "g" = "git";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.home-manager.enable = true;
}
