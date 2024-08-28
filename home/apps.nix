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
    programs.firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
      };
    };
  };
}
