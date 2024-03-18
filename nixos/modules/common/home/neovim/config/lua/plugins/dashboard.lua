return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"",
			"███████╗ ██████╗ █████╗ ██╗     ███████╗██╗     ██╗     ",
			"██╔════╝██╔════╝██╔══██╗██║     ██╔════╝██║     ██║     ",
			"█████╗  ██║     ███████║██║     █████╗  ██║     ██║     ",
			"██╔══╝  ██║     ██╔══██║██║     ██╔══╝  ██║     ██║     ",
			"██║     ╚██████╗██║  ██║███████╗███████╗███████╗███████╗",
			"╚═╝      ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝",
			"",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("v", "  > File browser", "<cmd>Telescope file_browser<CR>"),
			dashboard.button("f", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("s", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button(
				"r",
				"󰁯  > Restore Session For Current Directory",
				"<cmd>lua require('persistence').load()<cr>"
			),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
