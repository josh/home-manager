require("lazy").setup({
  -- https://lazy.folke.io/configuration
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  -- dev = {
  --   path = "~/.local/share/nvim/lazy-dev",
  --   patterns = { "." },
  --   fallback = true,
  -- },
  install = {
    missing = false,
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
