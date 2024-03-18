local wezterm = require('wezterm')

local config = wezterm.config_builder()

-- [config options](https://wezfurlong.org/wezterm/config/lua/config/index.html)
config.color_scheme = 'Material Palenight (base16)'
config.window_background_opacity = 0.69
config.macos_window_background_blur = 84
config.font = wezterm.font 'Hack Nerd Font Mono'
config.font_size = 14.0
config.line_height = 1.2

-- hopefully this fixes key presses
config.use_ime = false

-- disables titlebar and borders
config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"
-- disable tab bar
config.hide_tab_bar_if_only_one_tab = true

return config
