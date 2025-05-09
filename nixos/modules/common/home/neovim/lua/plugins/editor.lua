return {
	{
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			keys = {
				{
					"<leader><leader>",
					function()
						Snacks.picker.buffers()
					end,
					desc = "Buffers",
				},
				{
					"<leader>ps",
					function()
						Snacks.picker.grep()
					end,
					desc = "[P]roject [S]earch with Grep",
				},
				{
					"<leader>pf",
					function()
						Snacks.picker.smart()
					end,
					desc = "[P]roject [F]iles",
				},
				{
					"<leader>pv",
					function()
						Snacks.explorer()
					end,
					desc = "[P]roject [V]iew",
				},
				{
					"<leader>bd",
					function()
						Snacks.bufdelete()
					end,
					desc = "[D]elete [B]uffer",
				},
				{
					"<leader>t",
					function()
						Snacks.terminal()
					end,
					desc = "[T]erminal",
				},
				{
					"<leader>gg",
					function()
						Snacks.lazygit()
					end,
					desc = "[G]it Lazy[G]it",
				},
				{
					"gd",
					function()
						Snacks.picker.lsp_definitions()
					end,
					desc = "Goto Definition",
				},
				{
					"gD",
					function()
						Snacks.picker.lsp_declarations()
					end,
					desc = "Goto Declaration",
				},
				{
					"gr",
					function()
						Snacks.picker.lsp_references()
					end,
					nowait = true,
					desc = "References",
				},
				{
					"gI",
					function()
						Snacks.picker.lsp_implementations()
					end,
					desc = "Goto Implementation",
				},
				{
					"gy",
					function()
						Snacks.picker.lsp_type_definitions()
					end,
					desc = "Goto T[y]pe Definition",
				},
			},
			---@type snacks.Config
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				bigfile = { enabled = true },
				dashboard = {
					enabled = true,
					preset = {
						header = [[
███████╗ ██████╗ █████╗ ██╗     ███████╗██╗     ██╗     
██╔════╝██╔════╝██╔══██╗██║     ██╔════╝██║     ██║     
█████╗  ██║     ███████║██║     █████╗  ██║     ██║     
██╔══╝  ██║     ██╔══██║██║     ██╔══╝  ██║     ██║     
██║     ╚██████╗██║  ██║███████╗███████╗███████╗███████╗
╚═╝      ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝
]],
						keys = {
							{ icon = " ", key = "v", desc = "[V]iew files", action = ":lua Snacks.explorer()" },
							{ icon = "󰱼 ", key = "f", desc = "[F]ind file", action = ":lua Snacks.picker.smart()" },
							{ icon = " ", key = "s", desc = "[S]earch in files", action = ":lua Snacks.grep()" },
							{
								icon = "󰁯 ",
								key = "r",
								desc = "[R]estore session",
								action = ":lua require('persistence').load()",
							},
							{ icon = " ", key = "q", desc = "[Q]uit nvim", action = ":qa" },
						},
					},
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
					},
				},
				explorer = { enabled = true, replace_netrw = true },
				image = { enabled = true },
				-- indent = { enabled = true },
				input = { enabled = true },
				picker = {
					enabled = true,
					sources = {
						explorer = {
							auto_close = true,
						},
					},
				},
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
		enabled = false,
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
		"folke/trouble.nvim",
		lazy = true,
		event = { "BufEnter" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{
				"<leader>d",
				"<cmd>Trouble diagnostics toggle<cr>",
				mode = "n",
				desc = "[D]iagnostics (Trouble)",
			},
			{ "<leader>ql", "<cmd>Trouble loclist toggle<cr>", mode = "n", desc = "Location List (Trouble)" },
			{ "<leader>qf", "<cmd>Trouble quickfix toggle<cr>", mode = "n", desc = "Quickfix List (Trouble)" },
		},
	},
	{
		"windwp/nvim-spectre",
		lazy = true,
		keys = {
			{
				"<leader>pr",
				function()
					require("spectre").open()
				end,
				desc = "[P]roject search and [R]eplace in files",
			},
		},
	},
	{ "folke/which-key.nvim", enabled = false },
}
