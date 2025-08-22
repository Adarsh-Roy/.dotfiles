return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  opts = function(_, opts)
    opts.enable_autosnippets = true
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
          "import sys",
          "input = sys.stdin.readline",
          "def inint() -> int: return int(input())",
          "def instr() -> str: return input().strip()",
          "def inintlist() -> list[int]: return list(map(int, input().split()))",
          "def instrlist() -> list[str]: return input().split()",
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
    -- Typst
    ------------------------------------------------------------
    local typst_snippets = {}
    table.insert(
      typst_snippets,
      s({ trig = "mt", dscr = "Math inline shortcut", snippetType = "autosnippet" }, {
        t("$"),
        i(1),
        t("$"),
      })
    )
    table.insert(
      typst_snippets,
      s({ trig = "mmt", dscr = "Math multiline block", snippetType = "autosnippet" }, {
        t({ "$", "" }),
        i(1),
        t({ "", "$" }),
      })
    )

    ------------------------------------------------------------
    -- Coding blocks are common to typst and markdown
    ------------------------------------------------------------
    local function create_code_block_snippet(lang)
      return s({ trig = lang, name = "Codeblock", dscr = lang .. " codeblock" }, {
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
    ------------------------------------------------------------
    -- Markdown
    ------------------------------------------------------------
    local md_snippets = {}
    for _, lang in ipairs(languages) do
      table.insert(md_snippets, create_code_block_snippet(lang))
      table.insert(typst_snippets, create_code_block_snippet(lang))
    end
    ls.add_snippets("typst", typst_snippets)

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
