require("lazy").setup({
	-- https://lazy.folke.io/configuration
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = {
		missing = true,
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
