-- 极简预设配置
-- 专注于性能和简洁，禁用所有非必要功能

local M = {}

return {
    -- ============================================
    -- 外观配置
    -- ============================================
    appearance = {
        -- 主题选择
        theme = "tokyo_night",

        -- 字体配置
        font = {
            font_family = "JetBrains Mono",
            weight = "Regular",
            font_size = 11.0,
        },

        -- 禁用背景
        background = {
            enabled = false,
        },

        -- 窗口配置
        window = {
            padding_left = 5,
            padding_right = 5,
            padding_top = 5,
            padding_bottom = 5,
            enable_scroll_bar = false,
        },

        -- 光标配置
        cursor = {
            style = "SteadyBlock",
        },
    },

    -- ============================================
    -- 快捷键配置
    -- ============================================
    keybindings = {
        -- 禁用Leader模式
        leader = {
            enabled = false,
        },

        -- 禁用特殊模式
        resize_mode = {
            enabled = false,
        },
        activate_pane_mode = {
            enabled = false,
        },

        -- 最小化快捷键
        custom_keys = {
            { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
            { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
            { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
            { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
            { key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
            { key = "\\", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        },
    },

    -- ============================================
    -- Shell配置
    -- ============================================
    shell = {
        enabled = true,
        -- 不设置环境变量
        env_vars = {},
        -- 不设置项目特定配置
        projects = {},
    },

    -- ============================================
    -- SSH配置
    -- ============================================
    ssh = {
        enabled = false,
    },

    -- ============================================
    -- 性能配置（最大化）
    -- ============================================
    performance = {
        enable_startup_optimization = true,
        disable_startup_animation = true,
        fast_startup = true,

        enable_render_optimization = true,
        max_fps = 30,  -- 降低FPS以节省资源
        prefer_egl = false,

        enable_memory_optimization = true,
        max_scrollback_lines = 1000,  -- 减少回滚行数

        enable_font_optimization = true,

        enable_network_optimization = false,
    },

    -- ============================================
    -- 插件配置
    -- ============================================
    plugins = {
        -- 不加载任何插件
    },
}
