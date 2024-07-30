{ lib, pkgs, ... }:
let
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

  # TODO: Upstream mini.* to nixpkgs
  mini-ai = pkgs.vimUtils.buildVimPlugin {
    name = "mini.ai";
    src = pkgs.fetchFromGitHub {
      owner = "echasnovski";
      repo = "mini.ai";
      rev = "45587078f323eaf41b9f701bbc04f8d1ab008979";
      hash = "sha256-+jiFgzQOmW/zgS/mZXhKIwnoxGVV/ANccMIisVWmg3g=";
    };
  };
  mini-icons = pkgs.vimUtils.buildVimPlugin {
    name = "mini.icons";
    src = pkgs.fetchFromGitHub {
      owner = "echasnovski";
      repo = "mini.icons";
      rev = "660f3987ebcb13e573b654362854206c72d6c024";
      hash = "sha256-Ia8rIoDXPO9MfVx1CQceqI2T1YnNqusK5trNJJKakKU=";
    };
  };
  mini-pairs = pkgs.vimUtils.buildVimPlugin {
    name = "mini.pairs";
    src = pkgs.fetchFromGitHub {
      owner = "echasnovski";
      repo = "mini.pairs";
      rev = "927d19cbdd0e752ab1c7eed87072e71d2cd6ff51";
      hash = "sha256-2NAcULuudbY9NOqvjwuzITk4NTcckNhVW/XXZlPAJoA=";
    };
  };

  lazyPlugins = with pkgs.vimPlugins; {
    "bufferline.nvim" = bufferline-nvim;
    "catppuccin" = catppuccin-nvim;
    "cmp-buffer" = cmp-buffer;
    "cmp-nvim-lsp" = cmp-nvim-lsp;
    "cmp-path" = cmp-path;
    "conform.nvim" = conform-nvim;
    "copilot-cmp" = copilot-cmp;
    "copilot.lua" = copilot-lua;
    "dashboard-nvim" = dashboard-nvim;
    "dressing.nvim" = dressing-nvim;
    "flash.nvim" = flash-nvim;
    "friendly-snippets" = friendly-snippets;
    "gitsigns.nvim" = gitsigns-nvim;
    "grug-far.nvim" = grug-far-nvim;
    "indent-blankline.nvim" = indent-blankline-nvim;
    "lazydev.nvim" = lazydev-nvim;
    "lualine.nvim" = lualine-nvim;
    "luvit-meta" = luvit-meta;
    "mason-lspconfig.nvim" = mason-lspconfig-nvim;
    "mason.nvim" = mason-nvim;
    "mini.ai" = mini-ai;
    "mini.icons" = mini-icons;
    "mini.pairs" = mini-pairs;
    "neo-tree.nvim" = neo-tree-nvim;
    "noice.nvim" = noice-nvim;
    "nui.nvim" = nui-nvim;
    "nvim-cmp" = nvim-cmp;
    "nvim-lint" = nvim-lint;
    "nvim-lspconfig" = nvim-lspconfig;
    "nvim-notify" = nvim-notify;
    "nvim-snippets" = nvim-snippets;
    "nvim-spectre" = nvim-spectre;
    "nvim-treesitter" = nvim-treesitter;
    "nvim-treesitter-textobjects" = nvim-treesitter-textobjects;
    "nvim-ts-autotag" = nvim-ts-autotag;
    "persistence.nvim" = persistence-nvim;
    "plenary.nvim" = plenary-nvim;
    "telescope-fzf-native.nvim" = telescope-fzf-native-nvim;
    "telescope.nvim" = telescope-nvim;
    "todo-comments.nvim" = todo-comments-nvim;
    "tokyonight.nvim" = tokyonight-nvim;
    "trouble.nvim" = trouble-nvim;
    "ts-comments.nvim" = ts-comments-nvim;
    "which-key.nvim" = which-key-nvim;
  };
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
          formatPluginSpec = name: dir: "{ name = \"${name}\", dir = \"${dir}\" }";
          pluginSpecList = lib.attrsets.mapAttrsToList formatPluginSpec lazyPlugins;
          pluginSpecs = lib.strings.concatStringsSep ",\n  " pluginSpecList;
        in
        ''
          return {
            { name = "LazyVim", dir = "${pkgs.vimPlugins.LazyVim}", import = "lazyvim.plugins" },
            { import = "lazyvim.plugins.extras.coding.copilot" },
            ${pluginSpecs}
          }
        '';
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

      -- Something about trouble/lualine is busted
      -- https://github.com/LazyVim/LazyVim/commit/f9fdb35
      vim.g.trouble_lualine = false
      vim.g.trouble_luline_enabed = false
      vim.g.trouble_lualine_enabled = false

      require("config.lazy")
    '';
  };
}
