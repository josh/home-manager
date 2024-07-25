{
  lib,
  config,
  pkgs,
  ...
}:
let
  inputs = import ../inputs.nix;
  test-nerd-fonts = pkgs.writeShellScriptBin "test-nerd-fonts" ''
    echo -e "powerline: \ue0a0"
    echo -e "devicons: \ue700"
    echo -e "octicons: \uf408"
    echo -e "emoji: \U0001F40D"
  '';
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

    home.packages = [ test-nerd-fonts ];
  };
}
