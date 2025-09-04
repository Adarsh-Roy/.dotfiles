-- after/plugin/zuban.lua
if vim.fn.executable("zuban") ~= 1 then return end

-- Define/extend the config
vim.lsp.config("zuban", {
	cmd = { "zuban", "server" },
	filetypes = { "python" },
	root_markers = { ".git", "pyproject.toml", "setup.cfg", "mypy.ini", ".mypy.ini" },
})

-- Enable it (auto-attaches on matching filetypes + root markers)
vim.lsp.enable("zuban", true)
