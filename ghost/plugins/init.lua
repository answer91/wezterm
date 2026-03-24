-- 插件管理器
-- 提供插件加载、配置、管理功能

local wezterm = require("wezterm")
local core = require("ghost.core.init")
local utils = require("ghost.core.utils")

local M = {
    --- 已加载的插件
    loaded_plugins = {},

    --- 插件配置
    plugin_configs = {},

    --- 插件目录
    plugin_dir = wezterm.config_dir .. "/lua/plugins",
}

--- 插件Hook管理器
local PluginHookManager = {
    --- Hook注册表
    hooks = {},

    --- 注册Hook
    --- @param hook_name string Hook名称
    --- @param callback function 回调函数
    register = function(self, hook_name, callback)
        if not self.hooks[hook_name] then
            self.hooks[hook_name] = {}
        end
        table.insert(self.hooks[hook_name], callback)
    end,

    --- 触发Hook
    --- @param hook_name string Hook名称
    --- @param ... any 参数
    trigger = function(self, hook_name, ...)
        local hooks = self.hooks[hook_name]
        if not hooks then
            return
        end

        for _, callback in ipairs(hooks) do
            local success, err = pcall(callback, ...)
            if not success then
                wezterm.log_error("Hook error in " .. hook_name .. ": " .. tostring(err))
            end
        end
    end,
}

--- 加载插件
--- @param plugin_name string 插件名称
--- @param config table|nil 插件配置
--- @return boolean 是否成功
function M.load(plugin_name, config)
    -- 检查是否已加载
    if M.loaded_plugins[plugin_name] then
        wezterm.log_warn("Plugin already loaded: " .. plugin_name)
        return false
    end

    -- 保存配置
    if config then
        M.plugin_configs[plugin_name] = config
    end

    -- 尝试加载插件
    local success, plugin = pcall(require, "lua.plugins.examples." .. plugin_name)
    if not success then
        wezterm.log_error("Failed to load plugin: " .. plugin_name)
        wezterm.log_error(plugin)
        return false
    end

    -- 调用插件的setup函数
    if plugin.setup then
        local setup_success, err = pcall(plugin.setup, config or {})
        if not setup_success then
            wezterm.log_error("Plugin setup failed: " .. plugin_name)
            wezterm.log_error(err)
            return false
        end
    end

    -- 注册插件的Hooks
    if plugin.hooks then
        for hook_name, callback in pairs(plugin.hooks) do
            PluginHookManager:register(hook_name, callback)
        end
    end

    -- 标记为已加载
    M.loaded_plugins[plugin_name] = plugin
    wezterm.log_info("Plugin loaded: " .. plugin_name)

    return true
end

--- 卸载插件
--- @param plugin_name string 插件名称
--- @return boolean 是否成功
function M.unload(plugin_name)
    if not M.loaded_plugins[plugin_name] then
        wezterm.log_warn("Plugin not loaded: " .. plugin_name)
        return false
    end

    -- 调用插件的cleanup函数
    local plugin = M.loaded_plugins[plugin_name]
    if plugin.cleanup then
        local success, err = pcall(plugin.cleanup)
        if not success then
            wezterm.log_error("Plugin cleanup failed: " .. plugin_name)
            wezterm.log_error(err)
        end
    end

    -- 移除插件
    M.loaded_plugins[plugin_name] = nil
    M.plugin_configs[plugin_name] = nil

    wezterm.log_info("Plugin unloaded: " .. plugin_name)
    return true
end

--- 重新加载插件
--- @param plugin_name string 插件名称
--- @return boolean 是否成功
function M.reload(plugin_name)
    local config = M.plugin_configs[plugin_name]
    M.unload(plugin_name)
    return M.load(plugin_name, config)
end

--- 获取插件信息
--- @param plugin_name string 插件名称
--- @return table|nil 插件信息
function M.get_plugin_info(plugin_name)
    local plugin = M.loaded_plugins[plugin_name]
    if not plugin then
        return nil
    end

    return {
        name = plugin.name or plugin_name,
        version = plugin.version or "unknown",
        description = plugin.description or "",
        author = plugin.author or "unknown",
    }
end

--- 列出所有已加载的插件
--- @return table 插件列表
function M.list_loaded_plugins()
    local plugins = {}
    for name, plugin in pairs(M.loaded_plugins) do
        table.insert(plugins, {
            name = name,
            info = M.get_plugin_info(name),
        })
    end
    return plugins
end

--- 触发Hook
--- @param hook_name string Hook名称
--- @param ... any 参数
function M.trigger_hook(hook_name, ...)
    PluginHookManager:trigger(hook_name, ...)
end

--- 从本地路径安装插件
--- @param plugin_path string 插件路径
--- @param plugin_name string 插件名称
--- @return boolean 是否成功
function M.install_from_path(plugin_path, plugin_name)
    -- 这是一个简化实现
    -- 实际实现需要文件复制、依赖检查等

    wezterm.log_info("Installing plugin from: " .. plugin_path)

    -- 检查路径是否存在
    if not utils.file_exists(plugin_path) then
        wezterm.log_error("Plugin path not found: " .. plugin_path)
        return false
    end

    -- TODO: 实现插件安装逻辑
    wezterm.log_info("Plugin installation not fully implemented yet")

    return false
end

--- 从Git仓库安装插件
--- @param repo_url string Git仓库URL
--- @param plugin_name string 插件名称
--- @return boolean 是否成功
function M.install_from_git(repo_url, plugin_name)
    -- 这是一个简化实现
    -- 实际实现需要git clone、依赖检查等

    wezterm.log_info("Installing plugin from git: " .. repo_url)

    -- TODO: 实现Git插件安装逻辑
    wezterm.log_info("Git plugin installation not fully implemented yet")

    return false
end

--- 扫描插件目录
--- @return table 可用插件列表
function M.scan_available_plugins()
    local plugins = {}

    -- 扫描examples目录
    local examples_dir = M.plugin_dir .. "/examples"
    local cmd = "ls '" .. examples_dir .. "' 2>/dev/null"

    local f = io.popen(cmd)
    if f then
        local output = f:read("*a")
        f:close()

        for filename in output:gmatch("[^\r\n]+") do
            if filename:match("%.lua$") then
                local plugin_name = filename:gsub("%.lua$", "")
                table.insert(plugins, plugin_name)
            end
        end
    end

    return plugins
end

--- 创建新插件模板
--- @param plugin_name string 插件名称
--- @return boolean 是否成功
function M.create_plugin_template(plugin_name)
    local template = string.format([=[
-- %s
-- 插件描述

local M = {}

--- 插件信息
M.name = "%s"
M.version = "0.1.0"
M.description = "Plugin description"
M.author = "Your Name"

--- 插件设置函数
--- @param config table 配置表
function M.setup(config)
    -- 在这里初始化插件
    wezterm.log_info("Plugin %s setup with config:")
    wezterm.log_info(wezterm.json_encode(config or {}))
end

--- 插件清理函数
function M.cleanup()
    -- 在这里清理插件资源
    wezterm.log_info("Plugin %s cleanup")
end

--- 插件Hooks
M.hooks = {
    -- 例如：
    -- on_config_load = function(config)
    --     wezterm.log_info("Config loaded")
    -- end,
}

return M
]=], plugin_name, plugin_name, plugin_name, plugin_name)

    local plugin_path = M.plugin_dir .. "/examples/" .. plugin_name .. ".lua"
    local file = io.open(plugin_path, "w")
    if file then
        file:write(template)
        file:close()
        wezterm.log_info("Plugin template created: " .. plugin_path)
        return true
    end

    return false
end

return M
