return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		config = function()
			local lualine = require("lualine")
			local icons = require("config.icons")
			local function show_macro_recording()
				local recording_register = vim.fn.reg_recording()
				if recording_register == "" then
					return ""
				else
					return "Recording @" .. recording_register
				end
			end

			lualine.setup({
				options = {
					globalstatus = true,
					theme = "auto",
					section_separators = "",
					component_separators = "",
				},
				sections = {
					lualine_a = {
						"mode",
						{
							"macro-recording",
							fmt = show_macro_recording,
						},
					},
					lualine_b = { "branch" },
					lualine_c = {
						{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
					},
					lualine_x = {
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_y = {
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
						},
					},
					lualine_z = {
						{ "location", padding = { left = 0, right = 1 } },
					},
				},
			})
		end,
	},
}
