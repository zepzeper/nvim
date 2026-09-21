-- UI: which-key, inline diagnostics, markdown rendering, icons
local pack = require("core.pack")

pack.add({ "https://github.com/echasnovski/mini.icons" })
pack.lazy({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })

pack.load_on("User", "tiny-inline-diagnostic.nvim", function()
  require("tiny-inline-diagnostic").setup({
    preset = "classic",
    options = {
      show_source = { enabled = false, if_many = false },
      add_messages = true,
      throttle = 20,
      multilines = { enabled = false, always_show = false },
      show_all_diags_on_cursorline = false,
      enable_on_insert = false,
      enable_on_select = false,
      overflow = { mode = "wrap", padding = 0 },
      virt_texts = { priority = 2048 },
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    },
  })
  -- Inline diagnostics replace virtual text (see plugins/lsp.lua)
  vim.diagnostic.config({ virtual_text = false })
end, "UIEnter")

pack.lazy({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })

pack.load_on("FileType", "render-markdown.nvim", function()
  require("render-markdown").setup({
    heading = {
      enabled = true,
      sign = false,
      icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
      left_pad = 1,
      right_pad = 1,
      border = "thin",
      language_pad = 1,
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "☐ " },
      checked = { icon = "☑ " },
    },
    quote = { enabled = true, icon = "▎" },
    pipe_table = { enabled = true, style = "full" },
    callout = {
      note = { raw = "[!NOTE]", rendered = " Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = " Tip", highlight = "RenderMarkdownSuccess" },
      important = {
        raw = "[!IMPORTANT]",
        rendered = " Important",
        highlight = "RenderMarkdownHint",
      },
      warning = { raw = "[!WARNING]", rendered = " Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = " Caution", highlight = "RenderMarkdownError" },
    },
  })
end, "markdown")

vim.keymap.set("n", "<leader>mr", function()
  if vim.bo.filetype == "markdown" then
    pack.load("render-markdown.nvim", nil)
    vim.cmd("RenderMarkdown toggle")
  end
end, { desc = "Render Markdown Toggle" })
