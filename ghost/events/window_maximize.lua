-- 窗口最大化事件
-- 启动时自动最大化窗口
-- 使用 package.loaded 避免循环引用

local M = {}

--- 注册事件到 wezterm
function M.register()
    local wezterm = package.loaded["wezterm"]
    if not wezterm then return end

    local mux = wezterm.mux
    wezterm.on("gui-startup", function(cmd)
       local _, _, window = mux.spawn_window(cmd or {})
       window:gui_window():maximize()
    end)
end

return M
