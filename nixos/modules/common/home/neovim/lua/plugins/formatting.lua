return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufEnter" },
	config = function()
		local conform = require("conform")
		local formatters_by_ft = {
			javascript = { "biome-check" },
			typescript = { "biome-check" },
			javascriptreact = { "biome-check" },
			typescriptreact = { "biome-check" },
			json = { "biome-check" },
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
			formatters = {
				["biome-check"] = {
					command = "biome",
				},
			},
			formatters_by_ft = formatters_by_ft,
			format_on_save = {
				lsp_fallback = false,
				async = false,
				timeout_ms = 10000,
			},
		})
	end,
}
