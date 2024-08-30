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
          graphical-desktop = false;
        };
        gui = {
          imports = [ self.homeModules.default ];
          graphical-desktop = true;
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
                powerline-fonts = true;
                nerd-fonts = false;
              }
            ];
          };

          "vscode" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.tui
              {
                home.username = "vscode";
                powerline-fonts = true;
                nerd-fonts = false;
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

        test = {
          imports = [ self.nixosModules.default ];
          boot.isContainer = true;
          system.stateVersion = nixpkgs.lib.trivial.release;
          home-manager.users.root = self.homeModules.default;
        };
      };

      nixosConfigurations = mapMergeList (system: {
        # For GitHub Actions CI
        "test-${system}" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ self.nixosModules.test ];
        };
      }) linuxSystems;
    };
}
