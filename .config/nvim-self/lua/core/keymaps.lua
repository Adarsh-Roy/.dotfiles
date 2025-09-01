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

-- Search and character-find keys always operate in the same direction
vim.keymap.set("n", "n", "v:searchforward ? 'n' : 'N'", { expr = true })
vim.keymap.set("n", "N", "v:searchforward ? 'N' : 'n'", { expr = true })
vim.keymap.set({ "n", "v" }, ";", "getcharsearch().forward ? ',' : ';'", { expr = true })
vim.keymap.set({ "n", "v" }, "'", "getcharsearch().forward ? ';' : ','", { expr = true })

-- Move (line/selection) to {dest}, keep cursor/view here,
-- but record a jumplist entry so <C-o> jumps to the moved text.
local function move_and_record_jump(dest, is_visual)
	local view = vim.fn.winsaveview()

	-- 1) Do the move
	local ok, err
	if is_visual then
		vim.cmd("normal! gv")
		ok, err = pcall(vim.cmd, ("'<,'>move %s"):format(dest))
	else
		ok, err = pcall(vim.cmd, ("move %s"):format(dest))
	end
	if not ok then
		vim.notify("move error: " .. err, vim.log.levels.ERROR)
		return
	end

	-- 2) Create jumplist entries: jump to dest (`[), then jump back to original line (G)
	local prev_lazy = vim.go.lazyredraw
	vim.go.lazyredraw = true
	pcall(vim.cmd, "normal! `[")                     -- jump to start of last changed text (destination)
	pcall(vim.cmd, ("normal! %dG"):format(view.lnum)) -- jump back to original *line* (records a jump)
	vim.go.lazyredraw = prev_lazy

	-- 3) Restore exact column/scroll without affecting jumplist
	vim.fn.winrestview(view)
end
vim.keymap.set("n", "<leader>mm", function()
	local dest = vim.fn.input("Move line to (0,$,42,'a,/pat/): ")
	if dest ~= "" then move_and_record_jump(dest, false) end
end, { silent = true, desc = "Move line; keep cursor/view; <C-o> jumps to moved text" })
vim.keymap.set("x", "<leader>mm", function()
	local dest = vim.fn.input("Move selection to (0,$,42,'a,/pat/): ")
	if dest ~= "" then move_and_record_jump(dest, true) end
end, { silent = true, desc = "Move selection; keep cursor/view; <C-o> jumps to moved text" })
vim.keymap.set("n", "<leader>mt", function() move_and_record_jump("0", false) end,
	{ silent = true, desc = "Move line to TOP; keep cursor/view; <C-o> goes to it" })
vim.keymap.set("n", "<leader>mb", function() move_and_record_jump("$", false) end,
	{ silent = true, desc = "Move line to BOTTOM; keep cursor/view; <C-o> goes to it" })
vim.keymap.set("x", "<leader>mt", function() move_and_record_jump("0", true) end,
	{ silent = true, desc = "Move selection to TOP; keep cursor/view; <C-o> goes to it" })
vim.keymap.set("x", "<leader>mb", function() move_and_record_jump("$", true) end,
	{ silent = true, desc = "Move selection to BOTTOM; keep cursor/view; <C-o> goes to it" })

-- General
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>w ", "<cmd>qa<cr>", { desc = "Quit all" })
