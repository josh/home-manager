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
  options.my = {
    graphical-desktop = lib.mkOption {
      description = "Enable Graphical Desktop features";
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.my.graphical-desktop {
    home.packages = with pkgs; [
      neovide
      obsidian

      # Fonts
      cascadia-code
      fira-code
      jetbrains-mono
      meslo-lg
    ];

    fonts.fontconfig.enable = true;

    # Terminals, I can't decide
    programs.kitty.enable = true;
    programs.wezterm.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        # import = [ ];

        shell.program = "${tmux-attach}/bin/tmux-attach";

        font.normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
      };
    };

    programs.vscode = {
      enable = true;
    };

    programs.firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
      };
    };
  };
}
