{
  lib,
  pkgs,
  config,
  ...
}:
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
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [ "--login" ];
        };

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
