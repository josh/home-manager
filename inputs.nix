let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lock.nodes.flake-compat.locked;
  owner = node.owner;
  repo = node.repo;
  rev = node.rev;
  path = fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = node.narHash;
  };
  flake = import path { src = ./.; };
in
flake.defaultNix.inputs
