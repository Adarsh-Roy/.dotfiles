return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  opts = function(_, opts)
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local c = ls.choice_node
    local f = ls.function_node

    -----------------------------------------------------------
    -- Keymaps
    -----------------------------------------------------------
    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = "Cycle through LuaSnip choices" })

    -----------------------------------------------------------
    -- Helper methods
    -----------------------------------------------------------
    -- Get Clipboard
    local function clipboard()
      return vim.fn.getreg("+")
    end

    ------------------------------------------------------------------
    --- Python
    ------------------------------------------------------------------
    local python_snippets = {}
    table.insert(
      python_snippets,
      s(
        { trig = "inpy", dscr = "Python CP input methods" },
        t({
          "def read_int():",
          "    return int(input())",
          "",
          "def read_ints():",
          "    return list(map(int, input().split()))",
          "",
          "def read_str():",
          "    return input().strip()",
          "",
          "def read_strs():",
          "    return input().split()",
          "",
        })
      )
    )
    table.insert(
      python_snippets,
      s(
        { trig = "telr", dscr = "Try/Except block with optional logging/raising" },
        require("luasnip.extras.fmt").fmt(
          [[
try:
    {}
except Exception as e:
    {}
]],
          {
            -- Node 1: Editable try block
            i(2),
            -- Node 2: Choice node for the except block alternatives.
            c(1, {
              t('LOG.error(f"Error msg: {e}")'), -- Option 1: Log only.
              t("raise e"), -- Option 2: Raise only.
              t({ 'LOG.error(f"Error msg: {e}")', "    raise e" }), -- Option 3: Log then raise.
            }),
          }
        )
      )
    )
    table.insert(
      python_snippets,
      s(
        { trig = "deprdoc", dscr = "Deprecate a function with docstring" },
        require("luasnip.extras.fmt").fmt(
          [[
"""
DEPRECATED: {}
"""
]],
          {
            i(0),
          }
        )
      )
    )
    table.insert(
      python_snippets,
      s(
        { trig = "doc", dscr = "Add a function docstring" },
        require("luasnip.extras.fmt").fmt(
          [[
"""
{}

Args:

Returns:
"""
]],
          {
            i(0),
          }
        )
      )
    )
    ls.add_snippets("python", python_snippets)
    ------------------------------------------------------------
    -- Markdown
    ------------------------------------------------------------
    local function create_code_block_snippet(lang)
      return s({ trig = lang, name = "Codeblock", desc = lang .. " codeblock" }, {
        t({ "```" .. lang, "" }),
        i(1),
        t({ "", "```" }),
      })
    end

    local languages = {
      "txt",
      "lua",
      "sql",
      "go",
      "regex",
      "bash",
      "markdown",
      "markdown_inline",
      "yaml",
      "json",
      "jsonc",
      "cpp",
      "csv",
      "java",
      "javascript",
      "python",
      "dockerfile",
      "html",
      "css",
      "templ",
      "php",
    }
    local md_snippets = {}
    for _, lang in ipairs(languages) do
      table.insert(md_snippets, create_code_block_snippet(lang))
    end

    table.insert(
      md_snippets,
      s({ trig = "linkc", dscr = "Add clipboard link" }, {
        t("["),
        i(1),
        t("]("),
        f(clipboard, {}),
        t(")"),
      })
    )
    ls.add_snippets("markdown", md_snippets)

    return opts
  end,
}
