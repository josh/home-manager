{
  description = "Home Manager configuration of josh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.x86_64-linux.default = home-manager.defaultPackage.x86_64-linux;
      packages.x86_64-linux.nixfmt = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      homeConfigurations = {
        "codespace" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.username = "codespace";
          modules = [ ./home.nix ];
        };

        "root" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.username = "root";
          modules = [ ./home.nix ];
        };

        "runner" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.username = "runner";
          modules = [ ./home.nix ];
        };

        "vscode" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.username = "vscode";
          modules = [ ./home.nix ];
        };
      };
    };
}
