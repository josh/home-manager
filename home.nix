# Legacy home.nix stub
{ lib, ... }:
let
  internalLib = import ./home/lib.nix;
in
{
  imports = internalLib.wrapImportsInputs lib.flakeInputs [ ./home ];
  home.username = lib.mkDefault 500 (builtins.getEnv "USER");
}
