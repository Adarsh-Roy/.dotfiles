-- after/plugin/ty.lua
if vim.fn.executable("ty") ~= 1 then return end

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	settings = {
		ty = {
			diagnosticMode = "openFilesOnly",
			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
			},
			experimental = { rename = false }, -- <- enables rename
		},
	},
	init_options = {
		logLevel = "info",
	},
})

-- enable
vim.lsp.enable("ty", true)
