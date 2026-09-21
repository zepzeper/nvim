-- Docs: apidocs.nvim — loaded on first command or keypress.
-- Uses vim.ui.select (served by fzf-lua); note ApidocsSearch is not
-- supported by the ui_select backend, only ApidocsOpen.
local pack = require("core.pack")

pack.lazy({ "https://github.com/emmanueltouzery/apidocs.nvim" })

local function ensure()
  pack.load("apidocs.nvim", function()
    require("apidocs").setup({ picker = "ui_select" })
  end)
end

-- Stubs: apidocs only registers its real commands during setup(), so
-- intercept the first invocation, load the plugin, then re-dispatch.
for _, cmd in ipairs({ "ApidocsOpen", "ApidocsSearch", "ApidocsInstall", "ApidocsUninstall" }) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    ensure()
    vim.cmd(("%s%s%s"):format(cmd, opts.bang and "!" or "", opts.args ~= "" and " " .. opts.args or ""))
  end, { nargs = "*", bang = true, desc = "apidocs (loads on first use)" })
end

vim.keymap.set("n", "<C-x>p", "<cmd>ApidocsOpen<cr>", { desc = "Docs: Open (browse)" })
