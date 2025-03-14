{
  description = "Home Manager configuration of josh";

  nixConfig = {
    extra-substituters = [
      "https://josh.cachix.org"
    ];
    extra-trusted-public-keys = [
      "josh.cachix.org-1:qc8IeYlP361V9CSsSVugxn3o3ZQ6w/9dqoORjm0cbXk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "github:edolstra/flake-compat";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs = {
      url = "github:josh/nurpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixbits = {
      url = "github:josh/nixbits";
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
      nixbits,
      home-manager,
      ...
    }:
    let
      lib = import ./home/lib.nix;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      eachSystem = nixpkgs.lib.genAttrs systems;
      eachPkgs =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ nixbits.overlays.default ];
            };
          in
          f pkgs
        );
      mapMergeList = fn: lst: nixpkgs.lib.mergeAttrsList (builtins.map fn lst);
      treefmt-nix = eachPkgs (pkgs: import ./internal/treefmt.nix pkgs);
    in
    {
      packages = eachPkgs (pkgs: {
        home-manager = home-manager.packages.${pkgs.system}.default;
        home-manager-generation = self.homeConfigurations."runner@${pkgs.system}".activationPackage;
      });

      formatter = eachSystem (system: treefmt-nix.${system}.wrapper);

      checks = {
        aarch64-darwin = {
          treefmt = treefmt-nix.aarch64-darwin.check self;
          build-home-manager-generation = self.homeConfigurations."runner@aarch64-darwin".activationPackage;
        };
        aarch64-linux = {
          treefmt = treefmt-nix.aarch64-linux.check self;
          build-home-manager-generation = self.homeConfigurations."runner@aarch64-linux".activationPackage;
        };
        x86_64-linux = {
          treefmt = treefmt-nix.x86_64-linux.check self;
          build-home-manager-generation = self.homeConfigurations."runner@x86_64-linux".activationPackage;

          nixos = nixpkgs.legacyPackages.x86_64-linux.testers.runNixOSTest {
            name = "nixos";
            nodes.machine = {
              imports = [ self.nixosModules.default ];
              services.openssh.enable = true;
            };
            testScript = ''
              machine.wait_for_unit("multi-user.target")
              machine.require_unit_state("home-manager-josh.service", "inactive")
              machine.succeed("su -- josh -c 'which hello'")
              machine.succeed("su -- josh -c 'test -f /etc/ssh/authorized_keys.d/josh'")
            '';
          };
        };
      };

      homeModules = {
        default = lib.wrapImportInputs inputs ./home;
      };

      homeConfigurations = mapMergeList (system: {
        # For GitHub Actions CI
        "runner@${system}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            self.homeModules.default
            {
              home.username = "runner";
              systemd.user.enable = false;
            }
          ];
        };
      }) systems;

      nixosModules = {
        inherit (home-manager.nixosModules) home-manager;

        default =
          { config, ... }:
          {
            imports = [
              home-manager.nixosModules.home-manager
              (lib.wrapImportInputs inputs ./nixos)
            ];
            home-manager.users.${config.my.username} = self.homeModules.default;
          };
      };
    };
}
