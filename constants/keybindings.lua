-- 快捷键定义
-- 延迟获取 wezterm 避免循环引用

local M = {}

--- 获取 wezterm（延迟加载，使用 package.loaded 避免循环引用）
local function get_wezterm()
    return package.loaded["wezterm"]
end

--- 默认快捷键（使用函数延迟构建）
function M.get_defaults()
    local wezterm = get_wezterm()

    return {
        -- 功能键
        { key = "F1", mods = "NONE", action = "ActivateCopyMode" },
        { key = "F2", mods = "NONE", action = wezterm.action.ActivateCommandPalette },
        { key = "F3", mods = "NONE", action = wezterm.action.ShowLauncher },
        { key = "F4", mods = "NONE", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
        { key = "F5", mods = "NONE", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
        { key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },
        { key = "F12", mods = "NONE", action = wezterm.action.ShowDebugOverlay },

        -- 基础操作
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

        -- 标签页操作
        { key = "t", mods = "ALT", action = wezterm.action.SpawnTab("DefaultDomain") },
        { key = "w", mods = "ALT|CTRL", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
        { key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
        { key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
        { key = "[", mods = "ALT|CTRL", action = wezterm.action.MoveTabRelative(-1) },
        { key = "]", mods = "ALT|CTRL", action = wezterm.action.MoveTabRelative(1) },

        -- 标签页数字切换
        { key = "1", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(0) },
        { key = "2", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(1) },
        { key = "3", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(2) },
        { key = "4", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(3) },
        { key = "5", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(4) },
        { key = "6", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(5) },
        { key = "7", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(6) },
        { key = "8", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(7) },
        { key = "9", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTab(-1) },

        -- 窗口操作
        { key = "n", mods = "ALT", action = wezterm.action.SpawnWindow },
        {
            key = "Enter",
            mods = "ALT|CTRL",
            action = wezterm.action_callback(function(window, _pane)
                window:maximize()
            end)
        },

        -- 窗格操作
        { key = "\\", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "\\", mods = "ALT|CTRL", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "Enter", mods = "ALT", action = wezterm.action.TogglePaneZoomState },
        { key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
        { key = "h", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
        { key = "j", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
        { key = "k", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
        { key = "l", mods = "ALT|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
        {
            key = "p",
            mods = "ALT|CTRL",
            action = wezterm.action.PaneSelect({ alphabet = "1234567890", mode = "SwapWithActiveKeepFocus" }),
        },

        -- 窗格滚动
        { key = "u", mods = "ALT", action = wezterm.action.ScrollByLine(-5) },
        { key = "d", mods = "ALT", action = wezterm.action.ScrollByLine(5) },
        { key = "PageUp", mods = "NONE", action = wezterm.action.ScrollByPage(-0.75) },
        { key = "PageDown", mods = "NONE", action = wezterm.action.ScrollByPage(0.75) },

        -- 字体大小调整
        { key = "=", mods = "CTRL|SHIFT", action = wezterm.action.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
        { key = "0", mods = "CTRL|SHIFT", action = wezterm.action.ResetFontSize },

        -- 搜索
        { key = "f", mods = "ALT", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },

        -- 其他
        { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
    }
end

--- Leader 配置
function M.get_leader()
    return {
        key = "Space",
        mods = "ALT|CTRL",
        timeout_milliseconds = 1000,
    }
end

--- 键表定义
function M.get_key_tables()
    local wezterm = get_wezterm()

    return {
        resize_font = {
            { key = "k", action = wezterm.action.IncreaseFontSize },
            { key = "j", action = wezterm.action.DecreaseFontSize },
            { key = "r", action = wezterm.action.ResetFontSize },
            { key = "Escape", action = "PopKeyTable" },
            { key = "q", action = "PopKeyTable" },
        },
        resize_pane = {
            { key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
            { key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
            { key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
            { key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
            { key = "Escape", action = "PopKeyTable" },
            { key = "q", action = "PopKeyTable" },
        },
    }
end

--- 鼠标绑定
function M.get_mouse_bindings()
    local wezterm = get_wezterm()

    return {
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CTRL",
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    }
end

return M
