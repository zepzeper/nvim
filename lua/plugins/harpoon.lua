-- Harpoon: quick file navigation — loaded on first keypress
local pack = require("core.pack")

pack.add({ "https://github.com/nvim-lua/plenary.nvim" }) -- harpoon dependency
pack.lazy({ { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" } })

local function load(fn)
  return pack.wrap("harpoon", function()
    require("harpoon").setup({
      settings = {
        key = function()
          local cwd = vim.uv.cwd()
          local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
          if vim.v.shell_error == 0 then
            return cwd .. "-" .. branch
          end
          return cwd
        end,
      },
    })
  end, fn)
end

vim.keymap.set("n", "<leader>a", load(function()
  require("harpoon"):list():add()
end), { desc = "Harpoon Add File" })

vim.keymap.set("n", "<M-e>", load(function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end), { desc = "Harpoon Menu" })

for i = 1, 4 do
  vim.keymap.set("n", ("<M-%d>"):format(i), load(function()
    require("harpoon"):list():select(i)
  end), { desc = ("Harpoon File %d"):format(i) })
end
