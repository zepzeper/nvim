return {
  {
    'emmanueltouzery/apidocs.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    cmd = { 'ApidocsSearch', 'ApidocsInstall', 'ApidocsOpen', 'ApidocsUninstall' },
    config = function()
      require('apidocs').setup({ picker = 'ui_select' })
    end,
    keys = {
       { '<C-x>p', '<cmd>ApidocsOpen<cr>', desc = 'Docs: Open (browse)' },
    },
  }
}
