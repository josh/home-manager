# Home Manager

My Nix Home Manager.

## Installation

### Standalone

```sh
$ nix run github:josh/home-manager#home-manager -- switch --flake github:josh/home-manager#josh@x86_64-linux-tui
```

### NixOS module

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    josh-home-manager = {
      url = "github:josh/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, josh-home-manager }:
    {
      nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ josh-home-manager.nixosModules.default ];
      };
    };
}
```
