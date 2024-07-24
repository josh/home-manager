{ lib, config, ... }:
let
  inputs = import ../inputs.nix;
in
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  options.theme = lib.mkOption {
    default = "";
    type = lib.types.enum [
      ""
      "catppuccin"
      "tokyonight"
    ];
  };

  config = {
    catppuccin = lib.mkIf (config.theme == "catppuccin") {
      enable = true;
      flavor = "mocha";
    };
  };
}
