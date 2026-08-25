return {
  {
    vim.keymap.set("n", "<C-x>b", function()
      require("fzf-lua").buffers({
        cwd_only = false,
        sort_lastused = true,
      })
    end, {
        desc = "Switch buffer",
      })
  }
}
