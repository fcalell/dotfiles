return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = true,
		event = { "BufEnter" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			-- "nvim-treesitter/nvim-treesitter-textobjects",
			-- "windwp/nvim-ts-autotag",
		},
		opts = {
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "python" },
			},
			-- autotag = {
			-- 	enable = true,
			-- 	enable_rename = true,
			-- 	enable_close = true,
			-- 	enable_close_on_slash = true,
			-- },
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
			-- textobjects = {
			-- 	select = {
			-- 		enable = true,
			-- 		-- Automatically jump forward to textobj, similar to targets.vim
			-- 		lookahead = true,
			-- 		keymaps = {
			-- 			-- You can use the capture groups defined in textobjects.scm
			-- 			["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment region" },
			-- 			["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment region" },
			--
			-- 			["a:"] = {
			-- 				query = "@parameter.outer",
			-- 				desc = "Select outer part of a parameter/field region",
			-- 			},
			-- 			["i:"] = {
			-- 				query = "@parameter.inner",
			-- 				desc = "Select inner part of a parameter/field region",
			-- 			},
			--
			-- 			["ai"] = {
			-- 				query = "@conditional.outer",
			-- 				desc = "Select outer part of a conditional region",
			-- 			},
			-- 			["ii"] = {
			-- 				query = "@conditional.inner",
			-- 				desc = "Select inner part of a conditional region",
			-- 			},
			--
			-- 			["al"] = { query = "@loop.outer", desc = "Select outer part of a loop region" },
			-- 			["il"] = { query = "@loop.inner", desc = "Select inner part of a loop region" },
			--
			-- 			["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
			-- 			["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" }, -- overrides default text object block of parenthesis to parenthesis
			--
			-- 			["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
			-- 			["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
			--
			-- 			["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
			-- 			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			-- 		},
			-- 		include_surrounding_whitespace = true,
			-- 	},
			-- 	swap = {
			-- 		enable = true,
			-- 		swap_next = {
			-- 			["<leader>on"] = "@parameter.inner", -- swap object under cursor with next
			-- 		},
			-- 		swap_previous = {
			-- 			["<leader>op"] = "@parameter.inner", -- swap object under cursor with previous
			-- 		},
			-- 	},
			-- },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
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
		end,
	},
}
