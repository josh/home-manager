{
  lib,
  pkgs,
  config,
  ...
}:
let
  tmux-attach = pkgs.writeShellScriptBin "tmux-attach" ''
    session=$(${pkgs.tmux}/bin/tmux list-sessions -F "#{session_name}" -f "#{?session_attached,0,1}" 2>/dev/null | ${pkgs.coreutils}/bin/head -n 1)
    if [ -n "$session" ]; then
      ${pkgs.tmux}/bin/tmux attach-session -t "$session"
    else
      ${pkgs.tmux}/bin/tmux new-session
    fi
  '';
in
{
  options = {
    graphical-desktop = lib.mkOption {
      description = "Enable Graphical Desktop features";
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.graphical-desktop {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Fonts
      cascadia-code
      fira-code
      jetbrains-mono
      meslo-lg
    ];

    # Terminals, I can't decide
    programs.kitty.enable = true;
    programs.wezterm.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        import = [
          "${inputs.dotfiles}/config/alacritty/themes/tokyonight_moon.toml"
        ];

        shell.program = tmux-attach;

        font.normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
      };
    };

    programs.firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
      };
    };
  };
}
