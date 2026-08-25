return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = true,

      columns = {
        "icon",
      },

      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, bufnr)
          return name == ".."
        end,
      },

      delete_to_trash = true,

      skip_confirm_for_simple_edits = true,

      prompt_save_on_select_new_entry = true,

      keymaps = {
        ["g?"] = "actions.show_help",

        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",

        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",

        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",

        ["g."] = "actions.toggle_hidden",

        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",

        ["g\\"] = "actions.toggle_trash",

        ["<C-s>"] = "actions.save",
      },

      use_default_keymaps = false,
    },

    config = function(_, opts)
      require("oil").setup(opts)

      vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", {
        desc = "Open parent directory",
      })
    end,
    default_file_explorer = true,
  }
}
