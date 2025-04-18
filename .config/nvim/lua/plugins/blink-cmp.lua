return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        ["<CR>"] = {}, -- Unbind the <Enter> key so that it does nothing (i.e. inserts a newline)
      })
      -- Disable the inline ghost‑text preview
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        ghost_text = {
          enabled = false, -- turn off virtual text :contentReference[oaicite:0]{index=0}
        },
      })
      return opts
    end,
  },
}
