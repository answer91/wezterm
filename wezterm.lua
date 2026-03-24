-- Wezterm配置主入口文件
-- 采用模块化架构，支持灵活配置

local wezterm = require("wezterm")
local core = require("ghost.core.init")
local utils = require("ghost.core.utils")
local constants = require("ghost.core.constants")

-- ============================================
-- 配置管理器
-- ============================================
local ConfigManager = {
    --- 当前配置
    config = {},

    --- 用户自定义配置
    user_config = {},

    --- 初始化配置
    --- @return wezterm.Config 配置对象
    init = function(self)
        -- 创建基础配置
        self.config = wezterm.config_builder()

        -- 应用默认配置
        self.config = core.merge_config(self.config, constants.DEFAULT_CONFIG)

        -- 加载用户配置（如果存在）
        self:load_user_config()

        -- 应用核心模块配置
        self:apply_core_config()

        -- 加载插件
        self:load_plugins()

        return self.config
    end,

    --- 加载用户自定义配置
    load_user_config = function(self)
        local user_config_path = utils.get_config_dir() .. "/user_config.lua"

        if utils.file_exists(user_config_path) then
            local success, user_config = pcall(dofile, user_config_path)
            if success and type(user_config) == "table" then
                self.user_config = user_config
                self.config = core.merge_config(self.config, user_config)
            else
                wezterm.log_error("Failed to load user config: " .. tostring(user_config))
            end
        end
    end,

    --- 应用核心配置模块
    apply_core_config = function(self)
        -- 外观配置
        local appearance = core.require("ghost.config.appearance")
        if appearance then
            self.config = core.merge_config(self.config, appearance.apply(self.config, self.user_config))
        end

        -- 快捷键配置
        local keybindings = core.require("ghost.config.keybindings")
        if keybindings then
            self.config = core.merge_config(self.config, keybindings.apply(self.config, self.user_config))
        end

        -- Shell集成
        local shell = core.require("ghost.config.shell")
        if shell then
            self.config = core.merge_config(self.config, shell.apply(self.config, self.user_config))
        end

        -- 性能优化
        local performance = core.require("ghost.config.performance")
        if performance then
            self.config = core.merge_config(self.config, performance.apply(self.config, self.user_config))
        end
    end,

    --- 加载插件
    load_plugins = function(self)
        local plugin_manager = core.require("ghost.plugins.init")
        if plugin_manager and self.user_config.plugins then
            for _, plugin_name in ipairs(self.user_config.plugins) do
                plugin_manager.load(plugin_name)
            end
        end
    end,
}

-- ============================================
-- 事件处理器
-- ============================================
local EventHandler = {
    --- 已加载的功能模块
    features = {},

    --- 初始化功能模块
    init = function(self)
        self:load_features()
    end,

    --- 加载功能特性
    load_features = function(self)
        -- 命令面板
        local launcher = core.require("ghost.features.launcher")
        if launcher then
            self.features.launcher = launcher
        end

        -- 状态栏
        local statusbar = core.require("ghost.features.statusbar")
        if statusbar then
            self.features.statusbar = statusbar
        end

        -- 布局管理
        local layout = core.require("ghost.features.layout")
        if layout then
            self.features.layout = layout
        end

        -- 工作区管理
        local workspace = core.require("ghost.features.workspace")
        if workspace then
            self.features.workspace = workspace
        end

        -- 智能复制
        local smart_copy = core.require("ghost.features.smart_copy")
        if smart_copy then
            self.features.smart_copy = smart_copy
        end
    end,

    --- 处理窗口创建事件
    on_window_create = function(self, window, pane)
        -- 工作区恢复
        if self.features.workspace and self.features.workspace.on_window_create then
            self.features.workspace.on_window_create(window, pane)
        end
    end,

    --- 更新状态栏
    update_statusbar = function(self, window, pane)
        if self.features.statusbar and self.features.statusbar.update then
            return self.features.statusbar.update(window, pane)
        end
        return ""
    end,

    --- 处理命令面板
    handle_launcher = function(self, window, pane)
        if self.features.launcher and self.features.launcher.show then
            self.features.launcher.show(window, pane)
        end
    end,
}

-- ============================================
-- 初始化
-- ============================================

-- 创建配置管理器并初始化
local config_manager = ConfigManager
local config = config_manager:init(config_manager)

-- 初始化事件处理器
EventHandler:init()

-- ============================================
-- 导出配置
-- ============================================

-- 注册事件
local format_tab_title = core.require("ghost.events.format_tab_title")
if format_tab_title then
    format_tab_title.register()
end

-- 右侧状态栏
local right_status = core.require("ghost.events.right_status")
if right_status then
    right_status.register()
end

-- 窗口最大化
local window_maximize = core.require("ghost.events.window_maximize")
if window_maximize then
    window_maximize.register()
end

return config
