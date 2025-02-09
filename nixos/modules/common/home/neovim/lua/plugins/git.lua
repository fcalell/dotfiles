return {
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		keys = { { "<leader>gg", ":LazyGit<CR>", desc = "[G]it Lazy[G]it" } },
	},
	{ "akinsho/git-conflict.nvim", lazy = true, event = { "BufEnter" }, version = "*", config = true },
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "BufEnter" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
		},
	},
}
