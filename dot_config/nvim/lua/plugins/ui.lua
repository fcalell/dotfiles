vim.pack.add({
	{ src = "https://github.com/folke/persistence.nvim" },
	-- Snacks.nvim - Swiss Army Knife for Neovim
	{
		src = "https://github.com/folke/snacks.nvim",
	},
	-- Dependency for Snacks
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
	},
	-- Illuminate - Highlight word under cursor (disabled in your config)
	{
		src = "https://github.com/RRethy/vim-illuminate",
	},
	-- Lualine - Status line
	{
		src = "https://github.com/nvim-lualine/lualine.nvim",
	},

	-- Trouble - Pretty diagnostics list
	{
		src = "https://github.com/folke/trouble.nvim",
	},
	-- Spectre - Search and replace in files
	{
		src = "https://github.com/windwp/nvim-spectre",
	},
	-- Gitsigns - Git decorations
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},
})

require("persistence").setup({})

-- Setup Snacks.nvim
Snacks = require("snacks")

Snacks.setup({
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
				{ icon = " ", key = "v", desc = "[V]iew files", action = ":lua Snacks.explorer()" },
				{
					icon = "󰱼 ",
					key = "f",
					desc = "[F]ind file",
					action = ":lua Snacks.picker.git_files()",
				},
				{
					icon = " ",
					key = "s",
					desc = "[S]earch in files",
					action = ":lua Snacks.picker.grep()",
				},
				{
					icon = "󰁯 ",
					key = "r",
					desc = "[R]estore session",
					action = ":lua require('persistence').load()",
				},
				{ icon = " ", key = "q", desc = "[Q]uit nvim", action = ":qa" },
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	explorer = { enabled = true },
	image = { enabled = true },
	input = { enabled = true },
	picker = {
		enabled = true,
		hidden = true,
		untracked = true,
		sources = {
			explorer = {
				auto_close = true,
				matcher = { fuzzy = true },
			},
		},
	},
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
})

-- Snacks.nvim keymaps
local keymap = vim.keymap.set

keymap("n", "<leader><leader>", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })

keymap("n", "<leader>ps", function()
	Snacks.picker.grep()
end, { desc = "[P]roject [S]earch with Grep" })

keymap("n", "<leader>pf", function()
	Snacks.picker.git_files()
end, { desc = "[P]roject [F]iles" })

keymap("n", "<leader>pv", function()
	Snacks.explorer()
end, { desc = "[P]roject [V]iew" })

keymap("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "[D]elete [B]uffer" })

keymap("n", "<leader>t", function()
	Snacks.terminal()
end, { desc = "[T]erminal" })

keymap("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "[G]it Lazy[G]it" })

keymap("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })

keymap("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })

keymap("n", "gr", function()
	Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })

keymap("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })

keymap("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })

-- Setup Trouble (diagnostics list)
require("trouble").setup({
	use_diagnostic_signs = true,
})
keymap("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", { desc = "[D]iagnostics (Trouble)" })
keymap("n", "<leader>ql", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
keymap("n", "<leader>qf", "<cmd>Trouble quickfix toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Setup Spectre (search and replace)
keymap("n", "<leader>pr", function()
	require("spectre").open()
end, { desc = "[P]roject search and [R]eplace in files" })

-- Illuminate setup
require("illuminate").configure({
	delay = 200,
	under_cursor = false,
})
keymap("n", "]]", function()
	require("illuminate").goto_next_reference(false)
end, { desc = "Next Reference" })
keymap("n", "[[", function()
	require("illuminate").goto_prev_reference(false)
end, { desc = "Prev Reference" })

-- Lualine
local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "Recording @" .. recording_register
	end
end
require("lualine").setup({
	options = {
		globalstatus = true,
		theme = "auto",
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_a = {
			"mode",
			{
				"macro-recording",
				fmt = show_macro_recording,
			},
		},
		lualine_b = { "branch" },
		lualine_c = {
			{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
		},
		lualine_x = {
			{
				"diff",
			},
		},
		lualine_y = {
			{
				"diagnostics",
			},
		},
		lualine_z = {
			{ "location", padding = { left = 0, right = 1 } },
		},
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
})
