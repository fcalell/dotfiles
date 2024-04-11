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
			dashboard.button("v", "  > [V]iew files", "<cmd>Telescope file_browser<CR>"),
			dashboard.button("f", "󰱼  > [F]ind File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("s", "  > [S]earch Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("n", "󰠮  > [N]otes", "<cmd>Neorg workspace notes<CR>"),
			dashboard.button(
				"r",
				"󰁯  > [R]estore Session For Current Directory",
				"<cmd>lua require('persistence').load()<cr>"
			),
			dashboard.button("q", "  > [Q]uit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
