_:
let
  inputs = import ../inputs.nix;
in
{
  imports = [ inputs.catppuccin.outputs.homeManagerModules ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
