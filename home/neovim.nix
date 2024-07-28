{ pkgs, ... }:
let
  inputs = import ../inputs.nix;
  lazy-vim = pkgs.vimUtils.buildVimPlugin {
    name = "LazyVim";
    src = inputs.lazy-vim;
  };
in
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      lazy-vim
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

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          {
            "stevearc/conform.nvim",
            opts = {
              formatters_by_ft = {
                nix = { "nixfmt" },
              }
            }
          },
          {
             "williamboman/mason.nvim",
             enabled = false,
          }
        },
        checker = { enabled = true, notify = false },
      })
    '';
  };
}
