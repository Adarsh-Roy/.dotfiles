vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Buffer
vim.keymap.set("n", "<leader>by", "mq<cmd>%y<cr><cmd>delm q<cr>", { desc = "Yank Buffer" })
vim.keymap.set("n", "<leader>bv", "ggVG", { desc = "Select Buffer" })
vim.keymap.set("n", "<leader>bnn", "<cmd>enew<cr>", { desc = "New Buffer" })
vim.keymap.set("n", "<leader>bnv", "<cmd>vnew<cr>", { desc = "New Buffer (Veritcal)" })
vim.keymap.set("n", "H", "<cmd>bprev<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Floating diagnostic window
vim.keymap.set("n", "<leader>xf", function()
	vim.diagnostic.open_float(nil, {
		scope = "line",
		border = "rounded",
		source = "if_many",
		focusable = true,
	})
end, { desc = "Trouble Float" })

-- Block insert in line visual mode
vim.keymap.set("x", "I", function()
	return vim.fn.mode() == "V" and "^<C-v>I" or "I"
end, { expr = true })
vim.keymap.set("x", "A", function()
	return vim.fn.mode() == "V" and "$<C-v>A" or "A"
end, { expr = true })


-- Navigation
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


-- General
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>w ", "<cmd>qa<cr>", { desc = "Quit all" })
