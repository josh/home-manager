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
      homeConfigurations."codespace" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-codespace.nix ];
      };

      homeConfigurations."runner" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-runner.nix ];
      };

      homeConfigurations."vscode" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-vscode.nix ];
      };
    };
}
