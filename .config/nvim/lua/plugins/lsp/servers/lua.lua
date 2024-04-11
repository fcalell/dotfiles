local M = {}

M.dependencies = {
	"folke/neodev.nvim",
}

M.settings = {
	Lua = {
		-- diagnostics = {
		-- 	globals = { "vim" },
		-- },
		workspace = {
			checkThirdParty = false,
		},
		completion = {
			callSnippet = "Replace",
		},
	},
}

M.setup = function()
	require("neodev").setup({})
end

return M
