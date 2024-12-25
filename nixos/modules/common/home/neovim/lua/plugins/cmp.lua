return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		lazy = true,
		event = "InsertEnter",
		opts = {
			sources = {
				default = {
					"lsp",
					"path",
					-- "snippets",
					-- "buffer"
				},
			},
			keymap = {
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			signature = { enabled = true },
		},
	},
}
