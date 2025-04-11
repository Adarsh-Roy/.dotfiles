return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  build = function()
    require("typst-preview").update()
  end,
  opts = {
    follow_cursor = true,
  },
  keys = {
    {
      "<leader>tp",
      function()
        vim.cmd("TypstPreview")
      end,
      desc = "Typst: Start Preview",
    },
    {
      "<leader>tc",
      function()
        vim.cmd("TypstPreviewFollowCursorToggle")
      end,
      desc = "Typst: Toggle Cursor Follow",
    },
  },
}
