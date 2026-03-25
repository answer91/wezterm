-- 外观配置模块
-- 负责主题、字体、背景等视觉相关的配置

local wezterm = require("wezterm")
local core = require("ghost.core.init")
local utils = require("ghost.core.utils")
local constants = require("ghost.core.constants")

local M = {}

--- 应用主题
--- @param config wezterm.Config 配置对象
--- @param theme_name string 主题名称
--- @param custom_colors table|nil 自定义颜色（可选）
--- @return wezterm.Config 配置对象
local function apply_theme(config, theme_name, custom_colors)
    wezterm.log_info("Applying theme: " .. tostring(theme_name))

    local theme = constants.THEMES[theme_name]
    if not theme then
        wezterm.log_info("Theme not found: " .. theme_name .. ", using moonlight_ii_italic")
        theme = constants.THEMES.moonlight_ii_italic
    end

    wezterm.log_info("Theme background: " .. tostring(theme.background))

    -- 合并自定义颜色
    if custom_colors then
        theme = core.merge_config(theme, custom_colors)
    end

    -- 应用颜色配置
    config.colors = {
        foreground = theme.foreground,
        background = theme.background,
        cursor_bg = theme.cursor_bg,
        cursor_fg = theme.cursor_fg,
        cursor_border = theme.cursor_border,
        compose_cursor = theme.compose_cursor,
        selection_fg = theme.selection_fg,
        selection_bg = theme.selection_bg,
        scrollbar_thumb = theme.scrollbar_thumb,
        split = theme.split,

        visual_bell = theme.visual_bell,

        indexed = theme.indexed,

        tab_bar = theme.tab_bar,

        ansi = theme.ansi,
        brights = theme.brights,
    }

    -- wezterm.log_info("Applied colors background: " .. tostring(config.colors.background))

    return config
end

--- 配置字体
--- @param config wezterm.Config 配置对象
--- @param font_config table 字体配置
--- @return wezterm.Config 配置对象
local function apply_font(config, font_config)
    if not font_config or not font_config.font_family then
        -- 使用默认字体
        config.font = wezterm.font_with_fallback({
            { family = "JetBrains Mono", weight = "Regular" },
        })
        config.font_size = 11.0
    else
        config.font = wezterm.font(font_config.font_family, {
            weight = font_config.weight or "Regular",
            stretch = font_config.stretch or "Normal",
            italic = font_config.italic or false,
        })
        config.font_size = font_config.font_size or 11.0
    end

    -- 字体调整
    if font_config then
        config.line_height = font_config.line_height or 1.0
        config.font_rules = font_config.font_rules or {}
    else
        config.line_height = 1.0
        config.font_rules = {}
    end

    return config
end

--- 配置背景
--- @param config wezterm.Config 配置对象
--- @param background_config table 背景配置
--- @return wezterm.Config 配置对象
local function apply_background(config, background_config)
    if not background_config or not background_config.enabled then
        config.window_background_opacity = 1.0
        return config
    end

    -- 背景透明度
    config.window_background_opacity = background_config.opacity or 0.95
    config.macos_window_background_blur = background_config.blur or 20

    -- 背景图片或渐变
    if background_config.type == "image" and background_config.image_path then
        -- 图片背景
        local full_path = background_config.image_path
        if not utils.file_exists(full_path) then
            -- 尝试相对路径
            full_path = utils.get_config_dir() .. "/pictures/" .. background_config.image_path
        end

        if utils.file_exists(full_path) then
            config.background = {
                {
                    source = { File = { path = full_path } },
                    opacity = background_config.image_opacity or 0.8,
                    hsb = background_config.hsb or {
                        brightness = 0.3,
                        saturation = 0.5,
                        hue = 1.0,
                    },
                },
            }
        else
            wezterm.log_warn("Background image not found: " .. full_path)
        end
    elseif background_config.type == "gradient" and background_config.gradient_colors then
        -- 渐变背景
        config.background = {
            {
                source = { Gradient = {
                    colors = background_config.gradient_colors,
                    interpolation = background_config.interpolation or "Linear",
                    blend = background_config.blend or "Rgb",
                    orientation = background_config.orientation or { Linear = { angle = background_config.angle or 45.0 } },
                }},
            },
        }
    end

    return config
end

