local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

config = {
	check_for_updates = false,

	-- color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	color_scheme = "Catppuccin Mocha",
	-- color_scheme = "Catppuccin Macchiato"

	default_cursor_style = "BlinkingBar",
	automatically_reload_config = true,
	adjust_window_size_when_changing_font_size = false,
	font = wezterm.font("Hack Nerd Font"),
	font_size = 16,

	enable_tab_bar = false,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,

	window_decorations = "RESIZE",
	window_background_opacity = 0.80,
	window_close_confirmation = "NeverPrompt",
	macos_window_background_blur = 15,
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},

	-- from: https://akos.ma/blog/adopting-wezterm/
	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$1",
			highlight = 1,
		},
		-- Then handle URLs not wrapped in brackets
		{
			regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
			format = "$1",
			highlight = 1,
		},
		-- implicit mailto link
		{
			regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
			format = "mailto:$0",
		},
	},
}

return config
