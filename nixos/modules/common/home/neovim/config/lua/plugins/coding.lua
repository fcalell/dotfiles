return {
	{
		"axelvc/template-string.nvim",
		lazy = true,
		event = "InsertEnter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			remove_template_string = true,
		},
	},
	{
		"Wansmer/treesj",
		lazy = true,
		keys = {
			{ "<leader>cj", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
		},
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal = "yas",
					normal_cur = false,
					normal_line = false,
					normal_cur_line = false,
					visual = false,
					visual_line = false,
					delete = "das",
					change = "cas",
					change_line = false,
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		lazy = true,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		keys = {
			{
				"<leader>cc",
				"<Plug>(comment_toggle_linewise_current)",
				desc = "[C]ode [C]omment toggle",
			},
			{ "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", mode = "v", desc = "[C]ode [C]omment toggle" },
		},
		config = function()
			local comment = require("Comment")
			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
			vim.g.skip_ts_context_commentstring_module = true
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
			comment.setup({
				mappings = false,
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
		end,
	},
}
