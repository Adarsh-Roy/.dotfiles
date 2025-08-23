return {
	-- LuaSnip + your snippets
	{
		"L3MON4D3/LuaSnip",
		build = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and nil or "make install_jsregexp",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					-- load VSCode-style snippets from friendly-snippets and your local folder
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
			enable_autosnippets = true,
		},
		config = function(_, opts)
			local ls = require("luasnip")
			ls.setup(opts)

			local s   = ls.snippet
			local t   = ls.text_node
			local i   = ls.insert_node
			local c   = ls.choice_node
			local f   = ls.function_node
			local fmt = require("luasnip.extras.fmt").fmt

			------------------------------------------------------------------
			-- Keymaps
			------------------------------------------------------------------
			-- cycle choices in choice nodes
			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				elseif ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { desc = "Expand or Next Choice" })

			-- keep snippet jumping smooth in select-mode (blink handles <Tab> in insert mode)
			vim.keymap.set("s", "<Tab>", function() if ls.jumpable(1) then ls.jump(1) end end, { silent = true })
			vim.keymap.set("s", "<S-Tab>", function() if ls.jumpable(-1) then ls.jump(-1) end end, { silent = true })

			------------------------------------------------------------------
			-- Helpers
			------------------------------------------------------------------
			local function clipboard() return vim.fn.getreg("+") end

			------------------------------------------------------------------
			-- Python snippets
			------------------------------------------------------------------
			local python_snippets = {
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
				),
				s(
					{ trig = "telr", dscr = "Try/Except block with optional logging/raising" },
					fmt(
						[[
try:
    {}
except Exception as e:
    {}
]],
						{
							i(2),
							c(1, {
								t('LOG.error(f"Error msg: {e}")'),
								t("raise e"),
								t({ 'LOG.error(f"Error msg: {e}")', "    raise e" }),
							}),
						}
					)
				),
				s(
					{ trig = "deprdoc", dscr = "Deprecate a function with docstring" },
					fmt(
						[[
"""
DEPRECATED: {}
"""
]],
						{ i(0) }
					)
				),
				s(
					{ trig = "doc", dscr = "Add a function docstring" },
					fmt(
						[[
"""
{}

Args:

Returns:
"""
]],
						{ i(0) }
					)
				),
			}
			ls.add_snippets("python", python_snippets)

			------------------------------------------------------------------
			-- Typst snippets
			------------------------------------------------------------------
			local typst_snippets = {
				s({ trig = "mt", dscr = "Math inline shortcut", snippetType = "autosnippet" }, { t("$"), i(1), t("$") }),
				s({ trig = "mmt", dscr = "Math multiline block", snippetType = "autosnippet" },
					{ t({ "$", "" }), i(1), t({ "", "$" }) }),
			}

			------------------------------------------------------------------
			-- Shared code block snippets (Typst + Markdown)
			------------------------------------------------------------------
			local function create_code_block_snippet(lang)
				return s({ trig = lang, name = "Codeblock", dscr = lang .. " codeblock" }, {
					t({ "```" .. lang, "" }),
					i(1),
					t({ "", "```" }),
				})
			end

			local languages = {
				"txt", "lua", "sql", "go", "regex", "bash", "markdown", "markdown_inline",
				"yaml", "json", "jsonc", "cpp", "csv", "java", "javascript", "python",
				"dockerfile", "html", "css", "templ", "php",
			}

			local md_snippets = {}
			for _, lang in ipairs(languages) do
				table.insert(md_snippets, create_code_block_snippet(lang))
				table.insert(typst_snippets, create_code_block_snippet(lang))
			end
			ls.add_snippets("typst", typst_snippets)

			table.insert(md_snippets,
				s({ trig = "linkc", dscr = "Add clipboard link" }, { t("["), i(1), t("]("), f(clipboard, {}), t(")") })
			)
			ls.add_snippets("markdown", md_snippets)
		end,
	},

	-- blink.cmp integration
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			-- use LuaSnip as the snippet engine
			snippets = { preset = "luasnip" }, -- ensures expand/active/jump are wired to LuaSnip
		},
	},
}
