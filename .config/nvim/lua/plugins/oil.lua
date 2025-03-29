return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
    })

    -- Open parent directory in floating window
    vim.keymap.set("n", "-", function()
      require("oil").toggle_float()
    end, { desc = "Open parent directory in floating window" })
  end,
}