--- 配置窗口外观
--- @param config wezterm.Config 配置对象
--- @param window_config table 窗口配置
--- @return wezterm.Config 配置对象
local function apply_window(config, window_config)
    -- 窗口内边距
    config.window_padding = {
        left = window_config.padding_left or 0,
        right = window_config.padding_right or 0,
        top = window_config.padding_top or 10,
        bottom = window_config.padding_bottom or 10,
    }

    -- 窗口装饰
    if window_config.window_decorations then
        config.window_decorations = window_config.window_decorations
    end

    -- 窗口关闭确认
    if window_config.window_close_confirmation then
        config.window_close_confirmation = window_config.window_close_confirmation
    end

    -- 启用花式标签栏
    config.use_fancy_tab_bar = true

    -- 标签栏位置
    if window_config.tab_bar_at_bottom ~= nil then
        config.tab_bar_at_bottom = window_config.tab_bar_at_bottom
    end

    -- 滚动条
    if window_config.enable_scroll_bar ~= nil then
        config.enable_scroll_bar = window_config.enable_scroll_bar
    end

    return config
end

--- 配置光标
--- @param config wezterm.Config 配置对象
--- @param cursor_config table 光标配置
--- @return wezterm.Config 配置对象
local function apply_cursor(config, cursor_config)
    if cursor_config then
        config.default_cursor_style = cursor_config.style or "SteadyBlock"
        config.cursor_blink_rate = cursor_config.blink_rate or 800
    end

    return config
end

--- 配置超链接高亮
--- @param config wezterm.Config 配置对象
--- @param hyperlink_config table|nil 超链接配置
--- @return wezterm.Config 配置对象
local function apply_hyperlinks(config, hyperlink_config)
    -- 默认超链接高亮规则
    local default_rules = {
        -- URL in parens: (URL)
        {
            regex = '\\(\\w+://\\S+\\)',
            format = '$1',
            highlight = 1,
        },
        -- URL in brackets: [URL]
        {
            regex = '\\[\\w+://\\S+\\]',
            format = '$1',
            highlight = 1,
        },
        -- URL in curly braces: {URL}
        {
            regex = '\\{\\w+://\\S+\\}',
            format = '$1',
            highlight = 1,
        },
        -- URL in angle brackets: <URL>
        {
            regex = '<\\w+://\\S+>',
            format = '$1',
            highlight = 1,
        },
        -- Then handle URLs not wrapped in brackets
        {
            regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
            format = '$0',
        },
        -- implicit mailto link
        {
            regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
            format = 'mailto:$0',
        },
    }

    -- 使用用户自定义规则或默认规则
    local rules = hyperlink_config and hyperlink_config.rules or default_rules

    -- 应用超链接规则
    config.hyperlink_rules = rules

    return config
end

--- 应用外观配置
--- @param config wezterm.Config 配置对象
--- @param user_config table 用户配置
--- @return wezterm.Config 配置对象
function M.apply(config, user_config)
    -- 获取用户配置或使用默认值
    local appearance_config = user_config.appearance or {}

    -- 应用主题
    local theme_name = appearance_config.theme or "joker_contrast"
    config = apply_theme(config, theme_name, appearance_config.custom_colors)

    -- 应用字体配置
    config = apply_font(config, appearance_config.font)

    -- 应用背景配置
    local background_config = appearance_config.background
    if not background_config and constants.DEFAULT_BACKGROUND then
        background_config = constants.DEFAULT_BACKGROUND
    end
    config = apply_background(config, background_config)

    -- 应用窗口配置
    config = apply_window(config, appearance_config.window or {})

    -- 应用光标配置
    config = apply_cursor(config, appearance_config.cursor)

    -- 应用超链接高亮配置
    config = apply_hyperlinks(config, appearance_config.hyperlinks)

    return config
end

--- 获取可用主题列表
--- @return table 主题名称列表
function M.get_available_themes()
    local themes = {}
    for name, _ in pairs(constants.THEMES) do
        table.insert(themes, name)
    end
    table.sort(themes)
    return themes
end

--- 创建自定义主题
--- @param theme_name string 主题名称
--- @param theme_colors table 颜色配置
--- @return boolean 是否成功
function M.create_custom_theme(theme_name, theme_colors)
    if not theme_colors or type(theme_colors) ~= "table" then
        wezterm.log_error("Invalid theme colors")
        return false
    end

    -- 验证必需的颜色字段
    local required_fields = {
        "foreground", "background", "cursor_bg", "cursor_fg",
        "selection_fg", "selection_bg"
    }

    for _, field in ipairs(required_fields) do
        if not theme_colors[field] then
            wezterm.log_error("Missing required field: " .. field)
            return false
        end
    end

    -- 保存自定义主题
    constants.THEMES[theme_name] = theme_colors
    return true
end

return M
