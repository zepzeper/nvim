-- Formatting: conform.nvim (eager: the global `formatexpr` requires it)
local pack = require("core.pack")

pack.add({ "https://github.com/stevearc/conform.nvim" })

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
  formatters_by_ft = {
    -- Go
    go = { "goimports", "gofmt" },

    -- Lua
    lua = { "stylua" },

    -- Web technologies
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },

    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },

    -- Other
    rust = { "rustfmt" },
    odin = { "ols" },

    xml = { "xmlformatter" },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true }, function(err, did_edit)
    if not err and did_edit then
      vim.notify("Formatted", vim.log.levels.INFO)
    end
  end)
end, { desc = "Format" })
