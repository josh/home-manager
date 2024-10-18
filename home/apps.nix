{
  lib,
  pkgs,
  config,
  ...
}:
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
      zed-editor

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

        shell.program = lib.getExe pkgs.josh.tmux-attach;

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
