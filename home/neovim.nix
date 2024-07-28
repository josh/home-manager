{ lib, config, ... }:
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

    colorschemes = {
      catppuccin = lib.mkIf config.catppuccin.enable {
        enable = true;
        settings.flavor = config.catppuccin.flavor;
      };

      tokyonight = lib.mkIf (lib.strings.hasPrefix "tokyonight" config.theme) {
        enable = true;
        style = "night";
      };
    };
    opts.background = config.background;

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
      lualine = {
        enable = true;
        iconsEnabled = config.nerd-fonts;
      };

      # File browser sidebar, open with <SPACE> + t
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
      };

      notify.enable = true;
      noice = {
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };

      which-key.enable = true;

      # Fuzzy file finder, open with <SPACE> + ff
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>b" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fd" = "diagnostics";
          "<C-p>" = "git_files";
          "<leader>p" = "oldfiles";
          "<C-f>" = "live_grep";
        };
      };

      # git integration, open with <SPACE> + lg
      lazygit.enable = true;

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      nix.enable = true;

      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          lua-ls.enable = true;
          nixd.enable = true;
        };
      };

      # There's also coplilot-lua,
      # maybe try that and see what the difference is.
      copilot-vim.enable = true;

      cmp = {
        enable = true;
        settings = {
          sources = [ { name = "nvim_lsp"; } ];
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
        cmdline = {
          "/" = {
            sources = [ { name = "buffer"; } ];
          };
          ":" = {
            sources = [
              { name = "cmdline"; }
              { name = "cmdline_history"; }
              { name = "path"; }
            ];
          };
        };
      };

      comment.enable = true;

      conform-nvim = {
        enable = true;
        formattersByFt = {
          json = [ "prettier" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python = [
            "ruff_format"
            "ruff_fix"
          ];
          yaml = [ "prettier" ];
        };
        formatOnSave = {
          timeoutMs = 500;
        };
      };
    };

    # Change leader from \ to <SPACE>
    globals.mapleader = " ";

    keymaps = [
      {
        action = "<cmd>Neotree action=focus reveal toggle<CR>";
        key = "<leader>t";
      }
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>lg";
      }
    ];
  };
}
