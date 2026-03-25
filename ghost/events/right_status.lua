-- 右侧状态栏事件
-- 负责显示右侧状态栏，包括时间等信息
-- 使用 package.loaded 避免循环引用

local M = {}

--- 配置选项
---@class RightStatusOptions
---@field date_format string 时间格式，默认 '%a %H:%M:%S'
local default_opts = {
    date_format = "%a %H:%M:%S", -- 星期 时:分:秒
}

--- 当前配置
local opts = {}

--- 验证和合并选项
---@param user_opts table|nil 用户配置
local function setup_opts(user_opts)
    opts = {}
    for k, v in pairs(default_opts) do
        opts[k] = user_opts and user_opts[k] or v
    end
end

--- 注册事件到 wezterm
---@param user_opts table|nil 用户配置
function M.register(user_opts)
    local wezterm = package.loaded["wezterm"]
    if not wezterm then return end

    setup_opts(user_opts)

    wezterm.on("update-right-status", function(window, _pane)
        local time_text = wezterm.strftime(opts.date_format)

        window:set_right_status(wezterm.format({
            -- 使用与标签栏一致的颜色
            { Background = { Color = "#00aaff" } },
            { Foreground = { Color = "#9d00ff" } }, -- 紫色，与激活标签背景一致
            { Text = time_text },
        }))
    end)
end

return M
