# Legacy nixos.nix stub
let
  lib = import ./home/lib.nix;
in
lib.flake.nixosModules.default
