-- This plugin allows for importing suggestions for the symbol under the cursor for pyright LSP
return {
  'stevanmilic/nvim-lspimport',
  config = function()
    -- Keymap to lazy-load lspimport module when triggered
    vim.keymap.set('n', '<leader>i', function()
      require('lspimport').import()
    end, { desc = '[I]mport' })
  end,
}
