-- Catppuccin Mocha Theme
-- 温暖舒适的深色主题

local M = {
    name = "catppuccin",
    description = "A warm and cozy dark theme",
    colors = {
        -- 基础颜色
        foreground = "#cdd6f4",
        background = "#1e1e2e",
        cursor_bg = "#f5e0dc",
        cursor_fg = "#1e1e2e",
        cursor_border = "#f5e0dc",

        -- 选择颜色
        selection_fg = "#cdd6f4",
        selection_bg = "#45475a",

        -- 滚动条
        scrollbar_thumb = "#45475a",

        -- 分屏边框
        split = "#89b4fa",

        -- ANSI颜色
        ansi = {
            "#45475a",  -- black (normal)
            "#f38ba8",  -- red (normal)
            "#a6e3a1",  -- green (normal)
            "#f9e2af",  -- yellow (normal)
            "#89b4fa",  -- blue (normal)
            "#f5c2e7",  -- magenta (normal)
            "#94e2d5",  -- cyan (normal)
            "#bac2de",  -- white (normal)
        },

        -- 明亮颜色
        brights = {
            "#585b70",  -- black (bright)
            "#f38ba8",  -- red (bright)
            "#a6e3a1",  -- green (bright)
            "#f9e2af",  -- yellow (bright)
            "#89b4fa",  -- blue (bright)
            "#f5c2e7",  -- magenta (bright)
            "#94e2d5",  -- cyan (bright)
            "#a6adc8",  -- white (bright)
        },
    },

    -- 其他视觉配置
    appearance = {
        tab_bar = {
            background = "#1e1e2e",
            active_tab = {
                bg_color = "#89b4fa",
                fg_color = "#1e1e2e",
                intensity = "Normal",
            },
            inactive_tab = {
                bg_color = "#181825",
                fg_color = "#585b70",
            },
            inactive_tab_hover = {
                bg_color = "#313244",
                fg_color = "#89b4fa",
            },
        },
    },
}

return M
