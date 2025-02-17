return {
	{
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			keys = {
				{
					"<leader>bd",
					function()
						Snacks.bufdelete()
					end,
					desc = "Delete Buffer",
				},
				{
					"<leader>t",
					function()
						Snacks.terminal()
					end,
					desc = "Toggle Terminal",
				},
			},
			---@type snacks.Config
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = { enabled = true },
				-- dashboard = { enabled = true },
				-- explorer = { enabled = true },
				-- indent = { enabled = true },
				input = { enabled = true },
				-- picker = { enabled = true },
				notifier = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				-- scroll = { enabled = true },
				-- statuscolumn = { enabled = true },
				-- words = { enabled = true },
			},
		},
	},
	{
		"RRethy/vim-illuminate",
		lazy = true,
		event = { "BufEnter" },
		opts = {
			delay = 200,
			-- under_cursor = false,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},
	{
		"folke/flash.nvim",
		lazy = true,
		event = { "BufEnter" },
		---@type Flash.Config
		config = {
			modes = {
				char = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
		},
	},
	{
		"echasnovski/mini.bracketed",
		lazy = true,
		event = { "BufEnter" },
		config = function()
			require("mini.bracketed").setup({
				buffer = { suffix = "b", options = {} },
				comment = { suffix = "c", options = {} },
				conflict = { suffix = "", options = {} },
				diagnostic = { suffix = "d", options = {} },
				file = { suffix = "", options = {} },
				indent = { suffix = "", options = {} },
				jump = { suffix = "", options = {} },
				location = { suffix = "l", options = {} },
				oldfile = { suffix = "", options = {} },
				quickfix = { suffix = "q", options = {} },
				treesitter = { suffix = "", options = {} },
				undo = { suffix = "", options = {} },
				window = { suffix = "w", options = {} },
				yank = { suffix = "", options = {} },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		lazy = true,
		event = { "BufEnter" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{
				"<leader>e",
				"<cmd>Trouble diagnostics toggle<cr>",
				mode = "n",
				desc = "Document Diagnostics (Trouble)",
			},
			{ "<leader>ql", "<cmd>Trouble loclist toggle<cr>", mode = "n", desc = "Location List (Trouble)" },
			{ "<leader>qf", "<cmd>Trouble quickfix toggle<cr>", mode = "n", desc = "Quickfix List (Trouble)" },
		},
	},
	{ "karb94/neoscroll.nvim", enabled = false, config = true },
	{ "folke/which-key.nvim", enabled = false },
}
