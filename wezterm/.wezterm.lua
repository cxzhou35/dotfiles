-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

-- config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font("Hack Nerd Font")
config.font_size = 16

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 15

return config
