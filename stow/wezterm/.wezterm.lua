local wezterm = require('wezterm')
local dotfile_dir = string.format("%s/dotfiles", os.getenv("HOME"))
local config = wezterm.config_builder()

-- [config options](https://wezfurlong.org/wezterm/config/lua/config/index.html)
local sapphire = "#209fb5"
local oledppuccin = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
oledppuccin.background = "#000000"
oledppuccin.tab_bar.background = "#040404"
oledppuccin.tab_bar.inactive_tab.bg_color = "#0f0f0f"
oledppuccin.tab_bar.new_tab.bg_color = "#080808"

config.color_schemes = {
    ["OLEDppuccin"] = oledppuccin,
}
config.color_scheme = "OLEDppuccin"
config.window_background_opacity = 0.2
config.macos_window_background_blur = 90
config.font = wezterm.font_with_fallback {
    { family = 'Maple Mono', weight = 'Bold' },
    { family = 'Hack Nerd Font Mono', weight = 'Bold' },
    'SF Mono Powerline',
}
config.font_size = 14.0
config.line_height = 1.2

-- hopefully this fixes key presses
config.use_ime = false

-- disables titlebar and borders
config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"
-- disable tab bar
config.hide_tab_bar_if_only_one_tab = true
-- customize frame
config.window_frame = {
    -- must be double to be even width, height
    border_left_width = '0.4cell',
    border_right_width = '0.4cell',
    border_bottom_height = '0.2cell',
    border_top_height = '0.2cell',
    border_left_color = sapphire,
    border_right_color = sapphire,
    border_bottom_color = sapphire,
    border_top_color = sapphire,
}

local dimmer = { brightness = 0.15 }
config.background = {
    {
        source = {
             File = string.format("%s/assets/term_wallpaper_1.jpg", dotfile_dir),
        },
        hsb = dimmer,
        repeat_x = 'Mirror',
        vertical_align = 'Middle',
        horizontal_align = 'Center',
        opacity = 0.9,
    }
}

return config
