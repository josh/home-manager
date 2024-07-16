{
  config,
  pkgs,
  username,
  ...
}:

{
  home.username = "${username}";
  home.homeDirectory = if "${username}" == "root" then "/root" else "/home/${username}";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bash
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
