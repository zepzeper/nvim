-- fzf-lua: picker (files, grep, buffers, LSP navigation) — replaces snacks.picker
local pack = require("core.pack")

pack.lazy({ "https://github.com/ibhagwan/fzf-lua" })

local function load(fn)
  return pack.wrap("fzf-lua", function()
    local fzf = require("fzf-lua")
    fzf.setup({
      -- Ivy-style bottom split
      winopts = {
        split = "belowright 20new",
        border = "none",
        preview = {
          layout = "horizontal",
          horizontal = "right:70%",
        },
      },
      -- Derive all fzf colors from the active colorscheme (follows
      -- nordic/gruvbox switches automatically).
      fzf_colors = true,
      -- Bind tables REPLACE defaults unless `[1] = true` inherits them.
      -- Preview keys: the builtin previewer (used by all our pickers) reads
      -- `keymap.builtin`, not `keymap.fzf` (that's for bat/cat/... previewers).
      actions = {
        files = {
          true, -- inherit defaults (enter, <A-q> quickfix, <A-Q> loclist, ...)
          ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
        },
      },
      keymap = {
        builtin = {
          true, -- inherit defaults (<F1>-<F9>, <M-Esc>, <S-down>/<S-up>, ...)
          -- NOTE: keys must use neovim notation ("<C-d>", not "ctrl-d") —
          -- these become terminal-mode mappings in the fzf window.
          ["<C-p>"] = "toggle-preview",
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
      },
    })
    -- Serve vim.ui.select (used by e.g. apidocs.nvim) through fzf-lua
    fzf.register_ui_select()
  end, fn)
end

-- ════════════════════════════════════════════════════════════════════════════
-- Top-level (most used)
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<C-p>", load(function()
  require("fzf-lua").git_files()
end), { desc = "Find Files" })

vim.keymap.set({ "n", "x" }, "<M-x>", load(function()
  require("fzf-lua").commands()
end), { desc = "Commands (M-x)" })

-- ════════════════════════════════════════════════════════════════════════════
-- Buffers (C-x b = switch-to-buffer, C-x C-b = list-buffers)
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<C-x>b", load(function()
  require("fzf-lua").buffers({ sort_lastused = true })
end), { desc = "Switch Buffer" })
vim.keymap.set("n", "<C-x><C-b>", load(function()
  require("fzf-lua").buffers()
end), { desc = "List Buffers" })

-- ════════════════════════════════════════════════════════════════════════════
-- <leader>f = Files
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>ff", load(function()
  require("fzf-lua").files()
end), { desc = "Find Files" })
vim.keymap.set("n", "<leader>fw", load(function()
  require("fzf-lua").grep_cword()
end), { desc = "Find Word" })
vim.keymap.set("n", "<leader>fh", load(function()
  require("fzf-lua").help_tags()
end), { desc = "Help" })
vim.keymap.set("n", "<leader>fm", load(function()
  require("fzf-lua").manpages()
end), { desc = "Man Pages" })
vim.keymap.set("n", "<leader>fr", load(function()
  require("fzf-lua").oldfiles()
end), { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fc", load(function()
  require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
end), { desc = "Config Files" })
vim.keymap.set("n", "<leader>lg", load(function()
  require("fzf-lua").live_grep()
end), { desc = "Live Grep" })

-- ════════════════════════════════════════════════════════════════════════════
-- <leader>s = Search
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set({ "n", "x" }, "<leader>sw", load(function()
  local fzf = require("fzf-lua")
  if vim.fn.mode():find("^[vV]") then
    fzf.grep_visual()
  else
    fzf.grep_cword()
  end
end), { desc = "Word" })
vim.keymap.set("n", "<leader>sb", load(function()
  require("fzf-lua").blines()
end), { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sk", load(function()
  require("fzf-lua").keymaps()
end), { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sM", load(function()
  require("fzf-lua").manpages()
end), { desc = "Man Pages" })

-- ════════════════════════════════════════════════════════════════════════════
-- <leader>u = UI
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>uC", load(function()
  require("fzf-lua").colorschemes()
end), { desc = "Colorschemes" })

-- ════════════════════════════════════════════════════════════════════════════
-- <leader>d = Diagnostics
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>dd", load(function()
  require("fzf-lua").diagnostics_document()
end), { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>dw", load(function()
  require("fzf-lua").diagnostics_workspace()
end), { desc = "Workspace Diagnostics" })

-- ════════════════════════════════════════════════════════════════════════════
-- g = Goto (LSP navigation through the picker)
-- ════════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "gd", load(function()
  require("fzf-lua").lsp_definitions()
end), { desc = "Definition" })
vim.keymap.set("n", "gD", load(function()
  require("fzf-lua").lsp_declarations()
end), { desc = "Declaration" })
vim.keymap.set("n", "gr", load(function()
  require("fzf-lua").lsp_references()
end), { desc = "References" })
vim.keymap.set("n", "gi", load(function()
  require("fzf-lua").lsp_implementations()
end), { desc = "Implementation" })
vim.keymap.set("n", "gy", load(function()
  require("fzf-lua").lsp_type_definitions()
end), { desc = "Type Definition" })
