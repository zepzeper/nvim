-- Emacs `M-x` completes over commands only; key bindings are shown as
-- annotations on those candidates, not as candidates of their own
-- (`suggest-key-bindings`, on by default). Neovim keeps no command->key index,
-- so derive one from any mapping whose rhs is a plain `<Cmd>Foo<CR>` / `:Foo<CR>`.
-- Mappings bound to Lua callbacks carry no rhs and cannot be attributed.
local function command_keys()
  local all = {} ---@type table<string, table<string, true>>
  for _, mode in ipairs({ "n", "x", "i" }) do
    local maps = vim.api.nvim_get_keymap(mode)
    vim.list_extend(maps, vim.api.nvim_buf_get_keymap(0, mode))
    for _, m in ipairs(maps) do
      local name = m.rhs
        and (m.rhs:match("^<[Cc][Mm][Dd]>%s*(%a[%w_]*)") or m.rhs:match("^:%s*(%a[%w_]*)"))
      -- Require two chars, so the `:m '>+1` of a line-move mapping is not
      -- read as the `:move` command and annotated onto it.
      if name and #name > 1 then
        all[name] = all[name] or {}
        all[name][vim.fn.keytrans(vim.api.nvim_replace_termcodes(m.lhs, true, true, true))] = true
      end
    end
  end
  -- `nvim_get_keymap` order is not stable, so a command with several bindings
  -- would otherwise be annotated with a different one run to run. Pick the
  -- shortest, breaking ties lexically, so the annotation is stable.
  local keys = {} ---@type table<string, string>
  for name, set in pairs(all) do
    local lhs = vim.tbl_keys(set)
    table.sort(lhs, function(a, b)
      return #a == #b and a < b or #a < #b
    end)
    keys[name] = lhs[1]
  end
  return keys
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
      },
    },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    picker = {
      enabled = true,
      layout = {
        preset = "ivy_split",
        -- 10 candidate rows, like vertico-count in Doom
        layout = { height = 13 },
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        filename_bonus = true,
        cwd_bonus = true,
        frecency = true,
        history_bonus = true,
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = "left",
          min_width = 60,
        },
      },
      win = {
        input = {
          keys = {
            ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
            ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
            ["<C-p>"] = { "toggle_preview", mode = { "n", "i" } },
          },
        },
      },
      sources = {
        apidocs = {},
        files = { limit = 10000, hidden = true },
        grep = { limit = 10000 },
        gh_issue = {},
        gh_pr = {},
        -- These preview a `vim.inspect()` dump, not a file. With the global
        -- `preview = "main"` that dump floats over the whole editor, which is
        -- noise -- Emacs `M-x` never touches your buffer. Drop the preview.
        commands = { layout = { preview = false } },
        keymaps = { layout = { preview = false } },
        registers = { layout = { preview = false } },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = { notification = {} },
    gh = {},
  },
  keys = {
    -- ════════════════════════════════════════════════════════════════════
    -- Top-level (most used - quick access)
    -- ════════════════════════════════════════════════════════════════════
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch Buffer",
    },
    {
      "<C-p>",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Files",
    },

    -- M-x = execute-extended-command: commands only, annotated with their keys.
    {
      "<M-x>",
      function()
        local keys = command_keys()
        Snacks.picker.commands({
          title = "M-x",
          format = function(item, picker)
            local ret = Snacks.picker.format.command(item, picker)
            local key = keys[item.cmd]
            if key then
              ret[#ret + 1] = { " " }
              ret[#ret + 1] = { key, "SnacksPickerKey" }
            end
            return ret
          end,
        })
      end,
      desc = "M-x",
      mode = { "n", "x" },
    },

    -- Terminal
    {
      "<M-/>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Terminal",
    },
    {
      "<M-/>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Terminal",
      mode = "t",
    },

    -- Word navigation (LSP references)
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },

    -- ════════════════════════════════════════════════════════════════════
    -- <leader>b = Buffers
    -- ════════════════════════════════════════════════════════════════════
    -- C-x b = switch-to-buffer. Emacs defaults the candidate to the *other*
    -- buffer and excludes the current one, so `C-x b RET` toggles back.
    -- `C-x C-b` = list-buffers, which in Emacs keeps the current buffer listed.
    {
      "<C-x>b",
      function()
        Snacks.picker.buffers({ current = false })
      end,
      desc = "Switch Buffer (C-x b)",
    },
    {
      "<C-x><C-b>",
      function()
        Snacks.picker.buffers({ current = true })
      end,
      desc = "List Buffers (C-x C-b)",
    },
    -- ════════════════════════════════════════════════════════════════════
    -- <leader>c = Code
    -- ════════════════════════════════════════════════════════════════════
    -- li (info), lr (restart), lh (hints) - defined in lsp.lua
    -- ca (code action) - defined in lsp.lua
    -- cf (format) - defined in formatting.lua
    -- cr (rename symbol) - defined in lsp.lua
    -- cd (line diagnostic) - defined in lsp.lua

    -- ════════════════════════════════════════════════════════════════════
    -- <leader>f = Files
    -- ════════════════════════════════════════════════════════════════════
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word({ query = vim.fn.expand("<cword>") })
      end,
      desc = "Find Word",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help",
    },
    {
      "<leader>fm",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Config Files",
    },
    {
      "<leader>lg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep",
    },

    -- ════════════════════════════════════════════════════════════════════
    -- <leader>n = Notifications
    -- ════════════════════════════════════════════════════════════════════
    {
      "<leader>nn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>nd",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All",
    },

    -- ════════════════════════════════════════════════════════════════════
    -- <leader>s = Search
    -- ════════════════════════════════════════════════════════════════════
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Word",
      mode = { "n", "x" },
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },

    -- ════════════════════════════════════════════════════════════════════
    -- <leader>u = UI / Toggles
    -- ════════════════════════════════════════════════════════════════════
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>uz",
      function()
        Snacks.zen()
      end,
      desc = "Zen Mode",
    },
    {
      "<leader>uZ",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Zoom",
    },
    {
      "<leader>uN",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
      desc = "Neovim News",
    },
    -- Other toggles defined in init function below

    -- ════════════════════════════════════════════════════════════════════
    -- Zoom
    -- ════════════════════════════════════════════════════════════════════
    {
      "<M-z>",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Maximize",
    },

    -- ════════════════════════════════════════════════════════════════════
    -- g = Goto (LSP navigation via Snacks picker)
    -- ════════════════════════════════════════════════════════════════════
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Declaration",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gi",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Type Definition",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Debug globals
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        -- Toggle mappings under <leader>u
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.diagnostics():map("<leader>uD")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ui")
        Snacks.toggle.dim():map("<leader>ud")
      end,
    })
  end,
}
