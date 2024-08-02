return {
	-- Disable mason package manager
	{ "williamboman/mason.nvim", enabled = false },
	{ "williamboman/mason-lspconfig.nvim", enabled = false },

	-- Don't install any treesitter plugins
	{ "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },

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

	-- Enable Copilot for all filetypes
	{
		"zbirenbaum/copilot.lua",
		opts = {
			filetypes = { ["*"] = true },
		},
	},

	{ "folke/trouble.nvim", enabled = false },
}
