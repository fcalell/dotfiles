-- Basic Settings
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false
opt.cmdheight = 1
opt.termguicolors = true --- Correct terminal colors

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 1000
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.errorbells = false --- Disables sound effect for errors
opt.iskeyword:append("-")
opt.iskeyword:append("_")

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Diagnostic
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	-- virtual_text = false,
	severity_sort = true,
})
