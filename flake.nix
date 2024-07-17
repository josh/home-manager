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
    };
}
