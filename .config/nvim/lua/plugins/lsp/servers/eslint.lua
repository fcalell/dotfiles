local M = {}

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false

	local eslint_augroup = vim.api.nvim_create_augroup("EslintFixAll", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = eslint_augroup,
		buffer = bufnr,
		command = "EslintFixAll",
	})
end

M.settings = {}

return M
