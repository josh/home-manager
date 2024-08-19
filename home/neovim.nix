{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) dotfiles;
  lazy-nvim-nix-lib = inputs.lazy-nvim-nix.lib;
in
{
  xdg.configFile = {
    "nvim/lua/config/autocmds.lua" = {
      source = "${dotfiles}/config/nvim/lua/config/autocmds.lua";
    };
    "nvim/lua/config/keymaps.lua" = {
      source = "${dotfiles}/config/nvim/lua/config/keymaps.lua";
    };
    "nvim/lua/config/options.lua" = {
      source = "${dotfiles}/config/nvim/lua/config/options.lua";
    };
    "nvim/lua/plugins/example.lua" = {
      source = ./neovim/lua/plugins/example.lua;
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

    extraLuaConfig = lazy-nvim-nix-lib.setupLazyLua {
      inherit (pkgs) lib;
      spec = [
        {
          name = "LazyVim";
          dir = pkgs.vimPlugins.LazyVim;
          "import" = "lazyvim.plugins";
        }
        { "import" = "lazyvim.plugins.extras.coding.copilot"; }
        { "import" = "plugins"; }
      ];
      opts = lazy-nvim-nix-lib.defaultLazyOpts;
    };
  };
}
