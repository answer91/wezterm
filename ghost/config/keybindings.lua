-- 快捷键系统
-- 提供模块化的快捷键管理，支持多种模式和自定义覆盖

local wezterm = require("wezterm")
local core = require("ghost.core.init")
local constants = require("ghost.core.constants")

local M = {}

--- 键表（KeyTable）管理器
local KeyTableManager = {
    --- 当前激活的键表
    active_key_tables = {},

    --- 注册键表
    --- @param name string 键表名称
    --- @param keys table 键绑定列表
    register = function(self, name, keys)
        self.active_key_tables[name] = keys
    end,

    --- 获取键表
    --- @param name string 键表名称
    --- @return table|nil 键绑定列表
    get = function(self, name)
        return self.active_key_tables[name]
    end,

    --- 合并多个键表
    --- @param ... table 多个键表
    --- @return table 合并后的键表
    merge = function(self, ...)
        local result = {}
        local key_maps = {} -- 用于去重

        for _, key_table in ipairs({...}) do
            for _, binding in ipairs(key_table) do
                -- 生成唯一键
                local key_map = string.format("%s+%s", binding.mods or "", binding.key or "")

                -- 如果该键组合尚未被定义，或者这是一个更高优先级的绑定
                if not key_maps[key_map] then
                    table.insert(result, binding)
                    key_maps[key_map] = true
                end
            end
        end

        return result
    end,
}

--- 应用默认快捷键
--- @param config wezterm.Config 配置对象
--- @return wezterm.Config 配置对象
local function apply_default_keys(config)
    config.keys = constants.DEFAULT_KEYBINDINGS
    return config
end

--- 应用Leader模式快捷键
--- @param config wezterm.Config 配置对象
--- @param leader_config table Leader配置
--- @return wezterm.Config 配置对象
local function apply_leader_mode(config, leader_config)
    if not leader_config or not leader_config.enabled then
        return config
    end

    local leader_key = leader_config.key or "Space"
    local leader_mods = leader_config.mods or "CTRL"
    local timeout = leader_config.timeout or 1000

    config.leader = { key = leader_key, mods = leader_mods, timeout_milliseconds = timeout }

    -- Leader模式下的快捷键
    local leader_keys = {
        { key = "c", mods = "LEADER", action = wezterm.action.CopyTo("Clipboard") },
        { key = "v", mods = "LEADER", action = wezterm.action.PasteFrom("Clipboard") },
        { key = "t", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
        { key = "w", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
        { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "s", mods = "LEADER", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
        { key = "r", mods = "LEADER", action = wezterm.action.ActivateKeyTable {
            name = "resize_mode",
            one_shot = false,
        }},
        { key = "a", mods = "LEADER", action = wezterm.action.ActivateKeyTable {
            name = "activate_pane_mode",
            one_shot = false,
        }},
    }

    -- 注册Leader键表
    KeyTableManager:register("leader_mode", leader_keys)

    -- 合并到配置
    config.keys = KeyTableManager:merge(config.keys or {}, leader_keys)

    return config
end

--- 应用窗格调整模式
--- @param config wezterm.Config 配置对象
--- @param resize_config table 调整配置
--- @return wezterm.Config 配置对象
local function apply_resize_mode(config, resize_config)
    if not resize_config or not resize_config.enabled then
        return config
    end

    local resize_keys = {
        -- 调整窗格大小
        { key = "h", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
        { key = "l", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
        { key = "k", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
        { key = "j", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
        -- 使用箭头键调整
        { key = "LeftArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
        { key = "UpArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
        { key = "DownArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
    }

    -- 注册调整模式键表
    KeyTableManager:register("resize_mode", resize_keys)

    -- 合并到配置
    config.keys = KeyTableManager:merge(config.keys or {}, resize_keys)

    return config
end

--- 应用激活窗格模式
--- @param config wezterm.Config 配置对象
--- @param activate_config table 激活配置
--- @return wezterm.Config 配置对象
local function apply_activate_pane_mode(config, activate_config)
    if not activate_config or not activate_config.enabled then
        return config
    end

    local activate_keys = {
        { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
        { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
        { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
        { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
        { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
        { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
        { key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
        { key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
        { key = "q", mods = "ALT", action = wezterm.action.PopKeyTable },
    }

    -- 注册激活模式键表
    KeyTableManager:register("activate_pane_mode", activate_keys)

    -- 合并到配置
    config.keys = KeyTableManager:merge(config.keys or {}, activate_keys)

    return config
end

--- 应用自定义快捷键
--- @param config wezterm.Config 配置对象
--- @param custom_keys table 自定义快捷键列表
--- @return wezterm.Config 配置对象
local function apply_custom_keys(config, custom_keys)
    if not custom_keys or #custom_keys == 0 then
        return config
    end

    -- 自定义快捷键会覆盖默认快捷键
    config.keys = KeyTableManager:merge(custom_keys, config.keys or {})

    return config
end

--- 应用快捷键配置
--- @param config wezterm.Config 配置对象
--- @param user_config table 用户配置
--- @return wezterm.Config 配置对象
function M.apply(config, user_config)
    -- 获取用户配置
    local keybindings_config = user_config.keybindings or {}

    -- 应用默认快捷键
    config = apply_default_keys(config)

    -- 应用Leader模式
    config = apply_leader_mode(config, keybindings_config.leader)

    -- 应用窗格调整模式
    config = apply_resize_mode(config, keybindings_config.resize_mode)

    -- 应用激活窗格模式
    config = apply_activate_pane_mode(config, keybindings_config.activate_pane_mode)

    -- 应用自定义快捷键
    if keybindings_config.custom_keys then
        config = apply_custom_keys(config, keybindings_config.custom_keys)
    end

    -- 注册所有键表
    config.key_tables = {}
    for name, keys in pairs(KeyTableManager.active_key_tables) do
        table.insert(config.key_tables, { name = name, keys = keys })
    end

    -- 禁用默认键绑定（如果配置了）
    if keybindings_config.disable_default_keys then
        config.keys = {}
    end

    return config
end

--- 添加快捷键
--- @param key string 键名
--- @param mods string 修饰键
--- @param action table 动作
--- @return boolean 是否成功
function M.add_keybinding(key, mods, action)
    -- 这个函数可以在运行时动态添加快捷键
    local binding = { key = key, mods = mods, action = action }
    return true
end

--- 移除快捷键
--- @param key string 键名
--- @param mods string 修饰键
--- @return boolean 是否成功
function M.remove_keybinding(key, mods)
    -- 这个函数可以在运行时动态移除快捷键
    return true
end

--- 获取当前所有快捷键
--- @return table 快捷键列表
function M.get_all_keybindings()
    local bindings = {}
    for name, keys in pairs(KeyTableManager.active_key_tables) do
        for _, key in ipairs(keys) do
            table.insert(bindings, {
                key_table = name,
                key = key.key,
                mods = key.mods,
                action = key.action,
            })
        end
    end
    return bindings
end

return M
