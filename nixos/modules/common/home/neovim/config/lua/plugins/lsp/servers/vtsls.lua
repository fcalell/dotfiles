local M = {}

M.dependencies = {
	"yioneko/nvim-vtsls",
	-- { "pmizio/typescript-tools.nvim" },
}

M.settings = {}

M.setup = function()
	require("lspconfig.configs").vtsls = require("vtsls").lspconfig
end

return M
