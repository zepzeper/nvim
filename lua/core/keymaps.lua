local default_opts = { noremap = true, silent = true }
-- ════════════════════════════════════════════════════════════════════════════
-- Essential Operations
-- ════════════════════════════════════════════════════════════════════════════

vim.keymap.set("n", "<C-c>", "<Nop>", default_opts)
vim.keymap.set("n", "<C-z>", "<Nop>", default_opts)

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Highlight", silent = true })

-- ════════════════════════════════════════════════════════════════════════════
-- Window Navigation (no prefix for speed)
-- ════════════════════════════════════════════════════════════════════════════

vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Go Left" })
vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Go Down" })
vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Go Up" })
vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Go Right" })

-- Window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Width" })

-- ════════════════════════════════════════════════════════════════════════════
-- Line Movement (Visual Mode)
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Lines Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Lines Up" })

-- ════════════════════════════════════════════════════════════════════════════
-- Better Navigation
-- ════════════════════════════════════════════════════════════════════════════

-- Wrapped line navigation
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (wrapped)" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (wrapped)" })

-- Start/End of line (easier than ^ and $)
vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "Start of Line" })
vim.keymap.set({ "n", "x", "o" }, "L", "g_", { desc = "End of Line" })

-- Keep search results centered
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev Match (centered)" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Search Word (centered)" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Search Word Back (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", default_opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", default_opts)

-- Tab navigation
vim.keymap.set("n", "<C-x>t<C-c>", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<C-x>t<C-o>", ":tabnew<CR>", { desc = "Open tab" })
vim.keymap.set("n", "<C-x>t<C-h>", ":tabnew %<CR>", { desc = "Open current file in new tab" })
vim.keymap.set("n", "<C-x>t<C-n>", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<C-x>t<C-p>", ":tabprevious<CR>", { desc = "Previous tab" })

vim.keymap.set("n", "<C-x><C-c>", ":cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set("n", "<C-x><C-o>", ":copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<C-x><C-n>", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-x><C-p>", ":cprev<CR>", { desc = "Previous quickfix" })

-- ════════════════════════════════════════════════════════════════════════════
-- Better Editing
-- ════════════════════════════════════════════════════════════════════════════

-- Better indenting (stay in visual mode)
vim.keymap.set("v", "<", "<gv", { desc = "Indent Left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Right" })

-- Paste over selection without yanking
vim.keymap.set("v", "p", '"_dP', { desc = "Paste (no yank)" })

-- Yank block
vim.keymap.set("n", "YY", "va{Vy", { desc = "Yank Block {}" })

vim.keymap.set("n", "<C-x>0", "<cmd>hide<cr>", { desc = "Hide current window" })
vim.keymap.set("n", "<C-x>k", "<cmd>bdelete<cr>", { desc = "Kill/delete current buffer" })

-- Command aliases
vim.cmd("command! Wq wq")
vim.cmd("command! W w")
vim.cmd("command! Q q")
vim.cmd("command! X x")
vim.cmd("command! Xa xa")
