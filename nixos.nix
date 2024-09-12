# Legacy nixos.nix stub
let
  lib = import ./home/lib.nix;
  maybeHomeManager = builtins.tryEval <home-manager/nixos>;
  homeManager =
    if maybeHomeManager.success then
      (import maybeHomeManager.value)
    else
      (builtins.trace "[1;31mwarning: Missing home-manager channel, using flake.lock" lib.flakeInputs.home-manager.nixosModules.home-manager);
  homeModule = {
    imports = lib.wrapImportsInputs lib.flakeInputs [ ./home ];
  };
in
{ config, ... }:
{
  imports = [
    homeManager
    ./nixos
  ];
  home-manager.users.${config.my.username} = homeModule;
}
