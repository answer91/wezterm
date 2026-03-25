-- Wezterm 配置主入口文件
-- 内联配置避免循环引用

local wezterm = require("wezterm")

-- ============================================
-- 直接定义配置（避免模块引用）
-- ============================================

local config = wezterm.config_builder()

-- 应用默认配置
config.adjust_window_size_when_changing_font_size = false
config.allow_win32_input_mode = false
config.automatically_reload_config = true
config.check_for_updates = false
config.exit_behavior = "CloseOnCleanExit"
config.scrollback_lines = 10000
config.use_ime = true

-- ============================================
-- 延迟加载并应用模块
-- ============================================

local function apply_modules()
    -- 外观配置
    local ok, appearance = pcall(require, "ghost.config.appearance")
    if ok and appearance then
        config = appearance.apply(config, {})
    end

    -- 快捷键配置
    ok, keybindings = pcall(require, "ghost.config.keybindings")
    if ok and keybindings then
        config = keybindings.apply(config, {})
    end

    return config
end

-- ============================================
-- 注册事件
-- ============================================

local function register_events()
    -- 右侧状态栏
    local ok, right_status = pcall(require, "ghost.events.right_status")
    if ok and right_status.register then
        right_status.register()
    end

    -- 窗口最大化
    ok, window_maximize = pcall(require, "ghost.events.window_maximize")
    if ok and window_maximize.register then
        window_maximize.register()
    end

    -- 标签页标题
    ok, format_tab_title = pcall(require, "ghost.events.format_tab_title")
    if ok and format_tab_title.register then
        format_tab_title.register()
    end
end

-- ============================================
-- 构建配置
-- ============================================

config = apply_modules()
register_events()

return config
