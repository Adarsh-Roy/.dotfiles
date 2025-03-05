-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>bl", "<cmd>cd %:p:h<CR>", { desc = "Change to [B]uffer [L]ocation" })
vim.keymap.set("n", "<leader>by", "mq<cmd>%y<cr>'q<cmd>delm q<cr>", { desc = "[B]uffer [Y]ank" })
vim.keymap.set("n", "<leader>bv", "ggVG", { desc = "[B]uffer [V]isual" })

-- Navigation keymaps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>iq", vim.diagnostic.setloclist, { desc = "Open [I]ssues [Q]uickfix list" })
vim.keymap.set(
	"n",
	"<leader>if",
	"<cmd> lua vim.diagnostic.open_float()<CR>",
	{ desc = "Open [I]ssue in [F]loating window" }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window Keymaps
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>-", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>+", "<C-w>+", { desc = "Increase window height" })
vim.keymap.set("n", "<leader><", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>>", "<C-w>>", { desc = "Increase window width" })

-- Open the current line in pycharm
vim.keymap.set("n", "<leader>op", function()
	local path = vim.api.nvim_buf_get_name(0)
	local row = unpack(vim.api.nvim_win_get_cursor(0))
	local command = ("pycharm --line " .. row .. " " .. path)
	print(command)
	os.execute(command)
end, { desc = "[O]pen line in [P]yCharm" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Quickfix list
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<M-c>", "<cmd>cclose<CR>")
vim.keymap.set("n", "<M-o>", "<cmd>copen<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("resize 15") -- Adjust the height (15 lines, you can change this)
	end,
})
-- vim: ts=2 sts=2 sw=2 et
