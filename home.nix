# Legacy home.nix stub
{
  imports = [ ./home ];
  home.username = builtins.getEnv "USER";
}
