-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Call action
local act = wezterm.action

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.font = wezterm.font("Hack Nerd Font")
config.cell_width = 0.95
config.window_background_opacity = 0.95
config.prefer_egl = true

config.font_size = 13.5

config.default_cwd = "your\\default\\path"

config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 0,
}

--tabs
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

config.colors = {
	--background = "#0f0d12", -- dark purple
	--background = "#1d2026", -- dark purple
	background = "#0f0f0f", -- dark purple
}
config.window_decorations = "RESIZE"
--config.default_prog = { "cmd.exe", "/k" }
--config.default_prog = { "powershell.exe" }
config.initial_cols = 90
config.initial_rows = 30

-- keymaps
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "F11",
		mods = "NONE",
		action = act.ToggleFullScreen,
	},
	-- tmux
	{
		key = "l",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Left",
			size = { Percent = 50 },
		}),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Up",
			size = { Percent = 50 },
		}),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	-- Adjust pane size
	{
		key = "Y",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	-- Pane selection
	{ key = "s", mods = "LEADER", action = act.PaneSelect },
	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },

	{ key = "K", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.95
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
	--Switch Tabs
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivateTabRelative(1),
	},
	-- Scroll up and down
	{
		key = "UpArrow",
		mods = "CTRL",
		action = act.ScrollByLine(-4),
	},
	{
		key = "DownArrow",
		mods = "CTRL",
		action = act.ScrollByLine(4),
	},
}

-- Leader Key Status
wezterm.on("update-right-status", function(window, _)
	local MOON_FOREGROUND = { Foreground = { Color = "#f7d042" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x263E) -- Lua (☾)
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#000000" } },
		MOON_FOREGROUND,
		{ Text = prefix },
	}))
end)

--and finally, return the configuration to wezterm
return config
