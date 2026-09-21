-- Colorschemes. All are installed; the active theme is decided by
-- auto-dark-mode below (nordic for dark, gruvbox for light) so no
-- colorscheme module may run `:colorscheme` itself.
local pack = require("core.pack")

pack.add({
  -- Utility: follow the OS dark/light preference
  "https://github.com/f-person/auto-dark-mode.nvim",

  -- The two actively used themes
  { src = "https://github.com/AlexvZyl/nordic.nvim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },

  -- The rest of the collection (switch with <leader>uC)
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/EdenEast/nightfox.nvim" },
  { src = "https://github.com/neanias/everforest-nvim" },
  { src = "https://github.com/shaunsingh/nord.nvim", name = "nord-shaunsingh" },
  { src = "https://github.com/sainnhe/sonokai" },
  { src = "https://github.com/Mofiqul/dracula.nvim" },
  { src = "https://github.com/marko-cerovac/material.nvim" },
  { src = "https://github.com/projekt0n/github-nvim-theme", name = "github-theme" },
  { src = "https://github.com/kepano/flexoki-neovim" },
  { src = "https://github.com/datsfilipe/vesper.nvim" },
  { src = "https://github.com/navarasu/onedark.nvim" },
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/Shatur/neovim-ayu" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/adibhanna/yukinord.nvim" },
  { src = "https://github.com/adibhanna/forest-night.nvim" },
  { src = "https://github.com/gbprod/nord.nvim", name = "nord-gbprod" },
})

-- ════════════════════════════════════════════════════════════════════════════
-- Per-theme configuration
-- ════════════════════════════════════════════════════════════════════════════

-- Catppuccin: custom gruvbox-ish latte and yukinord-ish mocha palettes
require("catppuccin").setup({
  background = {
    light = "latte",
    dark = "mocha",
  },
  color_overrides = {
    latte = {
      rosewater = "#c14a4a",
      flamingo = "#c14a4a",
      red = "#c14a4a",
      maroon = "#c14a4a",
      pink = "#945e80",
      mauve = "#945e80",
      peach = "#c35e0a",
      yellow = "#b47109",
      green = "#6c782e",
      teal = "#4c7a5d",
      sky = "#4c7a5d",
      sapphire = "#4c7a5d",
      blue = "#45707a",
      lavender = "#45707a",
      text = "#654735",
      subtext1 = "#73503c",
      subtext0 = "#805942",
      overlay2 = "#8c6249",
      overlay1 = "#8c856d",
      overlay0 = "#a69d81",
      surface2 = "#bfb695",
      surface1 = "#d1c7a3",
      surface0 = "#e3dec3",
      base = "#f9f5d7",
      mantle = "#f0ebce",
      crust = "#e8e3c8",
    },
    mocha = {
      rosewater = "#d08770",
      flamingo = "#d08770",
      red = "#bf616a",
      maroon = "#bf616a",
      pink = "#b48ead",
      mauve = "#b48ead",
      peach = "#d08770",
      yellow = "#ebcb8b",
      green = "#a3be8c",
      teal = "#8fbcbb",
      sky = "#88c0d0",
      sapphire = "#5e81ac",
      blue = "#81a1c1",
      lavender = "#88c0d0",
      text = "#eceff4",
      subtext1 = "#e5e9f0",
      subtext0 = "#d8dee9",
      overlay2 = "#8d929c",
      overlay1 = "#7b8394",
      overlay0 = "#616e88",
      surface2 = "#4c566a",
      surface1 = "#434c5e",
      surface0 = "#3b4252",
      base = "#1B212B",
      mantle = "#14171d",
      crust = "#0f1115",
    },
  },
  transparent_background = false,
  show_end_of_buffer = false,
  default_integrations = false,
  no_bold = true,
  no_italic = true,
  no_underline = true,
  integrations = {
    blink_cmp = { style = "bordered" },
    native_lsp = { enabled = true, inlay_hints = { background = true } },
    semantic_tokens = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
    mason = true,
    dap_ui = true,
  },
})

-- Tokyonight
require("tokyonight").setup({
  style = "moon", -- "storm", "night", "moon", "day"
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  },
})

-- Nightfox (variants: nightfox, duskfox, nordfox, terafox, carbonfox)
require("nightfox").setup({
  options = {
    transparent = true,
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  },
})

-- Everforest
require("everforest").setup({
  background = "hard", -- "soft", "medium", "hard"
  transparent_background_level = 0,
  italics = false,
})

-- Nord (shaunsingh)
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = false
vim.g.nord_italic = false

-- Sonokai
vim.g.sonokai_style = "shusia" -- "default", "atlantis", "andromeda", "shusia", "maia", "espresso"
vim.g.sonokai_enable_italic = false

-- Dracula
require("dracula").setup({
  italic_comment = false,
  transparent_bg = false,
})

-- Material
vim.g.material_style = "deep ocean" -- "darker", "lighter", "oceanic", "palenight", "deep ocean"
require("material").setup({
  italics = { comments = false, keywords = false },
})

-- Nordic
require("nordic").setup({
  bold_keywords = true,
  italic_comments = false,
  transparent = { bg = true, float = true },
  bright_border = true,
  reduced_blue = false,
  swap_backgrounds = false,
  cursorline = {
    bold = true,
    bold_number = true,
    theme = "dark",
    blend = 0.85,
  },
  ts_context = { dark_background = true },
})

-- GitHub
require("github-theme").setup({
  options = {
    hide_end_of_buffer = true,
    hide_nc_statusline = true,
    transparent = false,
    terminal_colors = true,
    dim_inactive = false,
    styles = {
      comments = "NONE",
      functions = "NONE",
      keywords = "NONE",
      variables = "NONE",
      conditionals = "NONE",
      constants = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
    },
    darken = { floats = true },
  },
})

-- Rose Pine
require("rose-pine").setup({
  disable_background = true,
  styles = {
    italic = false,
  },
})

-- Gruvbox
require("gruvbox").setup({
  terminal_colors = false,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true,
  contrast = "", -- can be "hard", "soft" or empty string
  overrides = {
    SignColumn = { bg = "#ff9900" },
  },
  dim_inactive = true,
  transparent_mode = false,
})

-- Ayu
require("ayu").setup({
  mirage = false,
})

-- Yukinord
require("yukinord").setup({
  transparent = true,
  transparent_sidebar = true,
})

-- Nord (gbprod)
require("nord").setup({
  transparent = true,
  terminal_colors = true,
  diff = { mode = "bg" },
  borders = true,
  errors = { mode = "bg" },
  search = { theme = "vim" },
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = {},
  },
})

local function set_theme(dark)
  vim.o.background = dark and "dark" or "light"
  vim.cmd.colorscheme(dark and "nordic" or "gruvbox")
end

require("auto-dark-mode").setup({
  update_interval = 1000,
  set_dark_mode = function()
    set_theme(true)
  end,
  set_light_mode = function()
    set_theme(false)
  end,
})

vim.keymap.set("n", "<leader>ub", function()
  set_theme(vim.o.background ~= "dark")
end, { desc = "Toggle Dark Mode" })
