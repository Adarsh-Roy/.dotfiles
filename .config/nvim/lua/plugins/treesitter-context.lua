return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true, -- Activate the plugin
      max_lines = 6, -- 0 for unlimited lines; change this to limit total visible lines
      trim_scope = "outer", -- Trim the outer context if it's too long
      mode = "cursor", -- Update the context based on the current cursor position
      separator = nil, -- You can set a separator string if you wish (default is nil)
      patterns = {
        default = {
          "class", -- Classes
          "function", -- Functions
          "method", -- Methods
          "if_statement", -- If statements
          "for_statement", -- For loops
          "while_statement", -- While loops
          "switch_statement", -- Switch statements (if applicable)
        },
        python = {
          "class",
          "function",
          "if_statement",
          "elif_statement", -- Includes elif
          "else_clause", -- Includes else
          "for_statement",
          "while_statement",
          "try_statement", -- Try/except blocks
          "with_statement", -- With context managers
        },
        javascript = {
          "class",
          "function",
          "method",
          "if_statement",
          "for_statement",
          "while_statement",
          "switch_statement",
        },
        lua = {
          "function",
          "if_statement",
          "for_statement",
          "while_statement",
        },
      },
    },
  },
}
