-- Dracula Theme
-- 经典的Dracula配色方案

local M = {
    name = "dracula",
    description = "A classic dark theme",
    colors = {
        -- 基础颜色
        foreground = "#f8f8f2",
        background = "#282a36",
        cursor_bg = "#f8f8f2",
        cursor_fg = "#282a36",
        cursor_border = "#f8f8f2",

        -- 选择颜色
        selection_fg = "#ffffff",
        selection_bg = "#44475a",

        -- 滚动条
        scrollbar_thumb = "#44475a",

        -- 分屏边框
        split = "#6272a4",

        -- ANSI颜色
        ansi = {
            "#21222c",  -- black (normal)
            "#ff5555",  -- red (normal)
            "#50fa7b",  -- green (normal)
            "#f1fa8c",  -- yellow (normal)
            "#bd93f9",  -- blue (normal)
            "#ff79c6",  -- magenta (normal)
            "#8be9fd",  -- cyan (normal)
            "#f8f8f2",  -- white (normal)
        },

        -- 明亮颜色
        brights = {
            "#6272a4",  -- black (bright)
            "#ff6e6e",  -- red (bright)
            "#69ff94",  -- green (bright)
            "#ffffa5",  -- yellow (bright)
            "#d6acff",  -- blue (bright)
            "#ff92df",  -- magenta (bright)
            "#a4ffff",  -- cyan (bright)
            "#ffffff",  -- white (bright)
        },
    },

    -- 其他视觉配置
    appearance = {
        tab_bar = {
            background = "#282a36",
            active_tab = {
                bg_color = "#bd93f9",
                fg_color = "#282a36",
                intensity = "Normal",
            },
            inactive_tab = {
                bg_color = "#191a21",
                fg_color = "#6272a4",
            },
            inactive_tab_hover = {
                bg_color = "#21222c",
                fg_color = "#bd93f9",
            },
        },
    },
}

return M
