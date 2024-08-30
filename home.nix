# Legacy home.nix stub
let
  lib = import ./home/lib.nix;
in
{
  imports = lib.wrapImportsInputs lib.flakeInputs [ ./home ];
  home.username = lib.mkDefault 500 (builtins.getEnv "USER");
}
