return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local trouble = require("trouble")
			telescope.setup({
				pickers = {
					find_files = {
						find_command = { "rg", "--files" },
					},
				},
				defaults = {
					prompt_prefix = "❯ ",
					selection_caret = "❯ ",
					mappings = {
						i = {
							["<C-q>"] = function(prompt_bufnr)
								actions.smart_send_to_loclist(prompt_bufnr)
								trouble.open({ mode = "loclist" })
							end,
							["<leader>d"] = actions.delete_buffer,
						},
						n = {
							["<C-q>"] = function(prompt_bufnr)
								actions.smart_send_to_loclist(prompt_bufnr)
								trouble.open({ mode = "loclist" })
							end,
							["<leader>d"] = actions.delete_buffer,
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					file_browser = {
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						hidden = true,
					},
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
					media_files = {
						-- filetypes whitelist
						-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
						filetypes = { "png", "webp", "jpg", "jpeg" },
						-- find command (defaults to `fd`)
						find_cmd = "rg",
					},
				},
			})
			telescope.load_extension("file_browser")
			telescope.load_extension("fzf")
			telescope.load_extension("media_files")
			-- require("telescope").load_extension("live_grep_args")
			telescope.load_extension("ui-select")
			local builtin = require("telescope.builtin")
			vim.keymap.set(
				"n",
				"<leader>pf",
				builtin.find_files,
				{ noremap = true, silent = true, desc = "Find files" }
			)
			vim.keymap.set(
				"n",
				"<leader>pv",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				{ noremap = true, silent = true, desc = "Browse files in current directory" }
			)
			vim.keymap.set(
				"n",
				"<leader>ps",
				builtin.live_grep,
				{ noremap = true, silent = true, desc = "Search in files of the current project" }
			)
			vim.keymap.set("n", "<leader>ph", builtin.help_tags, { noremap = true, silent = true, desc = "Help tags" })
			vim.keymap.set(
				"n",
				"<leader><leader>",
				builtin.buffers,
				{ noremap = true, silent = true, desc = "Search buffers" }
			)
		end,
	},
	{
		"Equilibris/nx.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
		},

		opts = {
			-- See below for config options
			nx_cmd_root = "npx nx",
		},

		-- Plugin will load when you use these keys
		keys = {
			{ "<leader>px", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
		},
	},
	{
		"windwp/nvim-spectre",
		lazy = true,
		keys = function()
			return {
				{
					"<leader>pr",
					function()
						require("spectre").open()
					end,
					desc = "Search and replace in files (Spectre)",
				},
			}
		end,
	},
}
