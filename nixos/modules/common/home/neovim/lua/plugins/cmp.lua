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
				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
				["<Down>"] = { "select_next" },
				["<Up>"] = { "select_prev" },
				["<CR>"] = { "select_and_accept" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
		},
	},
}
