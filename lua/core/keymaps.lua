local default_opts = { noremap = true, silent = true }
-- ════════════════════════════════════════════════════════════════════════════
-- Essential Operations
-- ════════════════════════════════════════════════════════════════════════════

vim.keymap.set("n", "<C-c>", "<Nop>", default_opts)
vim.keymap.set("n", "<C-z>", "<Nop>", default_opts)

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear Highlight", silent = true })

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

-- ════════════════════════════════════════════════════════════════════════════
-- Toggles (<leader>u = UI/Toggle)
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>us", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>uw", function()
  vim.o.wrap = not vim.o.wrap
end, { desc = "Toggle Wrap" })
vim.keymap.set("n", "<leader>ur", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle Relative Number" })
vim.keymap.set("n", "<leader>ul", function()
  local on = vim.o.number or vim.o.relativenumber
  vim.o.number, vim.o.relativenumber = not on, not on
end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>uD", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
vim.keymap.set("n", "<leader>uc", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
end, { desc = "Toggle Conceal" })
vim.keymap.set("n", "<leader>uT", function()
  local ok = pcall(vim.treesitter.stop, 0)
  if ok then
    return
  end
  pcall(vim.treesitter.start, 0)
end, { desc = "Toggle Treesitter Highlighting" })
vim.keymap.set("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle Inlay Hints" })
vim.keymap.set("n", "<leader>ui", function()
  vim.o.list = not vim.o.list
end, { desc = "Toggle Indent Guides" })
