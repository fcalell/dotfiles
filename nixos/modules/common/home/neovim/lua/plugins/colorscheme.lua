return {
	-- {
	--   "olimorris/onedarkpro.nvim",
	--   priority = 10000,
	--   opts = {
	--     options = {
	--       transparency = true,
	--     },
	--     highlights = {
	--       LineNr = { fg = "#F0F0F0", bg = "NONE" },
	--     },
	--   },
	--   config = function(_, opts)
	--     require("onedarkpro").setup(opts)
	--     vim.cmd("colorscheme onedark_dark")
	--   end,
	-- },
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("tokyonight").setup({
				-- transparent = true,
				style = "moon",
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		enabled = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			vim.cmd("colorscheme catppuccin")
		end,
	},
}
