vim.pack.add({
	{ src = "https://github.com/coder/claudecode.nvim" },
})

-- Requires snacks.nvim (installed in plugins/ui.lua) for enhanced terminal support.
require("claudecode").setup({
	terminal = {
		split_side = "right",
		split_width_percentage = 0.30,
		provider = "snacks",
	},
	diff_opts = {
		layout = "vertical",
	},
})

-- Keymaps (mirrors the plugin's recommended <leader>a "AI/Claude Code" group)
local map = vim.keymap.set
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
-- map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
-- map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
-- map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
-- map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- Add file from tree-style explorers
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("claudecode-tree-add", { clear = true }),
	pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
	callback = function(ev)
		vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", {
			buffer = ev.buf,
			desc = "Add file to Claude",
		})
	end,
})
