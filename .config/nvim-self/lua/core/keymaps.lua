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

-- Insert mode navigation for slight movements
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- Move (line/selection) to {dest}, keep cursor/view here,
-- and record a jumplist entry so <C-o> jumps to the moved text.
local function move_and_record_jump(dest, is_visual)
	local view = vim.fn.winsaveview()
	local ok, err
	if is_visual then
		-- 1) Capture the selected *line* range while still in Visual
		local vpos = vim.fn.getpos("v")
		local cpos = vim.fn.getpos(".")
		local s = math.min(vpos[2], cpos[2])
		local e = math.max(vpos[2], cpos[2])
		-- 2) Exit Visual with real input so the highlight is definitely cleared
		local ESC = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.api.nvim_feedkeys(ESC, "nx", false)
		vim.cmd("redraw") -- ensure the UI refreshes and drops the selection highlight
		-- 3) Move that numeric range
		ok, err = pcall(vim.cmd, ("%d,%dmove %s"):format(s, e, dest))
	else
		ok, err = pcall(vim.cmd, ("move %s"):format(dest))
	end
	if not ok then
		vim.notify("move error: " .. err, vim.log.levels.ERROR)
		return
	end
	-- 4) Create jumplist entries: jump to dest (`[), then back to original line
	local prev_lazy = vim.go.lazyredraw
	vim.go.lazyredraw = true
	pcall(vim.cmd, "normal! `[")                     -- start of changed text (destination)
	pcall(vim.cmd, ("normal! %dG"):format(view.lnum)) -- back to original line (records a jump)
	vim.go.lazyredraw = prev_lazy
	-- 5) Restore exact column/scroll (doesn't touch the jumplist)
	vim.fn.winrestview(view)
end
-- <leader>mm → prompt; <leader>mt → top (0); <leader>mb → bottom ($)
vim.keymap.set("n", "<leader>mm", function()
	local dest = vim.fn.input("Move line to (0,$,42,'a,/pat/): ")
	if dest ~= "" then move_and_record_jump(dest, false) end
end, { silent = true, desc = "Move line" })
vim.keymap.set("x", "<leader>mm", function()
	local dest = vim.fn.input("Move selected line to (0,$,42,'a,/pat/): ")
	if dest ~= "" then move_and_record_jump(dest, true) end
end, { silent = true, desc = "Move selected line" })
vim.keymap.set("n", "<leader>mt", function() move_and_record_jump("0", false) end,
	{ silent = true, desc = "Move line to TOP" })
vim.keymap.set("n", "<leader>mb", function() move_and_record_jump("$", false) end,
	{ silent = true, desc = "Move line to BOTTOM" })
vim.keymap.set("x", "<leader>mt", function() move_and_record_jump("0", true) end,
	{ silent = true, desc = "Move selected line to TOP" })
vim.keymap.set("x", "<leader>mb", function() move_and_record_jump("$", true) end,
	{ silent = true, desc = "Move selected line to BOTTOM" })



-- General
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>w ", "<cmd>qa<cr>", { desc = "Quit all" })
