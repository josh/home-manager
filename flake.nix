{
  description = "Home Manager configuration of josh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-compat.url = "github:nix-community/flake-compat";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:josh/dotfiles";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazy-nvim-nix = {
      url = "github:josh/lazy-nvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      home-manager,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      treefmtEval = forAllSystems (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      packages = forAllSystems (system: {
        home-manager = home-manager.defaultPackage.${system};
      });

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        treefmt = treefmtEval.${system}.config.build.check self;
      });

      homeModules.default = import ./home.nix;

      homeConfigurations = {
        "codespace" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs.username = "codespace";
          modules = [
            self.homeModules.default
            {
              home.username = "codespace";
              powerline-fonts = true;
              nerd-fonts = false;
            }
          ];
        };

        "runner" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            self.homeModules.default
            { home.username = "runner"; }
          ];
        };

        "vscode" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            self.homeModules.default
            {
              home.username = "vscode";
              powerline-fonts = true;
              nerd-fonts = false;
            }
          ];
        };
      };
    };
}
