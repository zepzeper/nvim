-- supermaven-nvim: AI completion — loaded on UIEnter (it spawns a node process)
local pack = require("core.pack")

pack.lazy({ "https://github.com/supermaven-inc/supermaven-nvim" })

pack.load_on("UIEnter", "supermaven-nvim", function()
  require("supermaven-nvim").setup({})
end)
