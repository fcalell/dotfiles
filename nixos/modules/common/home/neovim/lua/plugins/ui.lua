return {
	{
		"levouh/tint.nvim",
		lazy = true,
		enabled = false,
		event = "WinNew",
		opts = {},
	},
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
			local group = vim.api.nvim_create_augroup("lualine", { clear = true })
			vim.api.nvim_create_autocmd("RecordingEnter", {
				group = group,
				callback = function()
					lualine.refresh({
						place = { "statusline" },
					})
				end,
			})
			vim.api.nvim_create_autocmd("RecordingLeave", {
				group = group,
				callback = function()
					-- This is going to seem really weird!
					-- Instead of just calling refresh we need to wait a moment because of the nature of
					-- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
					-- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
					-- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
					-- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
					local timer = vim.loop.new_timer()
					timer:start(
						50,
						0,
						vim.schedule_wrap(function()
							lualine.refresh({
								place = { "statusline" },
							})
						end)
					)
				end,
			})

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
