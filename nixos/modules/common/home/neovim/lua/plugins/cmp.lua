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
			completion = {
				list = {
					selection = {
						preselect = function(ctx)
							return ctx.mode ~= "cmdline"
						end,
						auto_insert = false,
					},
				},
			},
			keymap = {
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<Esc>"] = { "cancel", "fallback" },
			},
			signature = { enabled = true },
		},
	},
}
