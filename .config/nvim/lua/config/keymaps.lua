-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffer yank and select
vim.keymap.set("n", "<leader>by", "mq<cmd>%y<cr><cmd>delm q<cr>", { desc = "Yank Buffer" })
vim.keymap.set("n", "<leader>bv", "ggVG", { desc = "Yank Buffer" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
