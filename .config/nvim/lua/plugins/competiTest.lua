return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('competitest').setup {
      testcases_use_single_file = true,
      open_received_problems = true,
      open_received_contests = true,
    }
  end,

  -- Keymaps
  vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<CR>', { desc = '[C]ompetiTest [R]un' }),
  vim.keymap.set('n', '<leader>cap', '<cmd>CompetiTest receive problem<CR>', { desc = '[C]ompetiTest [A]dd [P]roblem' }),
  vim.keymap.set('n', '<leader>cac', '<cmd>CompetiTest receive contest<CR>', { desc = '[C]ompetiTest [A]dd [C]ontest' }),
  vim.keymap.set('n', '<leader>cat', '<cmd>CompetiTest add_testcase<CR>', { desc = '[C]ompetiTest [A]dd [T]est Case' }),
  vim.keymap.set('n', '<leader>cet', '<cmd>CompetiTest edit_testcase<CR>', { desc = '[C]ompetiTest [E]dit [T]est Case' }),
  vim.keymap.set('n', '<leader>cdt', '<cmd>CompetiTest delete_testcase<CR>', { desc = '[C]ompetiTest [D]elete [T]est Case' }),
}
