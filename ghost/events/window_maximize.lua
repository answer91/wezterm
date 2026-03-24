-- 窗口最大化事件
-- 启动时自动最大化窗口

local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

--- 注册事件到 wezterm
function M.register()
    wezterm.on("gui-startup", function(cmd)
       local _, _, window = mux.spawn_window(cmd or {})
       window:gui_window():maximize()
    end)
end

return M
