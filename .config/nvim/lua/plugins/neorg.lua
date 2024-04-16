return {
	{
		"nvim-neorg/neorg",
		dependencies = { { "vhyrro/luarocks.nvim", config = true } },
		version = "*", -- Pin Neorg to the latest stable release
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Load all the default modules
					["core.journal"] = {
						config = {
							strategy = "flat",
							workspace = "notes",
						},
					},
					["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
					["core.integrations.nvim-cmp"] = {},
					["core.concealer"] = { config = { icon_preset = "diamond" } },
					["core.keybinds"] = {
						-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
						config = {
							default_keybinds = true,
							-- neorg_leader = "<Leader><Leader>",
						},
					},
					["core.dirman"] = { -- Manage your directories with Neorg
						config = {
							workspaces = {
								notes = "~/Documents/notes",
							},
							default_workspace = "notes",
						},
					},
				},
			})
			vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<CR>", { desc = "[N]otes [I]ndex" })
			vim.keymap.set("n", "<leader>nc", "<cmd>Neorg return<CR>", { desc = "[N]otes [R]eturn" })
			vim.keymap.set("n", "<leader>nf", function()
				require("telescope.builtin").find_files({
					cwd = "~/Documents/notes",
					prompt = "Notes",
				})
			end, { desc = "[N]otes [F]ind" })
			vim.keymap.set("n", "<leader>nv", function()
				require("telescope").extensions.file_browser.file_browser({
					path = "~/Documents/notes",
				})
			end, { desc = "[N]otes [V]iew" })
			vim.keymap.set("n", "<leader>ns", function()
				require("telescope.builtin").live_grep({
					cwd = "~/Documents/notes",
					prompt = "Notes",
				})
			end, { desc = "[N]otes [S]earch" })
		end,
	},
}
