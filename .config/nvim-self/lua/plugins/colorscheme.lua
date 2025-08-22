return {
  {
    "catppuccin/nvim",
    enabled = true,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })

      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end
  },
}
