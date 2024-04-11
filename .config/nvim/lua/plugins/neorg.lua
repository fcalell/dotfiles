return {
	{
		"nvim-neorg/neorg",
		dependencies = { { "vhyrro/luarocks.nvim", config = true } },
		-- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		cmd = "Neorg",
		ft = "norg",
		version = "*", -- Pin Neorg to the latest stable release
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Load all the default modules
					["core.journal"] = {
						config = {
							strategy = "flat",
							workspace = "notes",
						},
					},
					["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
					["core.integrations.nvim-cmp"] = {},
					["core.concealer"] = { config = { icon_preset = "diamond" } },
					["core.keybinds"] = {
						-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
						config = {
							default_keybinds = true,
							-- neorg_leader = "<Leader><Leader>",
						},
					},
					["core.dirman"] = { -- Manage your directories with Neorg
						config = {
							index = "index.norg",
							workspaces = {
								notes = "~/Documents/notes",
							},
						},
					},
				},
			})
		end,
	},
}
