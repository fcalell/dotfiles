-- Basic Settings
local opt = vim.opt
vim.g.have_nerd_font = true

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
vim.o.winborder = "rounded"

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
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
opt.wildmode = "longest:full,full"
opt.pumheight = 10

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99

-- Diagnostic
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, prefix = "●" },
	-- virtual_text = false,
	severity_sort = true,
})

-- Diagnostic signs
local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
