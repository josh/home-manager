_: {
  home = {
    shellAliases = {
      "g" = "git";
    };
  };

  programs = {
    bash = {
      enable = true;
      historyControl = [ "ignorespace" ];
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      history = {
        extended = true;
        ignoreSpace = true;
      };
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    starship = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
