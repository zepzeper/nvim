return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = {},
  },
  -- Git related plugins
  {
   "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
}
