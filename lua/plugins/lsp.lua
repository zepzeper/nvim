-- ════════════════════════════════════════════════════════════════════════════
-- LSP Keymaps (applied per-buffer on attach)
-- ════════════════════════════════════════════════════════════════════════════
local function setup_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
  end

  local opts = {}
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

  -- <leader>l = LSP (using native :lsp command from 0.12)
  map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
  map("n", "<leader>lr", "<cmd>lsp restart<cr>", "LSP Restart")
  map("n", "<leader>lh", function()
    vim.lsp.inlay_hint.enable(
      not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
      { bufnr = bufnr }
    )
  end, "Toggle Inlay Hints")
end

-- ════════════════════════════════════════════════════════════════════════════
-- LspAttach Handler
-- ════════════════════════════════════════════════════════════════════════════
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
-- Diagnostic Configuration
-- ════════════════════════════════════════════════════════════════════════════
vim.diagnostic.config({
  virtual_text = true,
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

-- ════════════════════════════════════════════════════════════════════════════
-- Mason: auto-install LSP servers, formatters, and linters
-- ════════════════════════════════════════════════════════════════════════════
return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      automatic_installation = true,
      automatic_enable = false,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP servers, one per entry in vim.lsp.enable above.
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
    },
  },
}
