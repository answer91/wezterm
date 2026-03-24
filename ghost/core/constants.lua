-- 常量定义
-- 定义系统中使用的各种常量

local wezterm = require("wezterm")
local M = {}

-- ==================== 操作系统常量 ====================

M.OS = {
    LINUX = "linux",
    MACOS = "macos",
    WINDOWS = "windows",
    UNKNOWN = "unknown",
}

-- ==================== 默认路径配置 ====================

M.PATHS = {
    CONFIG_DIR = wezterm.config_dir,
    PICTURES_DIR = "pictures",
    PLUGINS_DIR = "lua/plugins",
    THEMES_DIR = "lua/themes",
    PRESETS_DIR = "presets",
    SSH_CONFIG = wezterm.home_dir .. "/.ssh/config",
}

-- ==================== 常用颜色方案 ====================

M.THEMES = {
    -- Joker Contrast 高对比度主题（紫绿配色）
    joker_contrast = {
        foreground = "#ffffff",
        background = "#0a0a0a",
        cursor_bg = "#39ff14",
        cursor_fg = "#0a0a0a",
        cursor_border = "#39ff14",
        compose_cursor = "#ff00ff",
        selection_fg = "#ffffff",
        selection_bg = "#9d00ff",
        scrollbar_thumb = "#39ff14",
        split = "#9d00ff",

        visual_bell = "#39ff14",

        indexed = {
            [16] = "#ff0055",
            [17] = "#39ff14",
            [18] = "#ffff00",
            [19] = "#00aaff",
            [20] = "#9d00ff",
            [21] = "#00ffff",
        },

        tab_bar = {
            background = "#0a0a0a",
            active_tab = { bg_color = "#9d00ff", fg_color = "#ffffff" },
            inactive_tab = { bg_color = "#1a1a1a", fg_color = "#888888" },
            inactive_tab_hover = { bg_color = "#2a2a2a", fg_color = "#aaaaaa" },
            new_tab = { bg_color = "#1a1a1a", fg_color = "#39ff14" },
            new_tab_hover = { bg_color = "#2a2a2a", fg_color = "#55ff55", italic = true},
        },

        ansi = {
            "#000000", "#ff0055", "#39ff14", "#ffff00",
            "#00aaff", "#9d00ff", "#00ffff", "#ffffff",
        },
        brights = {
            "#555555", "#ff5588", "#55ff55", "#ffff55",
            "#55aaff", "#d455ff", "#55ffff", "#ffffff",
        },
    },

    -- Jumper Contrast 高对比度主题（蓝橙配色）
    jumper_contrast = {
        foreground = "#ffffff",
        background = "#0a0a0a",
        cursor_bg = "#ff6600",
        cursor_fg = "#0a0a0a",
        cursor_border = "#ff6600",
        compose_cursor = "#ffcc00",
        selection_fg = "#ffffff",
        selection_bg = "#0088ff",
        scrollbar_thumb = "#ff6600",
        split = "#0088ff",

        visual_bell = "#ff6600",

        indexed = {
            [16] = "#ff3333",
            [17] = "#00ff00",
            [18] = "#ffaa00",
            [19] = "#0088ff",
            [20] = "#ff00ff",
            [21] = "#00dddd",
        },

        tab_bar = {
            background = "#0a0a0a",
            active_tab = { bg_color = "#0088ff", fg_color = "#ffffff" },
            inactive_tab = { bg_color = "#1a1a1a", fg_color = "#888888" },
            inactive_tab_hover = { bg_color = "#2a2a2a", fg_color = "#aaaaaa" },
            new_tab = { bg_color = "#1a1a1a", fg_color = "#ff6600" },
            new_tab_hover = { bg_color = "#2a2a2a", fg_color = "#ff9933", italic = true},
        },

        ansi = {
            "#000000", "#ff3333", "#00ff00", "#ffaa00",
            "#0088ff", "#ff00ff", "#00dddd", "#ffffff",
        },
        brights = {
            "#444444", "#ff6666", "#44ff44", "#ffcc44",
            "#44aaff", "#ff66ff", "#44ffff", "#ffffff",
        },
    },

    -- Moonlight II Italic 主题（优雅紫色调）
    moonlight_ii_italic = {
        foreground = "#c8d3f5",
        background = "#1e1f2b",
        cursor_bg = "#c8d3f5",
        cursor_fg = "#1e1f2b",
        cursor_border = "#c8d3f5",
        compose_cursor = "#ff966c",
        selection_fg = "#c8d3f5",
        selection_bg = "#3b4261",
        scrollbar_thumb = "#3b4261",
        split = "#82aaff",

        visual_bell = "#ff757f",

        indexed = {
            [16] = "#ff757f",
            [17] = "#41a6b5",
            [18] = "#e0c989",
            [19] = "#82aaff",
            [20] = "#c099ff",
            [21] = "#86eaa7",
        },

        tab_bar = {
            background = "#1e1f2b",
            active_tab = { bg_color = "#82aaff", fg_color = "#1e1f2b" },
            inactive_tab = { bg_color = "#24283b", fg_color = "#565f89" },
            inactive_tab_hover = { bg_color = "#2f334d", fg_color = "#7aa2f7" },
            new_tab = { bg_color = "#24283b", fg_color = "#7aa2f7" },
            new_tab_hover = { bg_color = "#2f334d", fg_color = "#82aaff", italic = true },
        },

        ansi = {
            "#1b1d2b", "#ff757f", "#41a6b5", "#e0c989",
            "#82aaff", "#c099ff", "#86eaa7", "#c8d3f5",
        },
        brights = {
            "#565f89", "#ff757f", "#41a6b5", "#e0c989",
            "#82aaff", "#c099ff", "#86eaa7", "#c8d3f5",
        },
    },
}

