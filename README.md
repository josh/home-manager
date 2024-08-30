# Home Manager

My Nix Home Manager.

## Installation

### Flakes

#### Standalone

```sh
$ nix run github:josh/home-manager#home-manager -- switch --flake github:josh/home-manager
```

#### NixOS module

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
        modules = [
          josh-home-manager.nixosModules.default
          {
            # TODO: Automatically include this
            home-manager.users.josh = {
              imports = [ josh-home-manager.homeModules.default ];
            };
          }
        ];
      };
    };
}
```

### Channels

```sh
$ nix-channel --add https://github.com/josh/home-manager/archive/main.tar.gz josh-home-manager
$ nix-channel --update
```

#### NixOS module

```nix
{ config, pkgs, ... }:
{
  imports = [ <josh-home-manager/nixos> ];

  # TODO: Automatically include this
  home-manager.users.josh = {
    imports = [ <josh-home-manager/home> ];
  };
}
```
