{ inputs, ... }:
let
  bindInputs = path: (args@{ pkgs, ... }: import path ({ inherit inputs pkgs; } // args));
in
{
  imports = [
    ./git.nix
    ./home.nix
    ./manager.nix
    (bindInputs ./neovim.nix)
    (bindInputs ./nix.nix)
    ./scripts.nix
    ./shell.nix
    (bindInputs ./theme.nix)
    ./utils.nix
  ];
}