-- ==================== 默认快捷键映射 ====================

M.DEFAULT_KEYBINDINGS = {
    -- 基础操作
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

    -- 标签页操作
    { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    { key = "1", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(-1) },

    -- 窗格操作
    { key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "q", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

    -- 字体大小调整
    { key = "=", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },

    -- 滚动
    { key = "u", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByPage(-0.5) },
    { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.ScrollByPage(0.5) },
    { key = "Home", mods = "SHIFT", action = wezterm.action.ScrollToTop },
    { key = "End", mods = "SHIFT", action = wezterm.action.ScrollToBottom },

    -- 其他
    { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
    { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
}

-- ==================== 默认配置选项 ====================

M.DEFAULT_CONFIG = {
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
}

-- ==================== 常用字体 ====================

M.FONTS = {
    -- 英文编程字体
    "JetBrains Mono",
    "Fira Code",
    "Consolas",
    "Source Code Pro",
    "Monaco",

    -- 中文支持字体
    "Sarasa Gothic SC",
    "Noto Sans CJK SC",
    "Microsoft YaHei",
    "PingFang SC",
}

-- ==================== 支持的Shell列表 ====================

M.SHELLS = {
    zsh = "/usr/bin/zsh",
    bash = "/bin/bash",
    fish = "/usr/bin/fish",
}

-- ==================== 布局名称 ====================

M.LAYOUTS = {
    DEFAULT = "default",
    EVEN_HORIZONTAL = "even_horizontal",
    EVEN_VERTICAL = "even_vertical",
    TALL = "tall",
    WIDE = "wide",
    CUSTOM = "custom",
}

-- ==================== 状态栏配置 ====================

M.STATUSBAR = {
    -- 左侧：系统信息
    LEFT = {
        "cpu",
        "memory",
        "battery",
    },

    -- 中间：上下文信息
    MIDDLE = {
        "cwd",
        "git_branch",
        "shell",
    },

    -- 右侧：时间信息
    RIGHT = {
        "time",
        "uptime",
    },
}

-- ==================== 插件Hook类型 ====================

M.PLUGIN_HOOKS = {
    -- 配置加载时
    ON_CONFIG_LOAD = "on_config_load",

    -- 窗口创建时
    ON_WINDOW_CREATE = "on_window_create",

    -- 标签页创建时
    ON_TAB_CREATE = "on_tab_create",

    -- 窗格创建时
    ON_PANE_CREATE = "on_pane_create",

    -- 命令执行前
    BEFORE_command = "before_command",

    -- 命令执行后
    AFTER_COMMAND = "after_command",
}

return M
