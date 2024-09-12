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
      eachPkgs = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      mapMergeList = fn: lst: nixpkgs.lib.mergeAttrsList (builtins.map fn lst);
      treefmtEval = eachPkgs (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      packages = eachPkgs (pkgs: {
        home-manager = home-manager.defaultPackage.${pkgs.system};
      });

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

      checks =
        eachSystem (system: {
          treefmt = treefmtEval.${system}.config.build.check self;
        })
        // (
          let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            ${system}.nixos = pkgs.testers.runNixOSTest {
              name = "nixos";
              nodes.machine = {
                imports = [ self.nixosModules.default ];
                services.openssh.enable = true;
              };
              testScript = ''
                machine.wait_for_unit("home-manager-josh.service")
                machine.succeed("su -- josh -c 'which hello'")
                machine.succeed("su -- josh -c 'test -f /etc/ssh/authorized_keys.d/josh'")
              '';
            };
          }
        );

      homeModules = {
        default = lib.wrapImportInputs inputs ./home;
      };

      homeConfigurations =
        {
          "codespace" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.default
              {
                home.username = "codespace";
                my.graphical-desktop = false;
                my.powerline-fonts = true;
                my.nerd-fonts = false;
              }
            ];
          };

          "vscode" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              self.homeModules.default
              {
                home.username = "vscode";
                my.graphical-desktop = false;
                my.powerline-fonts = true;
                my.nerd-fonts = false;
              }
            ];
          };
        }
        // mapMergeList (system: {
          "josh@${system}-tui" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              self.homeModules.default
              {
                my.graphical-desktop = false;
                my.powerline-fonts = false;
                my.nerd-fonts = false;
              }
            ];
          };

          "josh@${system}-gui" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              self.homeModules.default
              {
                my.graphical-desktop = true;
                my.powerline-fonts = false;
                my.nerd-fonts = false;
              }
            ];
          };

          # For GitHub Actions CI
          "runner@${system}" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              self.homeModules.default
              {
                home.username = "runner";
                systemd.user.enable = false;
                my.graphical-desktop = false;
                my.cachix.enable = false;
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
