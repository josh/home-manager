{ lib, config, ... }:
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
    programs.alacritty.enable = true;
    programs.kitty.enable = true;
    programs.wezterm.enable = true;

    programs.firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
      };
    };
  };
}
