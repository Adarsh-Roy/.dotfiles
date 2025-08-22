local function visual_metrics()
	if not vim.fn.mode(1):find("[vV\022]") then
		return ""
	end
	local s, e  = vim.fn.getpos("v"), vim.fn.getpos(".")
	local lines = math.abs(e[2] - s[2]) + 1

	local wc    = vim.fn.wordcount()
	local words = vim.fn.get(wc, "visual_words", 0)
	local chars = vim.fn.get(wc, "visual_chars", 0)

	return string.format("%dL %dW %dC", lines, words, chars)
end

return {
	'echasnovski/mini.nvim',
	version = '*',
	config = function()
		local icons = require("mini.icons")
		icons.setup()
		icons.mock_nvim_web_devicons()
		local session = require("mini.sessions")
		session.setup({
			directory = vim.fn.stdpath("data") .. "/global_sessions",
		})

		vim.keymap.set("n", "<leader>Sl", function()
			local local_file = (session.config.file ~= "" and session.config.file) or "Session.vim"
			local uv = vim.uv or vim.loop
			local cwd = uv.cwd()
			local path = cwd .. "/" .. local_file
			-- if no local session exists yet, create it once
			if not uv.fs_stat(path) then
				vim.cmd("silent! mksession! " .. vim.fn.fnameescape(local_file))
			end
			-- ensure the local session is active, then write
			session.read(nil, { force = false, verbose = false })
			session.write(nil)
		end, { desc = "Save Session (local)" })

		vim.keymap.set("n", "<leader>Sa", function()
			vim.ui.input({ prompt = "Session name: " }, function(name)
				if name and #name > 0 then
					session.write(name) -- writes to `directory`
				end
			end)
		end, { desc = "Save Session As…" })

		require("mini.tabline").setup()
		require("mini.ai").setup({
			n_lines = 200
		})
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.operators").setup({
			exchange = {
				prefix = 'ge'
			},
			replace = {
				prefix = '<leader>r'
			},
			sort = {
				prefix = 'gS'
			}
		})
		require("mini.surround").setup({
			mappings = {
				add = 'gsa',
				delete = 'gsd',
				replace = 'gsr',
				find = 'gsf',
				find_left = 'gsF',
				highlight = 'gsh',
				update_n_lines = 'gsn',
				suffix_last = 'l',
				suff_next = 'n',
			}
		})
		require("mini.statusline").setup({
			use_icons = true,
			content = {
				active = function()
					local mode = MiniStatusline.section_mode({ trunc_width = math.huge })

					-- Build git segment from gitsigns' buffer dict
					local function git_segment()
						local g = vim.b.gitsigns_status_dict
						if not g or not g.head then
							-- fallback: just branch (from gitsigns_head or git)
							local head = vim.b.gitsigns_head
							if not head or head == "" then
								local cwd = vim.fn.fnameescape(vim.fn.expand("%:p:h"))
								head = (vim.fn.systemlist("git -C " .. cwd .. " rev-parse --abbrev-ref HEAD")[1] or "")
							end
							return (head and head ~= "") and (" " .. head) or ""
						end

						-- Format counts if present
						local parts   = { " " .. g.head }
						local added   = tonumber(g.added) or 0
						local changed = tonumber(g.changed) or 0
						local removed = tonumber(g.removed) or 0
						if added > 0 or changed > 0 or removed > 0 then
							local diffs = {}
							if added > 0 then table.insert(diffs, "+" .. added) end
							if changed > 0 then table.insert(diffs, "~" .. changed) end
							if removed > 0 then table.insert(diffs, "-" .. removed) end
							table.insert(parts, table.concat(diffs, " "))
						end
						return table.concat(parts, " ")
					end

					local filename = MiniStatusline.section_filename({ trunc_width = 200 })
					local metrics  = visual_metrics()

					local groups   = {
						{ hl = "MiniStatuslineModeNormal", strings = { mode } },
						{ hl = "MiniStatuslineDevinfo",    strings = { git_segment() } },
						{ strings = { "%<" } },
						{ hl = "MiniStatuslineFilename",   strings = { filename } },

						-- right side split + ensure filler uses default hl
						{ strings = { "%#StatusLine#" } },
						{ strings = { "%=" } },
					}

					if metrics ~= "" then
						table.insert(groups, {
							strings = { "%#MiniStatuslineFileinfo# " .. metrics .. " %#StatusLine#" },
						})
					end
					return MiniStatusline.combine_groups(groups)
				end,

				inactive = function()
					local name = vim.api.nvim_buf_get_name(0)
					local tail = (name == "" and "[No Name]") or vim.fn.fnamemodify(name, ":t")
					return MiniStatusline.combine_groups({
						{ hl = "MiniStatuslineInactive", strings = { tail } },
					})
				end,
			},
		})
	end
}
