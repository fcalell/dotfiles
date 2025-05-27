-- Map leader key to SPC
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

vim.opt.clipboard = "unnamed,unnamedplus" --- Copy-paste between vim and everything else

-- Indentation settings
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

vim.opt.undofile = true --- Sets undo to file

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 1000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Highlight of current line
vim.opt.cursorline = false

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Wrap lines
vim.opt.wrap = true
vim.opt.linebreak = true

-- Set the tab width
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Search settings
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.infercase = true

-- UI
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.showtabline = 1
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.pumheight = 5

vim.opt.errorbells = false --- Disables sound effect for errors
vim.opt.termguicolors = true --- Correct terminal colors
-- vim.opt.wildignore = "*node_modules/**" --- Don't search inside Node.js modules (works for gutentag)

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Improve w and b behavior
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append("_")

-- Diagnostic signs
for name, icon in pairs(require("config.icons").diagnostics) do
	name = "DiagnosticSign" .. name
	vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	-- virtual_text = false,
	severity_sort = true,
})
