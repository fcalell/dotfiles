return {
	{
		"akinsho/bufferline.nvim",
		enabled = false,
		lazy = true,
		event = { "BufEnter" },
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				alwaseparator_style = "slant",
				ys_show_bufferline = true,
				diagnostics_indicator = function(_, _, diag)
					local icons = require("config.icons").diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		lazy = true,
		keys = { "<leader>hh", "<leader>ha" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			local extensions = require("harpoon.extensions")
			harpoon:setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })
			harpoon:extend(extensions.builtins.navigate_with_number())
			vim.keymap.set("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():append()
			end)
		end,
	},
}
