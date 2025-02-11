return {
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "v0.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				opts = { history = true, delete_check_events = "TextChanged" },
				config = function()
					-- 1. Load VSCode-style snippets from friendly-snippets
					require("luasnip.loaders.from_vscode").lazy_load()
					-- 2. Additionally load custom VSCode-style snippets (JSON) if any exist
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = vim.fn.stdpath("config") .. "/snippets",
					})
					-- 3. **ALSO** load custom Lua snippets from ~/.config/nvim/snippets
					require("luasnip.loaders.from_lua").load({
						paths = vim.fn.stdpath("config") .. "/snippets",
					})
				end,
			},
		},
		opts = {
			-- Your Blink CMP keymaps and settings remain unchanged
			keymap = {
				preset = "default",
				["<C-e>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-E>"] = { "select_prev", "snippet_backward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			signature = { enabled = true },
		},
	},
}
