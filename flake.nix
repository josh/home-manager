{
  description = "Home Manager configuration of josh";

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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        devshell.follows = "";
        flake-compat.follows = "flake-compat";
        git-hooks.follows = "";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "";
        nixpkgs.follows = "nixpkgs";
        nuschtosSearch.follows = "";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
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
      treefmt = forAllSystems (
        system:
        treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs = {
            actionlint.enable = true;
            deadnix.enable = true;
            nixfmt.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
          };
        }
      );
    in
    {
      packages = forAllSystems (system: {
        home-manager = home-manager.defaultPackage.${system};
      });

      formatter = forAllSystems (system: treefmt.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        treefmt = treefmt.${system}.config.build.check self;
      });

      homeConfigurations = {
        "codespace" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs.username = "codespace";
          modules = [
            ./home.nix
            {
              home.username = "codespace";
              powerline-fonts = true;
              nerd-fonts = false;
            }
          ];
        };

        # Surface WSL user
        "root@Surface" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            ./home.nix
            {
              home.username = "root";
              theme = "catppuccin-macchiato";
              nerd-fonts = true;
            }
          ];
        };

        "runner" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
            { home.username = "runner"; }
          ];
        };

        "vscode" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
            {
              home.username = "vscode";
              powerline-fonts = true;
              nerd-fonts = false;
            }
          ];
        };
      };

      nixosConfigurations = {
        "Surface" = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/virtualisation/build-vm.nix"
            {
              # boot.isContainer = true;
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
              virtualisation.vmVariant.virtualisation.graphics = false;
              system.stateVersion = "24.11";
            }
            {
              users.users.josh = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
                initialPassword = "swordfish";
              };
              services.getty.autologinUser = "josh";
              security.sudo.wheelNeedsPassword = false;
            }
            home-manager.nixosModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              #home-manager.users.josh = import ./home.nix;
              home-manager.users.josh =
                { ... }:
                {
                  home.file."foo".text = "bar";
                  home.stateVersion = "24.11";
                };
            }
          ];
        };
      };
    };
}
