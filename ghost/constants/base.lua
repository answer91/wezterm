-- 基础常量定义

local M = {
    --- 版本信息
    VERSION = "2.0.0",

    --- 操作系统类型
    OS = {
        LINUX = "linux",
        MACOS = "macos",
        WINDOWS = "windows",
        UNKNOWN = "unknown",
    },

    --- 默认配置选项
    DEFAULT_CONFIG = {
        adjust_window_size_when_changing_font_size = false,
        allow_win32_input_mode = false,
        automatically_reload_config = true,
        check_for_updates = false,
        debug_key_events = false,
        exit_behavior = "CloseOnCleanExit",
        harfbuzz_features = { "calt", "clig" },
        scrollback_lines = 10000,
        tab_bar_at_bottom = false,
        use_ime = true,
        window_close_confirmation = "AlwaysPrompt",
    },

    --- 默认背景图片配置
    DEFAULT_BACKGROUND = {
        enabled = true,
        type = "image",
        image_path = "kobe-4.jpg",
        image_opacity = 1,
    },

    --- 布局名称
    LAYOUTS = {
        DEFAULT = "default",
        EVEN_HORIZONTAL = "even_horizontal",
        EVEN_VERTICAL = "even_vertical",
        TALL = "tall",
        WIDE = "wide",
        CUSTOM = "custom",
    },

    --- 状态栏配置
    STATUSBAR = {
        LEFT = { "cpu", "memory", "battery" },
        MIDDLE = { "cwd", "git_branch", "shell" },
        RIGHT = { "time", "uptime" },
    },

    --- 插件 Hook 类型
    PLUGIN_HOOKS = {
        ON_CONFIG_LOAD = "on_config_load",
        ON_WINDOW_CREATE = "on_window_create",
        ON_TAB_CREATE = "on_tab_create",
        ON_PANE_CREATE = "on_pane_create",
        BEFORE_COMMAND = "before_command",
        AFTER_COMMAND = "after_command",
    },

    --- Shell 路径配置
    SHELLS = {
        zsh = "/usr/bin/zsh",
        bash = "/bin/bash",
        fish = "/usr/bin/fish",
    },

    --- 系统路径配置
    PATHS = {
        SSH_CONFIG = "~/.ssh/config",
    },
}

return M
