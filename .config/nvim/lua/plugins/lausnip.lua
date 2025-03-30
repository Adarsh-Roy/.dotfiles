return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  opts = function(_, opts)
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local fmta = require("luasnip.extras.fmt").fmta

    -- Extend all snippet triggers with a semicolon prefix
    local extend_decorator = require("luasnip.util.extend_decorator")
    local function auto_semicolon(context)
      if type(context) == "string" then
        return { trig = ";" .. context }
      end
      return vim.tbl_extend("keep", { trig = ";" .. context.trig }, context)
    end
    extend_decorator.register(ls.s, {
      arg_indx = 1,
      extend = function(original)
        return auto_semicolon(original)
      end,
    })
    s = extend_decorator.apply(ls.s, {})

    ------------------------------------------------------------
    -- Competitive Programming Python Snippet (trigger: inpy)
    --
    -- Expands into a set of input methods:
    --   def read_int():
    --       return int(input())
    --
    --   def read_ints():
    --       return list(map(int, input().split()))
    --
    --   def read_str():
    --       return input().strip()
    --
    --   def read_strs():
    --       return input().split()
    ------------------------------------------------------------
    local cp_py_snippet = s(
      { trig = "inpy", dscr = "Python CP input methods" },
      fmta(
        [[
def <>( ):
    return int(input())

def <>( ):
    return list(map(int, input().split()))

def <>( ):
    return input().strip()

def <>( ):
    return input().split()
]],
        {
          i(1, "read_int"),
          i(2, "read_ints"),
          i(3, "read_str"),
          i(4, "read_strs"),
        },
        { delimiters = "<>" }
      )
    )

    ------------------------------------------------------------
    -- Markdown Code Block Snippets
    --
    -- For each common language, create a snippet that inserts a markdown
    -- code block with the language as the fence. For example, triggering
    -- "lua" will expand into:
    --
    -- ```lua
    -- <cursor here>
    -- ```
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

    -- Register the snippets for the respective filetypes
    ls.add_snippets("python", { cp_py_snippet })
    ls.add_snippets("markdown", md_snippets)

    return opts
  end,
}
