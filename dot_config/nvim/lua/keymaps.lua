-- Keymap
local map = function(mode, lhs, rhs, opts)
  local map_opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, map_opts)
end

-- Better up/down (handles wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- H to move to the first non-blank character of the line
map({ "n", "v", "o" }, "H", "^", { desc = "Move to first non-blank character" })

-- L to move to the last non-blank character of the line
map({ "n", "v", "o" }, "L", "$", { desc = "Move to last non-blank character" })

-- <C-c> should behave like <Esc>
map("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Save with <C-s>
map("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
map({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })

-- Move Lines
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move highlighted line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move highlighted line up" })

-- Macros
map("n", "Q", "@h", { desc = "Record macro in registry h" })
map("n", "q", "qh", { desc = "Play macro in registry h" })

-- Don't yank on delete char
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "X", '"_X')

-- Don't yank on visual paste
map("v", "p", '"_dP')

-- Saner behavior of n and N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Window management
map("n", "<leader>wc", "<C-w>c", { noremap = false, desc = "Close window" })
map("n", "<leader>wv", "<C-w>v", { noremap = false, desc = "Split window vertically" })
map("n", "<leader>ws", "<C-w>s", { noremap = false, desc = "Split window horizontally" })
map({ "n", "t" }, "<C-h>", "<C-w>h", { noremap = false, desc = "Focus on left window" })
map({ "n", "t" }, "<C-j>", "<C-w>j", { noremap = false, desc = "Focus on below window" })
map({ "n", "t" }, "<C-k>", "<C-w>k", { noremap = false, desc = "Focus on above window" })
map({ "n", "t" }, "<C-l>", "<C-w>l", { noremap = false, desc = "Focus on right window" })

-- Window resize (respecting v:count)
map(
  "n",
  "<C-Left>",
  '"<Cmd>vertical resize -" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = "Decrease window width" }
)
map(
  "n",
  "<C-Down>",
  '"<Cmd>resize -" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = "Decrease window height" }
)
map(
  "n",
  "<C-Up>",
  '"<Cmd>resize +" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = "Increase window height" }
)
map(
  "n",
  "<C-Right>",
  '"<Cmd>vertical resize +" . v:count1 . "<CR>"',
  { expr = true, replace_keycodes = false, desc = "Increase window width" }
)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Alt+hjkl for arrow key movement (works in all modes)
map({ "c", "i", "t", "n", "v" }, "<A-h>", "<Left>", { noremap = false, desc = "Left" })
map({ "c", "i", "t", "n", "v" }, "<A-j>", "<Down>", { noremap = false, desc = "Down" })
map({ "c", "i", "t", "n", "v" }, "<A-k>", "<Up>", { noremap = false, desc = "Up" })
map({ "c", "i", "t", "n", "v" }, "<A-l>", "<Right>", { noremap = false, desc = "Right" })

-- Search and replace current word
map(
  "n",
  "<leader>sr",
  ":%s/<C-r><C-w>//g<Left><Left>",
  { silent = false, desc = "Search and replace current word" }
)

-- Keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })
