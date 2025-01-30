return {
	{
		"saghen/blink.cmp",
		lazy = false,
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "v0.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
			signature = { enabled = true },
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
