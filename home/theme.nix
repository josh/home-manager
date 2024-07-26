{
  lib,
  config,
  pkgs,
  ...
}:
let
  inputs = import ../inputs.nix;
  test-fonts = pkgs.writeShellScriptBin "test-fonts" ''
    echo -e "powerline: \ue0a0"
    echo -e "devicons: \ue700"
    echo -e "octicons: \uf408"
    echo -e "emoji: \U0001F40D"
  '';
in
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  options = {
    theme = lib.mkOption {
      default = "";
      type = lib.types.enum [
        ""
        "catppuccin-frappe"
        "catppuccin-latte"
        "catppuccin-macchiato"
        "catppuccin-mocha"
        "tokyonight"
      ];
    };

    powerline-fonts = lib.mkOption {
      description = "Enable Powerline Fonts";
      type = lib.types.bool;
      default = config.nerd-fonts;
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
    catppuccin = lib.mkIf (lib.strings.hasPrefix "catppuccin-" config.theme) {
      enable = true;
      flavor = lib.strings.removePrefix "catppuccin-" config.theme;
    };

    home.packages = [ test-fonts ];
  };
}
