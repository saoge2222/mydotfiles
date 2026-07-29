local wezterm = require "wezterm"
local config = {}

config.color_scheme = 'Gruvbox Dark (Gogh)'
config.font = wezterm.font 'JetBrainsMono NF'
config.font_size = 13
config.harfbuzz_features = { 'calt=1', 'liga=1', 'clig=1' }
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "BlinkingBar"
config.default_prog = { 'wsl.exe', '-d', 'archlinux' }
config.background = {
    {
        source = { Color = "#282828"},
        width = "100%", height = "100%", opacity = 1,
    },
}

return config
