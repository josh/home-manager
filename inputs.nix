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
  decorateInput = pkg: pkg // { path = fetchInput pkg.locked; };
  nixpkgs = decorateInput lock.nodes.nixpkgs;
  catppuccin = decorateInput lock.nodes.catppuccin;
in
{
  inherit nixpkgs;
  catppuccin = catppuccin // {
    outputs = {
      homeManagerModules = import (catppuccin.path + "/modules/home-manager");
      nixosModules = import (catppuccin.path + "/modules/nixos");
    };
  };
}
