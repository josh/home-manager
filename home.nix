# Legacy home.nix stub
let
  lib = import ./home/lib.nix;
in
{
  imports = lib.wrapImportsInputs lib.flakeInputs [ ./home ];
  home.username = {
    _type = "override";
    content = builtins.getEnv "USER";
    priority = 500;
  };
}
