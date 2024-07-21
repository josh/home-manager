_:
let
  inputs = import ../inputs.nix;
in
{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
