local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

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
  -- TODO: Point to nix store
  -- dev = {
  --   path = "...",
  --   patterns = { "LazyVim" },
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
