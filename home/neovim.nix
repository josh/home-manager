{ config, ... }:
let
  inputs = import ../inputs.nix;
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    colorschemes.catppuccin = {
      inherit (config.catppuccin) enable;
      settings.flavor = config.catppuccin.flavor;
    };

    plugins = {
      # Cool launch screen when neovim is opened without a file
      startify = {
        enable = true;
        # When opening a file from start, change to the repo root
        # rather than the file's parent.
        settings.change_to_vcs_root = true;
      };

      # Adds tabs to the top of the screen.
      bufferline.enable = true;

      # Cooler looking status bar
      lualine.enable = true;

      # File browser sidebar, open with <SPACE> + t
      nvim-tree = {
        enable = true;
        # Disable builtin file explorer
        disableNetrw = true;
      };

      # Fuzzy file finder, open with <SPACE> + ff
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      # git integration, open with <SPACE> + lg
      lazygit.enable = true;

      # Try to figure out how treesitter and lsp interact
      treesitter.enable = true;
      nix.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd.enable = true;
        };
      };

      # There's also coplilot-lua,
      # maybe try that and see what the difference is.
      copilot-vim.enable = true;
    };

    # Change leader from \ to <SPACE>
    globals.mapleader = " ";

    keymaps = [
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>t";
      }

      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fw";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }

      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>lg";
      }
    ];
  };
}
