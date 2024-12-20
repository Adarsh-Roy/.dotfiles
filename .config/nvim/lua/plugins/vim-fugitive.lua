return {
  'tpope/vim-fugitive',
  config = function()
    -- Keymaps for Vim Fugitive commands
    vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>', { desc = 'Git Stage current file' })
    vim.keymap.set('n', '<leader>ga.', ':Git add .<CR>', { desc = 'Git Add current directory' })
    vim.keymap.set('n', '<leader>gau', ':Git add -u<CR>', { desc = 'Git Add updated files only' })
    vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git Commit' })
    vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { desc = 'Git Push' })
    -- vim.keymap.set('n', '<leader>gl', ':Git log --oneline<CR>', { desc = 'Git Log (oneline)' })
    vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<CR>', { desc = 'Git Diff' })
  end,
}
