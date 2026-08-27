return {
  {
    "girishji/devdocs.vim",
    cmd = { "DevdocsFind", "DevdocsInstall", "DevdocsUninstall" },
    init = function()
      vim.g.DevdocsOptions = {
        data_dir = vim.fn.expand("~/.local/share/devdocs"),
        pandoc = "pandoc",
        height = 20,
        open_mode = "split",
      }
    end,
    keys = {
      { "<leader>dd", "<cmd>DevdocsFind<CR>", desc = "DevDocs: Find" },
      { "<leader>di", "<cmd>DevdocsInstall<CR>", desc = "DevDocs: Install" },
    },
  }
}
