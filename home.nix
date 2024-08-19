# Legacy home.nix stub
let
  inputs =
    let
      lock = builtins.fromJSON (builtins.readFile ./flake.lock);
      node = lock.nodes.flake-compat.locked;
      inherit (node) owner repo rev;
      path = fetchTarball {
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
        sha256 = node.narHash;
      };
      flake = import path { src = ./.; };
    in
    flake.defaultNix.inputs;
in
{
  imports = [ (args@{ pkgs, ... }: import ./home ({ inherit inputs pkgs; } // args)) ];
  home.username = builtins.getEnv "USER";
}
