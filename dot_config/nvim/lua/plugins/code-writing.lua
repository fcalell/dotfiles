vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	{ src = "https://github.com/axelvc/template-string.nvim" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/mbbill/undotree" },
})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	auto_install = true,
	ensure_installed = {
		"graphql",
		"html",
		"css",
		"javascript",
		"json",
		-- "latex",
		"lua",
		"luap",
		"markdown",
		"markdown_inline",
		"query",
		"regex",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 1220, -- The Z-index of the context window
})

require("template-string").setup({
	remove_template_string = true,
})

require("ts_context_commentstring").setup({
	enable_autocmd = false,
})

require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	mappings = false,
})
vim.keymap.set("n", "<leader>cc", "<Plug>(comment_toggle_linewise_current)", { silent = true })
vim.keymap.set("v", "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", { silent = true })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
