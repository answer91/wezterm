-- 默认预设配置
-- 提供平衡的配置，适合日常使用

local M = {}

return {
    -- ============================================
    -- 外观配置
    -- ============================================
    appearance = {
        -- 主题选择
        theme = "tokyo_night",

        -- 自定义颜色（可选，会覆盖主题颜色）
        custom_colors = {
            -- 例如：background = "#1a1b26",
        },

        -- 字体配置
        font = {
            font_family = "JetBrains Mono",
            weight = "Regular",
            stretch = "Normal",
            italic = false,
            font_size = 11.0,
            line_height = 1.0,
        },

        -- 背景配置
        background = {
            enabled = false,  -- 默认禁用背景图片以提升性能
            -- 如果启用背景图片，可以配置如下：
            -- type = "image",
            -- image_path = "background.png",  -- 图片文件名，放在pictures目录
            -- opacity = 0.8,
            -- blur = 20,
        },

        -- 窗口配置
        window = {
            padding_left = 10,
            padding_right = 10,
            padding_top = 10,
            padding_bottom = 10,
            window_decorations = "TITLE | RESIZE",
            window_close_confirmation = "AlwaysPrompt",
            tab_bar_style = "fancy",  -- 或 "standard"
            tab_bar_at_bottom = false,
            enable_scroll_bar = true,
        },

        -- 光标配置
        cursor = {
            style = "SteadyBlock",  -- SteadyBlock, BlinkingBlock, SteadyUnderline, etc.
            blink_rate = 800,
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

        -- 自定义快捷键（会覆盖默认快捷键）
        custom_keys = {
            -- 例如：
            -- { key = "e", mods = "CTRL|SHIFT", action = wezterm.action.SpawnCommandInNewTab({ args = { "vim" } }) },
        },
    },

    -- ============================================
    -- Shell配置
    -- ============================================
    shell = {
        enabled = true,
        -- default_shell = "/bin/zsh",  -- 留空自动检测

        -- 环境变量
        env_vars = {
            -- 例如：
            -- EDITOR = "vim",
            -- LANG = "en_US.UTF-8",
        },

        -- 项目特定Shell配置
        projects = {
            -- 例如：
            -- {
            --     path = "/path/to/project",
            --     shell = "/bin/bash",
            -- },
        },
    },

    -- ============================================
    -- SSH配置
    -- ============================================
    ssh = {
        enabled = true,
        -- config_path = "~/.ssh/config",  -- 默认路径
    },

    -- ============================================
    -- 性能配置
    -- ============================================
    performance = {
        enable_startup_optimization = true,
        disable_startup_animation = true,
        fast_startup = true,

        enable_render_optimization = true,
        max_fps = 60,
        prefer_egl = false,

        enable_memory_optimization = true,
        max_scrollback_lines = 10000,

        enable_font_optimization = true,

        enable_network_optimization = false,
    },

    -- ============================================
    -- 插件配置
    -- ============================================
    plugins = {
        -- 启用的插件列表
        -- 例如：{"smart-move", "url-highlight"},
    },
}
