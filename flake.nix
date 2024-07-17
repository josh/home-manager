{
  description = "Home Manager configuration of josh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      packages.x86_64-linux.home-manager = home-manager.defaultPackage.x86_64-linux;
      packages.x86_64-linux.nixfmt = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      homeConfigurations = {
        "codespace" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.username = "codespace";
          modules = [
            ./home.nix
            { home.username = "codespace"; }
          ];
        };

        # Surface WSL user
        "root@Surface" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            ./home.nix
            { home.username = "root"; }
          ];
        };

        "runner" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            { home.username = "runner"; }
          ];
        };

        "vscode" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            { home.username = "vscode"; }
          ];
        };
      };
    };
}
