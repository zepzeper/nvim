return {
  {
    'emmanueltouzery/apidocs.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'ApidocsSearch', 'ApidocsInstall', 'ApidocsOpen', 'ApidocsUninstall' },
    config = function()
      require('apidocs').setup({ picker = 'snacks' })
    end,
    keys = {
       { '<C-x>p', '<cmd>ApidocsOpen<cr>', desc = 'Docs: Open (browse)' },
    },
  }
}
