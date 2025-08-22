-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Buffer yank and select
vim.keymap.set("n", "<leader>by", "mq<cmd>%y<cr><cmd>delm q<cr>", { desc = "Buffer Yank " })
vim.keymap.set("n", "<leader>bv", "goVG", { desc = "Buffer Visual" })
vim.keymap.set("n", "<leader>br", "goVGP", { desc = "Buffer Replace" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Replace a word with content in clipboard, without overwriting clipboard.
vim.keymap.set("n", "<leader>rw", "viwP", { desc = "Replace Word" })

-- Block insert in line visual mode
vim.keymap.set("x", "I", function()
  return vim.fn.mode() == "V" and "^<C-v>I" or "I"
end, { expr = true })
vim.keymap.set("x", "A", function()
  return vim.fn.mode() == "V" and "$<C-v>A" or "A"
end, { expr = true })

-- Exit terminal mode with Esc twice
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
