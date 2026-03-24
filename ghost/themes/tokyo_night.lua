-- Tokyo Night Theme
-- 深色主题，灵感来自VSCode的Tokyo Night主题

local M = {
    name = "tokyo_night",
    description = "A dark theme inspired by Tokyo Night",
    colors = {
        -- 基础颜色
        foreground = "#c0caf5",
        background = "#1a1b26",
        cursor_bg = "#c0caf5",
        cursor_fg = "#1a1b26",
        cursor_border = "#c0caf5",

        -- 选择颜色
        selection_fg = "#c0caf5",
        selection_bg = "#33467c",

        -- 滚动条
        scrollbar_thumb = "#394b70",

        -- 分屏边框
        split = "#7aa2f7",

        -- ANSI颜色
        ansi = {
            "#15161e",  -- black (normal)
            "#f7768e",  -- red (normal)
            "#9ece6a",  -- green (normal)
            "#e0af68",  -- yellow (normal)
            "#7aa2f7",  -- blue (normal)
            "#bb9af7",  -- magenta (normal)
            "#7dcfff",  -- cyan (normal)
            "#a9b1d6",  -- white (normal)
        },

        -- 明亮颜色
        brights = {
            "#414868",  -- black (bright)
            "#f7768e",  -- red (bright)
            "#9ece6a",  -- green (bright)
            "#e0af68",  -- yellow (bright)
            "#7aa2f7",  -- blue (bright)
            "#bb9af7",  -- magenta (bright)
            "#7dcfff",  -- cyan (bright)
            "#c0caf5",  -- white (bright)
        },
    },

    -- 其他视觉配置
    appearance = {
        tab_bar = {
            background = "#1a1b26",
            active_tab = {
                bg_color = "#7aa2f7",
                fg_color = "#1a1b26",
                intensity = "Normal",
            },
            inactive_tab = {
                bg_color = "#16161e",
                fg_color = "#565f89",
            },
            inactive_tab_hover = {
                bg_color = "#1f2335",
                fg_color = "#7aa2f7",
            },
        },
    },
}

return M
