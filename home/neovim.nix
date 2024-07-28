{ pkgs, ... }:
let
  inputs = import ../inputs.nix;
  LazyVim = pkgs.vimUtils.buildVimPlugin {
    name = "LazyVim";
    src = pkgs.fetchFromGitHub {
      owner = "LazyVim";
      repo = "LazyVim";
      rev = "12818a6cb499456f4903c5d8e68af43753ebc869";
      hash = "sha256-ZCMu1vwGigAxcOMWzuQMGFujSDlpUqNHvtLVsT5U7Zs=";
    };
  };
in
{
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
