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
    ./neovim.nix
    ./nix.nix
    ./scripts.nix
    ./shell.nix
    ./theme.nix
    ./utils.nix
  ];
}
