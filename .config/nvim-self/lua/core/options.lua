vim.o.relativenumber = true
vim.opt.splitright = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = "unnamedplus"
vim.o.textwidth = 80
vim.o.colorcolumn = "+1"
vim.o.shiftwidth = 4
vim.o.cursorline = true
vim.o.cursorlineopt = "number"


-- Fold
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true


-- Icons per severity
local diag_icons = {
	[vim.diagnostic.severity.ERROR] = "",
	[vim.diagnostic.severity.WARN]  = "",
	[vim.diagnostic.severity.INFO]  = "",
	[vim.diagnostic.severity.HINT]  = "",
}

vim.diagnostic.config({
	signs = {
		text = diag_icons,
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
		},
	},
	virtual_text = { prefix = "●", spacing = 2 },
	underline = true,
	update_in_insert = false,
})

-- Persistent Undo
local undo_dir = vim.fn.stdpath('data') .. '/undo'

if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, 'p')
end

vim.opt.undodir = undo_dir
vim.opt.undofile = true
