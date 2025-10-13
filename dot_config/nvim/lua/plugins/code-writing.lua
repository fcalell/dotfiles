vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	{ src = "https://github.com/axelvc/template-string.nvim" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/kylechui/nvim-surround" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

require("nvim-treesitter.configs").setup({
	modules = {},
	sync_install = false,
	ignore_install = {},
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
vim.keymap.set("n", "<leader>cc", "<Plug>(comment_toggle_linewise_current)", { silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", { silent = true, desc = "Toggle comment (visual)" })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

-- Setup autopairs
require("nvim-autopairs").setup({
	check_ts = true,
	ts_config = {
		lua = { "string" },
		javascript = { "template_string" },
	},
})

-- Setup surround
require("nvim-surround").setup({})
