return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufEnter" },
	config = function()
		local conform = require("conform")
		local formatters_by_ft = {
			javascript = { "biome-check", "prettierd", stop_after_first = true },
			typescript = { "biome-check", "prettierd", stop_after_first = true },
			javascriptreact = { "biome-check", "prettierd", stop_after_first = true },
			typescriptreact = { "biome-check", "prettierd", stop_after_first = true },
			json = { "biome-check", "prettierd", stop_after_first = true },
			css = { "prettierd" },
			html = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			graphql = { "prettierd" },
			lua = { "stylua" },
			tex = { "latexindent" },
			nix = { "nixfmt" },
		}
		conform.setup({
			formatters_by_ft = formatters_by_ft,
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 10000,
			},
		})
	end,
}
