-- Debugging: DAP — loaded on first debugger keypress
local pack = require("core.pack")

pack.lazy({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
})

local function load(fn)
  return pack.wrap("nvim-dap", function()
    -- dap-view first, so `require("dap-view")` in dap's listeners works
    pack.load("nvim-dap-view", function()
      require("dap-view").setup({
        winbar = {
          sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
          controls = { enabled = true, position = "left" },
        },
        windows = {
          position = "right",
          size = 0.3,
          terminal = {
            position = "below",
          },
        },
      })
    end)

    local dap = require("dap")

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { "/home/wouter/personal/vscode-php-debug/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        name = "Listen (Remote)",
        type = "php",
        request = "launch",
        port = 9000,
      },
      {
        name = "Listen (Local)",
        type = "php",
        request = "launch",
        port = 9003,
      },
    }

    vim.fn.sign_define("DapBreakpoint", { text = "●" })

    dap.listeners.before.attach.dap_view = function()
      require("dap-view").open()
    end
    dap.listeners.before.launch.dap_view = function()
      require("dap-view").open()
    end
    dap.listeners.before.event_terminated.dap_view = function()
      require("dap-view").close()
    end
    dap.listeners.before.event_exited.dap_view = function()
      require("dap-view").close()
    end
  end, fn)
end

vim.keymap.set("n", "<F5>", load(function()
  require("dap").continue()
end), { desc = "Continue" })
vim.keymap.set("n", "<F6>", load(function()
  require("dap").step_over()
end), { desc = "Step Over" })
vim.keymap.set("n", "<F7>", load(function()
  require("dap").step_into()
end), { desc = "Step Into" })
vim.keymap.set("n", "<F8>", load(function()
  require("dap").step_out()
end), { desc = "Step Out" })
vim.keymap.set("n", "<leader>dt", load(function()
  require("dap").toggle_breakpoint()
end), { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", load(function()
  require("dap").repl.open()
end), { desc = "Open REPL" })
vim.keymap.set("n", "<leader>dl", load(function()
  require("dap").run_last()
end), { desc = "Run Last" })
vim.keymap.set("n", "<leader>dc", load(function()
  require("dap").run_to_cursor()
end), { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dv", load(function()
  require("dap-view").toggle()
end), { desc = "Toggle View" })
