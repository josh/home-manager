{ inputs, ... }:
let
  lib = import ./lib.nix;
in
{
  imports = lib.wrapImportsInputs inputs [
    ./apps.nix
    ./git.nix
    ./home.nix
    ./manager.nix
    ./nix.nix
    ./shell.nix
    ./theme.nix
    ./utils.nix
  ];

  nixpkgs.overlays = [
    inputs.lazy-nvim-nix.overlays.default
    inputs.nixbits.overlays.default
    (import ../overlay.nix)
  ];
}
