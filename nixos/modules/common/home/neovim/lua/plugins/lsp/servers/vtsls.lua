local M = {}

M.dependencies = {
	"yioneko/nvim-vtsls",
	-- { "pmizio/typescript-tools.nvim" },
}

M.settings = {
	vtsls = {
		autoUseWorkspaceTsdk = true,
	},
}

return M
