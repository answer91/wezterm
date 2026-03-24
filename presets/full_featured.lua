-- 完整功能预设配置
-- 启用所有功能，适合演示和探索

local M = {}

return {
    -- ============================================
    -- 外观配置
    -- ============================================
    appearance = {
        -- 主题选择
        theme = "tokyo_night",

        -- 自定义颜色微调
        custom_colors = {
            -- 可以覆盖主题中的颜色
        },

        -- 字体配置
        font = {
            font_family = "JetBrains Mono",
            weight = "Regular",
            stretch = "Normal",
            italic = false,
            font_size = 12.0,
            line_height = 1.1,
        },

        -- 背景配置
        background = {
            enabled = true,
            type = "gradient",
            gradient_colors = { "#1a1b26", "#24283b" },
            interpolation = "Linear",
            blend = "Rgb",
            angle = 45.0,
            opacity = 0.95,
        },

        -- 窗口配置
        window = {
            padding_left = 15,
            padding_right = 15,
            padding_top = 15,
            padding_bottom = 15,
            window_decorations = "TITLE | RESIZE",
            window_close_confirmation = "AlwaysPrompt",
            tab_bar_style = "fancy",
            tab_bar_at_bottom = false,
            enable_scroll_bar = true,
        },

        -- 光标配置
        cursor = {
            style = "BlinkingBlock",
            blink_rate = 600,
        },
    },

    -- ============================================
    -- 快捷键配置
    -- ============================================
    keybindings = {
        -- Leader模式
        leader = {
            enabled = true,
            key = "Space",
            mods = "CTRL",
            timeout = 1000,
        },

        -- 窗格调整模式
        resize_mode = {
            enabled = true,
        },

        -- 激活窗格模式
        activate_pane_mode = {
            enabled = true,
        },

        -- 自定义快捷键
        custom_keys = {
            -- 命令面板
            {
                key = "p",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local launcher = require("ghost.features.launcher")
                    launcher.show_quick_launch(window, pane)
                end),
            },
            -- 快速保存工作区
            {
                key = "s",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local workspace = require("ghost.features.workspace")
                    workspace.quick_save(window)
                end),
            },
            -- 显示工作区列表
            {
                key = "w",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local workspace = require("ghost.features.workspace")
                    workspace.show_workspace_list(window, pane)
                end),
            },
            -- 显示项目列表
            {
                key = "o",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local workspace = require("ghost.features.workspace")
                    workspace.show_project_list(window, pane)
                end),
            },
            -- 智能复制
            {
                key = "c",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local smart_copy = require("ghost.features.smart_copy")
                    smart_copy.smart_copy(window, pane)
                end),
            },
            -- 剪贴板历史
            {
                key = "h",
                mods = "CTRL|SHIFT|ALT",
                action = wezterm.action_callback(function(window, pane)
                    local smart_copy = require("ghost.features.smart_copy")
                    smart_copy.show_clipboard_history(window, pane)
                end),
            },
        },
    },

    -- ============================================
    -- Shell配置
    -- ============================================
    shell = {
        enabled = true,
        -- default_shell = "/bin/zsh",

        -- 环境变量
        env_vars = {
            EDITOR = "vim",
            LANG = "en_US.UTF-8",
            LC_ALL = "en_US.UTF-8",
        },

        -- 项目特定Shell配置
        projects = {
            {
                path = "/home/user/projects",
                shell = "/bin/zsh",
            },
        },
    },

    -- ============================================
    -- SSH配置
    -- ============================================
    ssh = {
        enabled = true,
        -- config_path = "~/.ssh/config",
    },

    -- ============================================
    -- 性能配置（平衡）
    -- ============================================
    performance = {
        enable_startup_optimization = true,
        disable_startup_animation = false,  -- 保留动画
        fast_startup = false,

        enable_render_optimization = true,
        max_fps = 60,
        prefer_egl = false,

        enable_memory_optimization = true,
        max_scrollback_lines = 10000,

        enable_font_optimization = true,

        enable_network_optimization = true,
        websocket_ping_interval = 60,
    },

    -- ============================================
    -- 插件配置
    -- ============================================
    plugins = {
        -- 加载所有示例插件
        "smart_move",
        "url_highlight",
    },
}
