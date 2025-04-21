return {
  "azorng/goose.nvim",
  branch = "main",
  config = function()
    require("goose").setup({
      keymap = {
        global = {
          toggle = "<leader>Gg", -- Open goose. Close if opened
          open_input = "<leader>Gi", -- Opens and focuses on input window on insert mode
          open_input_new_session = "<leader>GI", -- Opens and focuses on input window on insert mode. Creates a new session
          open_output = "<leader>Go", -- Opens and focuses on output window
          toggle_focus = "<leader>Gt", -- Toggle focus between goose and last window
          close = "<leader>Gq", -- Close UI windows
          toggle_fullscreen = "<leader>Gf", -- Toggle between normal and fullscreen mode
          select_session = "<leader>Gs",
        },
      },
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
      },
    },
  },
}
