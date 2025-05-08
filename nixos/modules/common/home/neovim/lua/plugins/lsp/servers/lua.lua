local M = {}

M.dependencies = {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
}

M.settings = {
	Lua = {
		runtime = {
			version = "LuaJIT",
		},
	},
}

return M
