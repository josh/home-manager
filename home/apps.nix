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
