local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.83
config.macos_window_background_blur = 13

-- Colors matching your scheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#A277FF", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#A277FF", "#24EAF7", "#24EAF7" },

	tab_bar = {
		background = "#011423",
		active_tab = {
			bg_color = "#033259",
			fg_color = "#CBE0F0",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#011423",
			fg_color = "#666666",
		},
		inactive_tab_hover = {
			bg_color = "#022233",
			fg_color = "#CBE0F0",
			italic = true,
		},
	},
}

-- Enable tab bar at the bottom and zero-based indexing
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- Keys
config.keys = {}

if wezterm.target_triple:find("apple%-darwin") then
	local function swap_modifiers(modifier, replacement)
		local keys = {}

		-- Numbers (0-9)
		for i = 0, 9 do
			local k = tostring(i)
			table.insert(keys, {
				key = k,
				mods = modifier,
				action = wezterm.action.SendKey({ key = k, mods = replacement }),
			})
		end

		-- Uppercase letters (A-Z)
		for i = 65, 90 do
			local char = string.char(i)
			table.insert(keys, {
				key = char,
				mods = modifier,
				action = wezterm.action.SendKey({ key = char, mods = replacement }),
			})
		end

		-- Lowercase letters (a-z)
		for i = 97, 122 do
			local char = string.char(i)
			table.insert(keys, {
				key = char,
				mods = modifier,
				action = wezterm.action.SendKey({ key = char, mods = replacement }),
			})
		end

		-- Symbols
		for _, symbol in ipairs({ ",", ".", "/", "-", "=", "[", "]", ";", "'", "\\" }) do
			table.insert(keys, {
				key = symbol,
				mods = modifier,
				action = wezterm.action.SendKey({ key = symbol, mods = replacement }),
			})
		end

		return keys
	end

	local function add_modifier_swaps()
		local mappings = {}

		-- Cmd to Ctrl, excluding Cmd+Space
		for _, keymap in ipairs(swap_modifiers("CMD", "CTRL")) do
			if keymap.key ~= " " then
				table.insert(mappings, keymap)
			end
		end

		-- Cmd+Shift to Ctrl+Shift
		for _, keymap in ipairs(swap_modifiers("CMD|SHIFT", "CTRL|SHIFT")) do
			table.insert(mappings, keymap)
		end

		-- Cmd+Alt to Ctrl+Cmd
		for _, keymap in ipairs(swap_modifiers("CMD|ALT", "CTRL|CMD")) do
			table.insert(mappings, keymap)
		end
		return mappings
	end

	-- Apply mappings
	for _, mapping in ipairs(add_modifier_swaps()) do
		table.insert(config.keys, mapping)
	end
end

-- Leader key setup
if wezterm.target_triple:find("apple%-darwin") then
	config.leader = { key = "b", mods = "CMD", timeout_milliseconds = 2000 }
else
	config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }
end

local key_maps = {
	-- Tab Management
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "b", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },

	-- Pane Splitting
	{ key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Pane Navigation
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Pane Resizing
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- Swtich between workspaces
	{ key = "S", mods = "LEADER", action = wezterm.action.SwitchToWorkspace({ name = "df-services" }) },
	{ key = "C", mods = "LEADER", action = wezterm.action.SwitchToWorkspace({ name = "df-common" }) },
	{ key = "D", mods = "LEADER", action = wezterm.action.SwitchToWorkspace({ name = "default" }) },
	-- Rename Tab
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

for _, key_mapping in ipairs(key_maps) do
	table.insert(config.keys, key_mapping)
end

-- Number-based tab switching (Leader + 0-9)
for i = 0, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i),
	})
end

-- Quit app with Ctrl+Q on macOS
if wezterm.target_triple:find("apple%-darwin") then
	table.insert(config.keys, {
		key = "q",
		mods = "CTRL",
		action = wezterm.action.QuitApplication,
	})
end

-- Format tab titles dynamically (use tab_title if set, else pane title)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local tab_index = tab.tab_index
	local tab_title = tab.tab_title
	if not tab_title or tab_title == "" then
		tab_title = tab.active_pane.title
	end
	return string.format(" %d: %s ", tab_index, tab_title)
end)

-- Leader indicator in status line (as per original snippet)
wezterm.on("update-right-status", function(window, _)
	local WORKSPACE_NAME = window:active_workspace()
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#CBE0F0" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x26A1)
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#011423" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))

	window:set_right_status(wezterm.format({
		{ Background = { Color = "#033259" } },
		{ Foreground = { Color = "#CBE0F0" } },
		{ Text = WORKSPACE_NAME },
	}))
end)

config.max_fps = 120

wezterm.on("gui-startup", function()
	local mux = wezterm.mux

	-- Create "default" workspace
	local default_tab, default_pane, default_window = mux.spawn_window({ workspace = "default" })

	-- Create "df-services" workspace
	local services_tab, services_pane, services_window = mux.spawn_window({ workspace = "df-services" })
	services_tab:set_title("nvim")
	services_pane:send_text("open-df-services\n")

	local df_git_tab, df_git_pane, _ = services_window:spawn_tab({})
	df_git_tab:set_title("git")
	df_git_pane:send_text("cd ~/Desktop/Apps_Team_Code/df-services; lazygit\n")

	-- Create "df-common" workspace
	local common_tab, common_pane, common_window = mux.spawn_window({ workspace = "df-common" })
	common_tab:set_title("nvim")
	common_pane:send_text("open-df-common\n")

	local common_git_tab, common_git_pane, _ = common_window:spawn_tab({})
	common_git_tab:set_title("git")
	common_git_pane:send_text("c ~/Desktop/Apps_Team_Code/df-common; lazygit\n")

	mux.set_active_workspace("default")
end)

return config
