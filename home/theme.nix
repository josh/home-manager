{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  theme-backgrounds = {
    "" = "dark";
    "Catppuccin Frappé" = "dark";
    "Catppuccin Latte" = "light";
    "Catppuccin Macchiato" = "dark";
    "Catppuccin Mocha" = "dark";
    "Rosé Pine Dawn" = "light";
    "Rosé Pine Moon" = "dark";
    "Rosé Pine" = "dark";
    "Tokyo Night Day" = "light";
    "Tokyo Night Moon" = "dark";
    "Tokyo Night Storm" = "dark";
    "Tokyo Night" = "dark";
  };
in
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  options.my = {
    theme = lib.mkOption {
      default = "";
      type = lib.types.enum [
        ""
        "Catppuccin Frappé"
        "Catppuccin Latte"
        "Catppuccin Macchiato"
        "Catppuccin Mocha"
        "Rosé Pine Dawn"
        "Rosé Pine Moon"
        "Rosé Pine"
        "Tokyo Night Day"
        "Tokyo Night Moon"
        "Tokyo Night Storm"
        "Tokyo Night"
      ];
    };

    background = lib.mkOption {
      description = "Is background in light or dark mode";
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = theme-backgrounds.${config.my.theme};
      example = "dark";
    };

    powerline-fonts = lib.mkOption {
      description = "Enable Powerline Fonts";
      type = lib.types.bool;
      default = config.my.nerd-fonts;
      example = true;
    };

    nerd-fonts = lib.mkOption {
      description = "Enable Nerd Fonts";
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = {
    catppuccin = lib.mkIf (lib.strings.hasPrefix "Catppuccin" config.my.theme) {
      enable = true;
      flavor =
        if config.my.theme == "Catppuccin Frappé" then
          "frappe"
        else if config.my.theme == "Catppuccin Latte" then
          "latte"
        else if config.my.theme == "Catppuccin Macchiato" then
          "macchiato"
        else
          "mocha";
    };

    home.packages = with pkgs; [ josh.test-fonts ];
  };
}
