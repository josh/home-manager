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
          modules = [
            ./home.nix
            {
              home.username = "codespace";
              home.homeDirectory = "/home/codespace";
            }
          ];
        };

        "runner" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home.username = "runner";
              home.homeDirectory = "/home/runner";
            }
          ];
        };

        "vscode" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home.username = "vscode";
              home.homeDirectory = "/home/vscode";
            }
          ];
        };
      };
    };
}
