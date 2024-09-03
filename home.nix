# Legacy home.nix stub
let
  lib = import ./home/lib.nix;
in
{
  imports = lib.wrapImportsInputs lib.flakeInputs [ ./home ];
  home.username =
    let
      USER = builtins.getEnv "USER";
      SUDO_USER = builtins.getEnv "SUDO_USER";
    in
    {
      _type = "override";
      content =
        if SUDO_USER != "" then
          SUDO_USER
        else if USER != "" then
          USER
        else
          null;
      priority = 500;
    };
}
