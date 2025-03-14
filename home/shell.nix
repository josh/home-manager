{
  lib,
  config,
  pkgs,
  ...
}:
{
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
        share = false;
      };
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    fish = {
      enable = true;
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      baseIndex = 1;
      mouse = true;
      escapeTime = 0;
      secureSocket = false;

      plugins = with pkgs.tmuxPlugins; [
        { plugin = yank; }
        { plugin = vim-tmux-navigator; }
      ];

      extraConfig = ''
        set-option -sa terminal-features "$TERM:RGB"

        set-option -g status-position top

        bind-key c new-window -c "#{pane_current_path}"
        bind-key | split-window -h -c "#{pane_current_path}"
        bind-key - split-window -v -c "#{pane_current_path}"
      '';
    };

    # zellij = {
    #   enable = true;
    # };

    starship =
      let
        preset = name: (lib.importTOML "${pkgs.starship}/share/starship/presets/${name}.toml");
      in
      {
        enable = config.my.powerline-fonts;
        settings = lib.mkMerge [
          (lib.mkIf (!config.my.nerd-fonts) (preset "no-nerd-font"))
        ];
      };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    less.enable = true;

    bat = {
      enable = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };

  catppuccin.tmux.extraConfig = ''
    set-option -g @catppuccin_window_left_separator ""
    set-option -g @catppuccin_window_right_separator " "
    set-option -g @catppuccin_window_middle_separator " █"
    set-option -g @catppuccin_window_number_position "right"

    set-option -g @catppuccin_window_default_fill "number"
    set-option -g @catppuccin_window_default_text "#W"

    set-option -g @catppuccin_window_current_fill "number"
    set-option -g @catppuccin_window_current_text "#W"

    set-option -g @catppuccin_status_modules_right "directory user host session"
    set-option -g @catppuccin_status_left_separator  " "
    set-option -g @catppuccin_status_right_separator ""
    set-option -g @catppuccin_status_fill "icon"
    set-option -g @catppuccin_status_connect_separator "no"

    set-option -g @catppuccin_directory_text "#{pane_current_path}"
  '';
}
