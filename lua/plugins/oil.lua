return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      -- Make Oil the default directory browser.
      default_file_explorer = true,

      -- Similar information density to `ls -la`.
      columns = {
        "permissions",
        "size",
        "mtime",
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
        number = false,
        relativenumber = false,
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
    },


    config = function(_, opts)
      require("oil").setup(opts)

      -- `-` from anywhere opens Oil.
      vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", {
        desc = "Open Oil",
      })


      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          vim.opt_local.cursorline = true

          -- Directories
          vim.api.nvim_set_hl(0, "OilDir", {
            fg = "#7aa2f7",
            bold = true,
          })

          -- Regular files
          vim.api.nvim_set_hl(0, "OilFile", {
            fg = "#c0caf5",
          })

          -- Links
          vim.api.nvim_set_hl(0, "OilLink", {
            fg = "#bb9af7",
            underline = true,
          })

          -- Make the current line stand out.
          vim.api.nvim_set_hl(0, "CursorLine", {
            bg = "#292e42",
          })
        end,
      })
    end,
  }
}
