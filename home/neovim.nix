{ lib, pkgs, ... }:
let
  inputs = import ../inputs.nix;
  lazy-nvim-nix-lib = inputs.lazy-nvim-nix.lib;
  lazyvim-pkgs = lazy-nvim-nix-lib.extractLazyVimPackages { inherit pkgs; };
  toLua = lazy-nvim-nix-lib.toLua lib;

  # TODO: Upstream luvit-meta to nixpkgs
  luvit-meta = pkgs.vimUtils.buildVimPlugin {
    name = "luvit-meta";
    src = pkgs.fetchFromGitHub {
      owner = "Bilal2453";
      repo = "luvit-meta";
      rev = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60";
      hash = "sha256-zAAptV/oLuLAAsa2zSB/6fxlElk4+jNZd/cPr9oxFig=";
    };
  };

  lazyPlugins =
    lazyvim-pkgs."lazyvim.plugins.coding"
    // lazyvim-pkgs."lazyvim.plugins.colorscheme"
    // lazyvim-pkgs."lazyvim.plugins.editor"
    // lazyvim-pkgs."lazyvim.plugins.extras.editor.fzf"
    // lazyvim-pkgs."lazyvim.plugins.extras.editor.telescope"
    // lazyvim-pkgs."lazyvim.plugins.linting"
    // lazyvim-pkgs."lazyvim.plugins.ui"
    // (with pkgs.vimPlugins; {
      "catppuccin" = catppuccin-nvim;
      "cmp-buffer" = cmp-buffer;
      "cmp-nvim-lsp" = cmp-nvim-lsp;
      "cmp-path" = cmp-path;
      "conform.nvim" = conform-nvim;
      "copilot-cmp" = copilot-cmp;
      "copilot.lua" = copilot-lua;
      "dressing.nvim" = dressing-nvim;
      "flash.nvim" = flash-nvim;
      "friendly-snippets" = friendly-snippets;
      "luvit-meta" = luvit-meta;
      "mason-lspconfig.nvim" = mason-lspconfig-nvim;
      "mason.nvim" = mason-nvim;
      "mini.ai" = mini-nvim;
      "mini.icons" = mini-nvim;
      "mini.pairs" = mini-nvim;
      "nvim-snippets" = nvim-snippets;
      "nvim-spectre" = nvim-spectre;
      "nvim-treesitter" = nvim-treesitter;
      "nvim-treesitter-textobjects" = nvim-treesitter-textobjects;
      "nvim-ts-autotag" = nvim-ts-autotag;
      "persistence.nvim" = persistence-nvim;
      "plenary.nvim" = plenary-nvim;
      "telescope-fzf-native.nvim" = telescope-fzf-native-nvim;
    });
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
          pluginsSpec = lib.attrsets.mapAttrsToList (name: dir: { inherit name dir; }) lazyPlugins;
          spec = [
            {
              name = "LazyVim";
              dir = pkgs.vimPlugins.LazyVim;
              "import" = "lazyvim.plugins";
            }
            { import = "lazyvim.plugins.extras.coding.copilot"; }
          ] ++ pluginsSpec;
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
