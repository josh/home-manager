{ pkgs, ... }:
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
  };

  xdg.dataFile = {
    # "nvim/lazy/LazyVim" = {
    #   source = pkgs.LazyVim;
    # };
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      LazyVim
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];

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
