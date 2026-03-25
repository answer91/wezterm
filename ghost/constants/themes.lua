-- 主题定义
-- 不在顶层 require wezterm，延迟加载

local M = {}

--- Joker Contrast 主题（紫绿配色）
M.joker_contrast = {
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
        [18] = "#ffff00",
        [19] = "#00aaff",
        [20] = "#9d00ff",
        [21] = "#00ffff",
    },
    tab_bar = {
        background = 'rgba(0, 0, 0, 0.4)',
        active_tab = { bg_color = "#9d00ff", fg_color = "#ffffff" },
        inactive_tab = { bg_color = "#1a1a1a", fg_color = "#888888" },
        inactive_tab_hover = { bg_color = "#2a2a2a", fg_color = "#aaaaaa" },
        new_tab = { bg_color = "#1a1a1a", fg_color = "#39ff14" },
        new_tab_hover = { bg_color = "#2a2a2a", fg_color = "#55ff55", italic = true },
    },
    ansi = {
        '#0C0C0C', '#C50F1F', 'FF8DA10E', '#C19C00',
        '#0037DA', '#881798', '#3A96DD', '#CCCCCC',
    },
    brights = {
        '#767676', '#E74856', 'FF9BC60C', '#F9F1A5',
        '#3B78FF', '#B4009E', '#61D6D6', '#F2F2F2',
    },
}

--- Jumper Contrast 主题（蓝橙配色）
M.jumper_contrast = {
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
        [16] = "#ff3333", [18] = "#ffaa00", [19] = "#0088ff",
        [20] = "#ff00ff", [21] = "#00dddd",
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
        "#55aaff", "#ff66ff", "#44ffff", "#ffffff",
    },
}

--- Moonlight II Italic 主题
M.moonlight_ii_italic = {
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
        [16] = "#ff757f", [17] = "#41a6b5", [18] = "#e0c989",
        [19] = "#82aaff", [20] = "#c099ff", [21] = "#86eaa7",
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
}

--- 获取主题
function M.get(name)
    return M[name] or M.joker_contrast
end

--- 获取所有主题名称
function M.list()
    local names = {}
    for name, theme in pairs(M) do
        if type(theme) == "table" and theme.foreground then
            table.insert(names, name)
        end
    end
    table.sort(names)
    return names
end

return M
