let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  catppuccin = lock.nodes.catppuccin.locked;
in
import (
  fetchTarball {
    url = "https://github.com/catppuccin/nix/archive/${catppuccin.rev}.tar.gz";
    sha256 = catppuccin.narHash;
  }
  + "/modules/home-manager"
)
