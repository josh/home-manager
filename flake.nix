{
  description = "Home Manager configuration of josh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      packages = forAllSystems (system: {
        home-manager = home-manager.defaultPackage.${system};
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      checks = forAllSystems (system: {
        check-format =
          nixpkgs.legacyPackages.${system}.runCommandLocal "check-format"
            {
              src = ./.;
              nativeBuildInputs = with nixpkgs.legacyPackages.${system}; [
                nixfmt-rfc-style
                nodePackages.prettier
              ];
            }
            ''
              nixfmt --check ${./.}
              prettier --check ${./.github}
              touch "$out"
            '';
      });

      homeConfigurations = {
        "codespace" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
            { home.username = "vscode"; }
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
