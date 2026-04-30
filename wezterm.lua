-- wezterm.lua
local wezterm = require 'wezterm' ---@type Wezterm
local config = wezterm.config_builder() ---@type Config
local mux = wezterm.mux ---@type Mux

-- 内置主题配置
-- Zenburn (Gogh)
-- Catppuccin Mocha (Gogh)
config.color_scheme = "zenburned"
config.default_prog = { "/usr/bin/fish" }

-- 插件搜索路径
package.path = wezterm.config_dir .. "/constants/?.lua;" .. wezterm.config_dir .. "/artificial_plugins/?.lua;" .. wezterm.config_dir .. "/artificial_plugins/?/init.lua;" .. package.path

-- 加载本地插件
-- local bar = require("bar_init")
-- bar.apply_to_config(config)

local tabline = require("tabline_init")
tabline.setup({ options = { theme = "zenburned" } })
tabline.apply_to_config(config)
config.tab_bar_at_bottom = true
config.status_update_interval = 500

-- 快捷键绑定
local keybindings = loadfile(wezterm.config_dir .. "/constants/keybindings.lua")()
local leader = keybindings.get_leader()
config.leader = leader
config.keys = keybindings.get_defaults()
config.key_tables = keybindings.get_key_tables()
config.mouse_bindings = keybindings.get_mouse_bindings()

-- 最大化窗口
wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)


return config
