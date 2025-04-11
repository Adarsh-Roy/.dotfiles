return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        ["<CR>"] = {}, -- Unbind the <Enter> key so that it does nothing (i.e. inserts a newline)
      })
      return opts
    end,
  },
}
