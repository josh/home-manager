{ lib, pkgs, ... }:
let
  inputs = import ../inputs.nix;
  lazy-nvim-nix-lib = inputs.lazy-nvim-nix.lib;
  lazyvim-pkgs = lazy-nvim-nix-lib.extractLazyVimPackages { inherit pkgs; };
  toLua = lazy-nvim-nix-lib.toLua lib;

  # TODO: Upstream luvit-meta to nixpkgs

  lazyPlugins =
    builtins.removeAttrs
      (lazyvim-pkgs."lazyvim.plugins" // lazyvim-pkgs."lazyvim.plugins.extras.coding.copilot")
      [
        "nvim-treesitter"
        "nvim-treesitter-textobjects"
      ];
  lazyDevPath = pkgs.linkFarm "lazy-dev" lazyPlugins;
in
{
  xdg.configFile = {
    "nvim/lua/config/autocmds.lua" = {
      source = ./neovim/lua/config/autocmds.lua;
    };
    "nvim/lua/config/keymaps.lua" = {
      source = ./neovim/lua/config/keymaps.lua;
    };
    "nvim/lua/config/lazy.lua" = {
      source = ./neovim/lua/config/lazy.lua;
    };
    "nvim/lua/config/options.lua" = {
      source = ./neovim/lua/config/options.lua;
    };
    "nvim/lua/plugins/example.lua" = {
      source = ./neovim/lua/plugins/example.lua;
    };
    "nvim/lua/plugins/001-nix-store.lua" = {
      text =
        let
          nixStoreSpec = lib.attrsets.mapAttrsToList (name: dir: { inherit name dir; }) lazyPlugins;
          spec = nixStoreSpec ++ [
            {
              name = "LazyVim";
              dir = pkgs.vimPlugins.LazyVim;
              import = "lazyvim.plugins";
            }
            { import = "lazyvim.plugins.extras.coding.copilot"; }
          ];
        in
        ''return ${toLua spec}'';
    };
  };

  xdg.dataFile = {
    "nvim/lazy-dev" = {
      source = lazyDevPath;
    };
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    extraPackages = with pkgs; [
      clang
      fd
      fish
      gcc
      git
      lazygit
      lua
      lua-language-server
      luarocks
      nil
      nix
      nixd
      nixfmt-rfc-style
      nodejs_22
      python3
      ripgrep
      ruby
      shellcheck
      shfmt
      stylua
      tree-sitter
      zig
    ];

    extraLuaConfig = ''


      require("config.lazy")
    '';
  };
}
