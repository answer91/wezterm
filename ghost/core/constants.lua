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
            new_tab_hover = { bg_color = "#2a2a2a", fg_color = "#55ff55", italic = true },
        },

        ansi = {
            '#0C0C0C', -- black
            '#C50F1F', -- red
            'FF8DA10E', -- green
            '#C19C00', -- yellow
            '#0037DA', -- blue
            '#881798', -- magenta/purple
            '#3A96DD', -- cyan
            '#CCCCCC', -- white
        },
        brights = {
            '#767676', -- black
            '#E74856', -- red
            'FF9BC60C', -- green
            '#F9F1A5', -- yellow
            '#3B78FF', -- blue
            '#B4009E', -- magenta/purple
            '#61D6D6', -- cyan
            '#F2F2F2', -- white
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
            new_tab_hover = { bg_color = "#2a2a2a", fg_color = "#ff9933", italic = true },
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

-- ==================== 平台修饰键配置 ====================

M.MOD_KEYS = {
    -- Linux 使用 ALT 作为主修饰键（避免与 Windows 键冲突）
    SUPER = "ALT",
    SUPER_REV = "ALT|CTRL",
}

-- ==================== 默认快捷键映射 ====================

M.DEFAULT_KEYBINDINGS = {
    -- ========== 功能键 ==========
    { key = "F1",  mods = "NONE",       action = "ActivateCopyMode" },
    { key = "F2",  mods = "NONE",       action = wezterm.action.ActivateCommandPalette },
    { key = "F3",  mods = "NONE",       action = wezterm.action.ShowLauncher },
    { key = "F4",  mods = "NONE",       action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
    { key = "F5",  mods = "NONE",       action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
    { key = "F11", mods = "NONE",       action = wezterm.action.ToggleFullScreen },
    { key = "F12", mods = "NONE",       action = wezterm.action.ShowDebugOverlay },

    -- ========== 基础操作 ==========
    { key = "c",   mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v",   mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

    -- ========== 标签页操作 ==========
    -- 标签页：新建和关闭
    { key = "t",   mods = "ALT",        action = wezterm.action.SpawnTab("DefaultDomain") },
    { key = "w",   mods = "ALT|CTRL",   action = wezterm.action.CloseCurrentTab({ confirm = false }) },

    -- 标签页：导航
    { key = "[",   mods = "ALT",        action = wezterm.action.ActivateTabRelative(-1) },
    { key = "]",   mods = "ALT",        action = wezterm.action.ActivateTabRelative(1) },
    { key = "[",   mods = "ALT|CTRL",   action = wezterm.action.MoveTabRelative(-1) },
    { key = "]",   mods = "ALT|CTRL",   action = wezterm.action.MoveTabRelative(1) },

    -- 标签页：数字切换
    { key = "1",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(0) },
    { key = "2",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(1) },
    { key = "3",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(2) },
    { key = "4",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(3) },
    { key = "5",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(4) },
    { key = "6",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(5) },
    { key = "7",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(6) },
    { key = "8",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(7) },
    { key = "9",   mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(-1) },

    -- ========== 窗口操作 ==========
    { key = "n",   mods = "ALT",        action = wezterm.action.SpawnWindow },
    {
        key = "Enter",
        mods = "ALT|CTRL",
        action = wezterm.action_callback(function(window, _pane)
            window:maximize()
        end)
    },

    -- ========== 窗格操作 ==========
    -- 窗格：分割
    { key = "\\",    mods = "ALT",      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\",    mods = "ALT|CTRL", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    -- 窗格：缩放和关闭
    { key = "Enter", mods = "ALT",      action = wezterm.action.TogglePaneZoomState },
    { key = "w",     mods = "ALT",      action = wezterm.action.CloseCurrentPane({ confirm = false }) },

    -- 窗格：导航（Vim风格）
    { key = "h",     mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "j",     mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
    { key = "k",     mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "l",     mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },

    -- 窗格：快速选择和交换
    {
        key = "p",
        mods = "ALT|CTRL",
        action = wezterm.action.PaneSelect({ alphabet = "1234567890", mode = "SwapWithActiveKeepFocus" }),
    },

    -- 窗格：滚动
    { key = "u",        mods = "ALT",        action = wezterm.action.ScrollByLine(-5) },
    { key = "d",        mods = "ALT",        action = wezterm.action.ScrollByLine(5) },
    { key = "PageUp",   mods = "NONE",       action = wezterm.action.ScrollByPage(-0.75) },
    { key = "PageDown", mods = "NONE",       action = wezterm.action.ScrollByPage(0.75) },

    -- ========== 字体大小调整 ==========
    { key = "=",        mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
    { key = "-",        mods = "CTRL",       action = wezterm.action.DecreaseFontSize },
    { key = "0",        mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },

    -- ========== 搜索 ==========
    { key = "f",        mods = "ALT",        action = wezterm.action.Search({ CaseInSensitiveString = "" }) },

    -- ========== 其他 ==========
    { key = "r",        mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
}

-- ==================== 键表（Key Tables）====================

M.KEY_TABLES = {
    resize_font = {
        { key = "k",      action = wezterm.action.IncreaseFontSize },
        { key = "j",      action = wezterm.action.DecreaseFontSize },
        { key = "r",      action = wezterm.action.ResetFontSize },
        { key = "Escape", action = "PopKeyTable" },
        { key = "q",      action = "PopKeyTable" },
    },
    resize_pane = {
        { key = "k",      action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
        { key = "j",      action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
        { key = "h",      action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
        { key = "l",      action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
        { key = "Escape", action = "PopKeyTable" },
        { key = "q",      action = "PopKeyTable" },
    },
}

-- ==================== 鼠标绑定 ====================

M.MOUSE_BINDINGS = {
    -- Ctrl+点击打开链接
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- ==================== Leader 配置 ====================

M.LEADER_CONFIG = {
    key = "Space",
    mods = "ALT|CTRL",
    timeout_milliseconds = 1000,
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

-- 默认背景图片配置
M.DEFAULT_BACKGROUND = {
    enabled = true,
    type = "image",
    image_path = "sword.jpg",
    image_opacity = 1,
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
