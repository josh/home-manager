let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  fetchInput =
    {
      type,
      owner,
      repo,
      rev,
      narHash,
      ...
    }:
    assert type == "github";
    fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      sha256 = narHash;
    };
  wrap =
    pkg: buildOutputs:
    let
      path = fetchInput pkg.locked;
      outputs = buildOutputs path;
    in
    pkg // { inherit path outputs; };
in
{
  nixpkgs = wrap lock.nodes.nixpkgs (path: {
    default = import path;
  });

  home-manager = wrap lock.nodes.home-manager (path: {
    default = import path;
  });

  catppuccin = wrap lock.nodes.catppuccin (path: {
    homeManagerModules = import "${path}/modules/home-manager";
    nixosModules = import "${path}/modules/nixos";
  });
}
