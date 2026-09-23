-- LSP: Mason (auto-install), native vim.lsp setup, diagnostics
local pack = require("core.pack")

-- ════════════════════════════════════════════════════════════════════════════
-- Mason: auto-install LSP servers, formatters, and linters
-- ════════════════════════════════════════════════════════════════════════════
pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason").setup({})

require("mason-lspconfig").setup({
  automatic_installation = true,
  automatic_enable = false,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    -- LSP servers, one per entry in vim.lsp.enable below.
    --
    -- These are listed explicitly because mason-lspconfig's
    -- automatic_installation only covers servers registered through
    -- lspconfig, and these are enabled with native vim.lsp.enable - so
    -- nothing was guaranteeing them. zls and json-lsp were in fact absent
    -- while the other eight happened to be installed.
    "lua-language-server",
    "zls",
    "rust-analyzer",
    "intelephense",
    "clangd",
    "bash-language-server",
    "json-lsp",
    "yaml-language-server",
    "slang",
    -- Build tooling, not an LSP: nvim-treesitter shells out to the
    -- tree-sitter CLI to build and generate parsers, and fails every
    -- parser with "ENOENT" when it is absent. Nothing in runs/ installs
    -- it, and Ubuntu has no package, so it comes from mason on both.
    "tree-sitter-cli",
    -- Linters
    "eslint_d",
    "luacheck",
    "golangci-lint",
    "shellcheck",
    "markdownlint",
    "yamllint",
    "jsonlint",
    "htmlhint",
    "phpstan",
    -- Formatters
    "stylua",
    "goimports",
    "prettier",
    "shfmt",
    "phpcs",
    -- ols is an LSP server, but stays here since it was already listed
    "ols",
  },
})

-- ════════════════════════════════════════════════════════════════════════════
-- LSP Keymaps (applied per-buffer on attach)
-- Global `gd`/`gr`/... navigation lives in plugins/fzf.lua.
-- ════════════════════════════════════════════════════════════════════════════
local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
  end

  map("n", "K", function()
    vim.lsp.buf.hover({
      border = "shadow",
      focusable = true,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      silent = true,

      -- Map floating-window highlight groups
      winhighlight = table.concat({
        "Normal:NormalFloat",
        "FloatBorder:FloatBorder",
        "CursorLine:CursorLine",
        "Search:None",
      }, ","),
    })
  end, "LSP hover documentation" )

  map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace Symbol")
  map("n", "<leader>vd", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "<leader>vca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>vrn", vim.lsp.buf.rename, "Rename")
  map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = vim.v.count1, float = true })
  end, "Next Diagnostic")
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -vim.v.count1, float = true })
  end, "Prev Diagnostic")

  -- <leader>l = LSP (using native :lsp command from 0.12)
  map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
  map("n", "<leader>lr", "<cmd>lsp restart<cr>", "LSP Restart")
  map("n", "<leader>lh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, "Toggle Inlay Hints")
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    setup_keymaps(bufnr)

    -- Document highlight on cursor hold
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ════════════════════════════════════════════════════════════════════════════
-- Diagnostic configuration (single source of truth; inline diagnostics are
-- rendered by tiny-inline-diagnostic, so virtual text stays off)
-- ════════════════════════════════════════════════════════════════════════════
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true, header = "", prefix = "" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

-- ════════════════════════════════════════════════════════════════════════════
-- LSP Server Configuration (native 0.12 API)
-- Server configs loaded from lsp/ directory, activated with vim.lsp.enable()
-- ════════════════════════════════════════════════════════════════════════════
vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.enable({
  "org",
  "lua_ls",
  "zls",
  "rust_analyzer",
  "intelephense",
  "clangd",
  "bashls",
  "jsonls",
  "yamlls",
  "ols",
  "slang",
  "jinja-lsp",
})
