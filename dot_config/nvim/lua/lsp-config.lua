vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("*") },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"biome",
		"cssls",
		"html",
		"tailwindcss",
		"vtsls",
		"graphql",
		"jsonls",
		"prettier",
	},
})

-- On LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("fcalell-lsp-attach", { clear = true }),
	callback = function(event)
		-- Mappings
		local map = function(mode, lhs, rhs, options)
			local map_opts = vim.tbl_extend("force", { buffer = event.buf, silent = true }, options or {})
			vim.keymap.set(mode, lhs, rhs, map_opts)
		end
		map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
		map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
		map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })
		-- Autocomplete
		--local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		--if (client:supports_method('textDocument/completion')) then
		--  vim.lsp.completion.enable(true, client.id, event.buf, {autotrigger = true})
		--end
	end,
})

-- Lua
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Biome - exclude CSS files (doesn't support Tailwind v4 directives)
vim.lsp.config("biome", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"typescript",
		"typescriptreact",
		-- Explicitly exclude CSS from Biome LSP
	},
})

vim.lsp.config("graphql", {
	filetypes = {
		"graphql",
		"typescriptreact",
		"javascriptreact",
		"typescript",
	},
})

-- Autocomplete
require("blink.cmp").setup({
	sources = {
		default = {
			"lsp",
			"path",
		},
	},
	keymap = {
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<Esc>"] = { "cancel", "fallback" },
	},
	signature = { enabled = true },
	completion = {
		list = {
			selection = {
				preselect = function(ctx)
					return ctx.mode ~= "cmdline"
				end,
				auto_insert = false,
			},
		},
	},
})

-- Formatter
require("conform").setup({
	formatters = {
		["biome-check"] = {
			command = "biome",
		},
	},
	formatters_by_ft = {
		javascript = { "biome-check" },
		typescript = { "biome-check" },
		javascriptreact = { "biome-check" },
		typescriptreact = { "biome-check" },
		json = { "biome-check" },
		css = { "prettier" },
		html = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		tex = { "latexindent" },
		nix = { "nixfmt" },
	},
	format_on_save = {
		lsp_fallback = false,
		async = false,
		timeout_ms = 10000,
	},
})
