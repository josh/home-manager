{
  description = "Home Manager configuration of josh";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://josh.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      treefmt-nix,
      home-manager,
      dotfiles,
      ...
    }:
    let
      lib = import ./home/lib.nix;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      linuxSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mapMergeList = fn: lst: nixpkgs.lib.mergeAttrsList (builtins.map fn lst);
      treefmtEval = forAllSystems (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      packages = forAllSystems (system: {
        home-manager = home-manager.defaultPackage.${system};
        dotfiles = derivation {
          inherit system;
          name = "dotfiles";
          builder = "${nixpkgs.legacyPackages.${system}.coreutils}/bin/ln";
          args = [
            "-s"
            dotfiles
            (builtins.placeholder "out")
          ];
        };
      });

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        treefmt = treefmtEval.${system}.config.build.check self;
      });

      homeModules = {
        default = lib.wrapImportInputs inputs ./home;
        tui = {
          imports = [ self.homeModules.default ];
          my.graphical-desktop = false;
        };
        gui = {
          imports = [ self.homeModules.default ];
          my.graphical-desktop = true;
        };
      };

      homeConfigurations =
        {
          "codespace" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.tui
              {
                home.username = "codespace";
                my.powerline-fonts = true;
                my.nerd-fonts = false;
              }
            ];
          };

          "vscode" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.tui
              {
                home.username = "vscode";
                my.powerline-fonts = true;
                my.nerd-fonts = false;
              }
            ];
          };
        }
        // mapMergeList (system: {
          # For GitHub Actions CI
          "runner@${system}" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              self.homeModules.tui
              {
                home.username = "runner";
                systemd.user.enable = false;
                my.cachix.enable = false;
              }
            ];
          };
        }) systems;

      nixosModules = {
        inherit (home-manager.nixosModules) home-manager;

        default = {
          imports = [
            home-manager.nixosModules.home-manager
            ./nixos
          ];
        };

        tui = {
          imports = [ self.nixosModules.default ];
        };

        gui = {
          imports = [ self.nixosModules.default ];
        };

        test =
          { config, ... }:
          let
            inherit (config.my) username;
          in
          {
            imports = [ self.nixosModules.default ];
            boot.isContainer = true;
            system.stateVersion = nixpkgs.lib.trivial.release;
            home-manager.users.${username} = self.homeModules.default;
          };
      };

      nixosConfigurations = mapMergeList (system: {
        # For GitHub Actions CI
        "test-${system}" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            self.nixosModules.test
            { my.username = "runner"; }
          ];
        };
      }) linuxSystems;
    };
}
