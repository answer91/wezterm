-- Smart Move Plugin
-- 提供Vim风格的光标移动功能

local wezterm = require("wezterm")

local M = {
    name = "smart_move",
    version = "1.0.0",
    description = "Vim-style smart cursor movement",
    author = "Wezterm Config",
}

--- 模式状态
local modes = {
    NORMAL = "normal",
    INSERT = "insert",
    VISUAL = "visual",
    REPLACE = "replace",
}

local current_mode = modes.INSERT
local mode_indicator = {
    [modes.NORMAL] = "NORMAL",
    [modes.INSERT] = "INSERT",
    [modes.VISUAL] = "VISUAL",
    [modes.REPLACE] = "REPLACE",
}

--- 插件配置
local config = {
    --- 是否启用模式提示
    show_mode_indicator = true,

    --- 默认模式
    default_mode = modes.INSERT,

    --- 模式切换快捷键
    mode_switch_keys = {
        to_normal = "Escape",
        to_insert = "i",
        to_visual = "v",
    },
}

--- 进入普通模式
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
local function enter_normal_mode(window, pane)
    current_mode = modes.NORMAL
    wezterm.log_info("Entered NORMAL mode")
end

--- 进入插入模式
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
local function enter_insert_mode(window, pane)
    current_mode = modes.INSERT
    wezterm.log_info("Entered INSERT mode")
end

--- 进入可视模式
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
local function enter_visual_mode(window, pane)
    current_mode = modes.VISUAL
    wezterm.log_info("Entered VISUAL mode")
end

--- 移动光标
--- @param direction string 方向 (h, j, k, l)
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
local function move_cursor(direction, window, pane)
    if current_mode == modes.NORMAL then
        -- 在普通模式下，发送ESC + 方向键模拟Vim移动
        local key_map = {
            h = "Left",
            j = "Down",
            k = "Up",
            l = "Right",
        }

        local key = key_map[direction]
        if key then
            pane:send_text("\x1b")  -- ESC
            wezterm.sleep_ms(10)
            window:perform_action(
                wezterm.action.SendKey({ key = key }),
                pane
            )
        end
    end
end

--- 删除操作
--- @param count number 删除字符数
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
local function delete_chars(count, window, pane)
    if current_mode == modes.NORMAL or current_mode == modes.VISUAL then
        pane:send_text(string.rep("\x7f", count or 1))  -- Backspace
    end
end

--- 插件设置函数
--- @param user_config table 用户配置
function M.setup(user_config)
    -- 合并配置
    if user_config then
        for k, v in pairs(user_config) do
            config[k] = v
        end
    end

    wezterm.log_info("Smart Move plugin loaded")
    wezterm.log_info("Mode indicator: " .. tostring(config.show_mode_indicator))
end

--- 获取当前模式
--- @return string 当前模式
function M.get_current_mode()
    return current_mode
end

--- 获取模式指示器
--- @return string 模式指示器文本
function M.get_mode_indicator()
    if config.show_mode_indicator then
        return mode_indicator[current_mode] or "UNKNOWN"
    end
    return ""
end

--- 创建快捷键绑定
--- @return table 快捷键列表
function M.create_keybindings()
    local keys = {}

    -- 模式切换
    table.insert(keys, {
        key = config.mode_switch_keys.to_normal,
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            enter_normal_mode(window, pane)
        end),
    })

    -- 移动快捷键（在普通模式下）
    local move_keys = { "h", "j", "k", "l" }
    for _, key in ipairs(move_keys) do
        table.insert(keys, {
            key = key,
            mods = "LEADER",
            action = wezterm.action_callback(function(window, pane)
                move_cursor(key, window, pane)
            end),
        })
    end

    -- 删除快捷键
    table.insert(keys, {
        key = "x",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            delete_chars(1, window, pane)
        end),
    })

    return keys
end

--- 插件清理函数
function M.cleanup()
    current_mode = config.default_mode
    wezterm.log_info("Smart Move plugin cleaned up")
end

--- 插件Hooks
M.hooks = {
    --- 配置加载时
    on_config_load = function(config)
        wezterm.log_info("Smart Move: config loaded")
    end,

    --- 窗口创建时
    on_window_create = function(window, pane)
        wezterm.log_info("Smart Move: window created")
        current_mode = config.default_mode
    end,
}

return M
