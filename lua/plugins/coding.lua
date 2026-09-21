-- Coding: completion, treesitter, Lua dev, comments
local pack = require("core.pack")

-- ════════════════════════════════════════════════════════════════════════════
-- Completion (blink.cmp) — loaded on first insert
-- ════════════════════════════════════════════════════════════════════════════
pack.lazy({
  -- Track release tags
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
})

pack.load_on("InsertEnter", "blink.cmp", function()
  require("blink.cmp").setup({
    snippets = { preset = "default" },
    signature = { enabled = true },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
    },
    sources = {
      default = { "lazydev", "lsp", "path", "buffer", "snippets" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        cmdline = {
          min_keyword_length = 2,
        },
      },
    },
    keymap = {
      ["<C-f>"] = {},
    },
    cmdline = {
      enabled = false,
      completion = { menu = { auto_show = true } },
      keymap = {
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
    },
    completion = {
      menu = {
        border = "rounded",
        scrolloff = 1,
        scrollbar = false,
        draw = {
          padding = 1,
          gap = 1,
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
            { "source_name" },
          },
        },
      },
      documentation = {
        window = {
          border = "rounded",
          scrollbar = false,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
        },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
  })
end)

-- ════════════════════════════════════════════════════════════════════════════
-- Treesitter (eager: highlighting/indentation needed for every buffer)
-- ════════════════════════════════════════════════════════════════════════════
pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local parsers = {
  "bash",
  "c",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json",
  "latex",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "odin",
  "php",
  "query",
  "regex",
  "rust",
  "terraform",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}
require("nvim-treesitter").install(parsers)

-- Enable treesitter-based highlighting and indentation per-buffer
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("treesitter-context").setup()

-- ════════════════════════════════════════════════════════════════════════════
-- Lua development (lazydev) — loaded on first Lua buffer
-- ════════════════════════════════════════════════════════════════════════════
pack.lazy({ "https://github.com/folke/lazydev.nvim" })

pack.load_on("FileType", "lazydev.nvim", function()
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end, "lua")

-- ════════════════════════════════════════════════════════════════════════════
-- Comments
-- ════════════════════════════════════════════════════════════════════════════
pack.add({ "https://github.com/numToStr/Comment.nvim" })
require("Comment").setup({})
