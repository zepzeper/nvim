-- Oil: file explorer (eager: acts as the default directory browser)
local pack = require("core.pack")

pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  -- Make Oil the default directory browser.
  default_file_explorer = true,

  -- Similar information density to `ls -la`.
  columns = {
    "permissions",
    "size",
    "mtime",
    "user",
    "group",
  },

  -- Show dotfiles by default.
  view_options = {
    show_hidden = true,

    -- Don't show ".." in the listing.
    is_always_hidden = function(name)
      return name == ".."
    end,

    natural_order = true,
  },

  -- Make the window easier to read.
  win_options = {
    cursorline = true,
    wrap = false,
    number = true,
    relativenumber = true,
    signcolumn = "no",
  },

  -- Don't immediately throw deleted files away.
  delete_to_trash = true,

  -- Don't ask unnecessarily for simple edits.
  skip_confirm_for_simple_edits = true,

  keymaps = {
    -- Navigation
    ["<CR>"] = "actions.select",
    ["l"] = "actions.select",
    ["h"] = "actions.parent",

    -- Dired-style quit
    ["q"] = "actions.close",

    -- Refresh
    ["gr"] = "actions.refresh",

    -- Hidden files
    ["."] = "actions.toggle_hidden",

    -- Sorting
    ["gs"] = "actions.change_sort",

    -- Help
    ["?"] = "actions.show_help",

    -- Split navigation
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-x>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",

    -- Open externally
    ["gx"] = "actions.open_external",

    -- Go to working directory
    ["_"] = "actions.open_cwd",

    -- Parent directory
    ["-"] = "actions.parent",
  },
  use_default_keymaps = false,
})

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open Oil" })

-- Keep Oil's faces tied to the active colorscheme instead of hardcoded hexes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.api.nvim_set_hl(0, "OilDir", { link = "Directory", bold = true })
    vim.api.nvim_set_hl(0, "OilFile", { link = "Normal" })
    vim.api.nvim_set_hl(0, "OilLink", { link = "Underlined" })
  end,
})
