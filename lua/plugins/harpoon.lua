-- Harpoon: Quick file navigation
return {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        key = function()
          local cwd = vim.loop.cwd()
          local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
          if vim.v.shell_error == 0 then
            return cwd .. "-" .. branch
          end
          return cwd
        end,
      },
    })
  end,
  keys = {
    {
      "<leader>a",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon Add File",
    },
    {
      "<M-e>",
      function()
        require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon Menu",
    },
    {
      "<M-1>",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon File 1",
    },
    {
      "<M-2>",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon File 2",
    },
    {
      "<M-3>",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon File 3",
    },
    {
      "<M-4>",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon File 4",
    },
  },
}
