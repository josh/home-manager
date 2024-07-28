return {
  -- Disable mason package manager
  {
    "williamboman/mason.nvim",
    enabled = false,
  },

  -- Set up formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
      },
    },
  },
}
