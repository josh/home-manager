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

    tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      escapeTime = 0;
      secureSocket = false;

      plugins = with pkgs.tmuxPlugins; [
        { plugin = yank; }
        { plugin = vim-tmux-navigator; }
      ];

      catppuccin.extraConfig = ''
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

      extraConfig = ''
        set-option -sa terminal-overrides ',xterm-256color:RGB'

        set-option -g status-position top

        bind-key c new-window -c "#{pane_current_path}"
        bind-key | split-window -h -c "#{pane_current_path}"
        bind-key - split-window -v -c "#{pane_current_path}"
      '';
    };

    starship =
      let
        preset = name: (lib.importTOML "${pkgs.starship}/share/starship/presets/${name}.toml");
      in
      {
        enable = config.powerline-fonts;
        settings = lib.mkMerge [
          (lib.mkIf (!config.nerd-fonts) (preset "no-nerd-font"))
          (lib.mkIf config.catppuccin.enable (
            # https://github.com/catppuccin/starship/blob/ca2fb06/starship.toml
            {
              directory.style = "bold lavender";
              palette = "catppuccin_${config.catppuccin.flavor}";
            }
            // (lib.importTOML "${config.catppuccin.sources.starship}/themes/${config.catppuccin.flavor}.toml")
          ))
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
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
