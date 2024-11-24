-- a table with the following values for each key:
-- - dependencies: a list of plugins to install
-- - settings: a table of settings to pass to the server
-- - setup: a function to run before the server is installed with lspconfig
-- - on_attach: a function to run when the server is attached to a buffer
local servers = require("plugins.lsp.servers")
-- extract all the dependencies from the servers table if they exist
local dependencies = {
	{ "j-hui/fidget.nvim", opts = {} },
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
	},
}
for serverName, serverConfig in pairs(servers) do
	if serverConfig.dependencies then
		for _, dependency in pairs(serverConfig.dependencies) do
			table.insert(dependencies, dependency)
		end
	end
end

return {
	"neovim/nvim-lspconfig",
	lazy = true,
	event = { "BufEnter" },
	dependencies = dependencies,
	config = function()
		local lspconfig = require("lspconfig")

		-- Servers
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		local on_attach = function(client, bufnr)
			client.offset_encoding = "utf-16"
			-- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			local telescope = require("telescope.builtin")
			local map = function(mode, lhs, rhs, options)
				local map_opts = vim.tbl_extend("force", { buffer = bufnr, silent = true }, options or {})
				vim.keymap.set(mode, lhs, rhs, map_opts)
			end

			if client.server_capabilities["documentSymbolProvider"] then
				require("nvim-navbuddy").attach(client, bufnr)
				require("nvim-navic").attach(client, bufnr)
				map("n", "<leader>cn", require("nvim-navbuddy").open, { desc = "Navigate code" })
			end

			map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
			map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
			map("n", "gd", telescope.lsp_definitions, { desc = "Goto definition" })
			map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			map("n", "gi", telescope.lsp_implementations, { desc = "Goto implementations" })
			map("n", "gr", telescope.lsp_references, { desc = "Goto references" })
			map("n", "gt", telescope.lsp_type_definitions, { desc = "Goto type definition" })
			map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
		end

		for server_name, server_config in pairs(servers) do
			if server_config.setup then
				server_config.setup()
			end
			lspconfig[server_name].setup({
				on_attach = server_config.on_attach or on_attach,
				capabilities = capabilities,
				settings = server_config.settings or {},
			})
		end
	end,
}
