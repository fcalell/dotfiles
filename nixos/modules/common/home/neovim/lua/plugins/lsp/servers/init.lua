return {
	jsonls = {},
	html = {},
	bashls = {},
	graphql = {},
	nil_ls = {},
	texlab = {
		texlab = {
			chktex = {
				onEdit = true,
				onOpenAndSave = true,
			},
		},
	},
	cssls = require("plugins.lsp.servers.css"),
	tailwindcss = require("plugins.lsp.servers.tailwind"),
	-- vtsls = require("plugins.lsp.servers.vtsls"),
	ts_ls = {},
	lua_ls = require("plugins.lsp.servers.lua"),
	-- eslint = require("plugins.lsp.servers.eslint"),
	biome = {},
}
