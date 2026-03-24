-- URL Highlight Plugin
-- 自动高亮和快速打开URL

local wezterm = require("wezterm")
local utils = require("ghost.core.utils")

local M = {
    name = "url_highlight",
    version = "1.0.0",
    description = "Highlight and quickly open URLs",
    author = "Wezterm Config",
}

--- URL检测器
local URLDetector = {
    --- URL模式
    patterns = {
        "https?://[%w-_%.%?%~%+%*%;%@&=#%:/]+",
        "www%.[%w-_%.%?%~%+%*%;%@&=#%:/]+",
        "ftp://[%w-_%.%?%~%+%*%;%@&=#%:/]+",
    },

    --- 检测文本中的URL
    --- @param text string 输入文本
    --- @return table URL列表
    detect = function(self, text)
        local urls = {}
        for _, pattern in ipairs(self.patterns) do
            for url in text:gmatch(pattern) do
                -- 去除末尾的标点符号
                url = url:gsub("[%.,;:!?)%]}\"]+$", "")
                table.insert(urls, url)
            end
        end
        return urls
    end,
}

--- 插件配置
local config = {
    --- 是否自动高亮URL
    auto_highlight = true,

    --- URL颜色
    url_color = "#7aa2f7",

    --- 点击打开URL（需要终端支持）
    click_to_open = true,

    --- 快捷键打开URL
    open_key = "o",
    open_mods = "CTRL|SHIFT",
}

--- 打开URL
--- @param url string URL
function M.open_url(url)
    local os_type = utils.get_os_type()
    local command

    if os_type == "linux" then
        command = "xdg-open '" .. url .. "'"
    elseif os_type == "macos" then
        command = "open '" .. url .. "'"
    elseif os_type == "windows" then
        command = "start '' '" .. url .. "'"
    else
        wezterm.log_error("Unsupported OS for opening URL")
        return false
    end

    os.execute(command .. " &")
    return true
end

--- 获取当前选中的URL
--- @param pane wezterm.Pane 窗格对象
--- @return string|nil URL
function M.get_selected_url(pane)
    local selection = pane:get_selection_text_for_pane()
    if not selection or #selection == 0 then
        return nil
    end

    local urls = URLDetector:detect(selection)
    if #urls > 0 then
        return urls[1]
    end

    return nil
end

--- 显示URL选择菜单
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_url_menu(window, pane)
    -- 获取当前选中的文本
    local selection = pane:get_selection_text_for_pane()
    if not selection or #selection == 0 then
        wezterm.log_info("No text selected")
        return
    end

    -- 检测URL
    local urls = URLDetector:detect(selection)
    if #urls == 0 then
        wezterm.log_info("No URLs found in selection")
        return
    end

    -- 构建菜单
    local choices = {}
    for i, url in ipairs(urls) do
        local label = url
        if #url > 50 then
            label = url:sub(1, 50) .. "..."
        end
        table.insert(choices, {
            label = label,
            id = tostring(i),
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Select URL to Open",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                local index = tonumber(id)
                if index and urls[index] then
                    M.open_url(urls[index])
                end
            end),
        }),
        pane
    )
end

--- 插件设置函数
--- @param user_config table 用户配置
function M.setup(user_config)
    -- 合并配置
    if user_config then
        for k, v in pairs(user_config) do
            config[k] = v
        end
    end

    wezterm.log_info("URL Highlight plugin loaded")
end

--- 创建快捷键绑定
--- @return table 快捷键列表
function M.create_keybindings()
    local keys = {}

    -- 打开URL快捷键
    table.insert(keys, {
        key = config.open_key,
        mods = config.open_mods,
        action = wezterm.action_callback(function(window, pane)
            -- 先尝试获取选中的URL
            local url = M.get_selected_url(pane)
            if url then
                -- 如果有选中的URL，直接打开
                M.open_url(url)
            else
                -- 否则显示菜单
                M.show_url_menu(window, pane)
            end
        end),
    })

    return keys
end

--- 插件清理函数
function M.cleanup()
    wezterm.log_info("URL Highlight plugin cleaned up")
end

--- 插件Hooks
M.hooks = {
    --- 配置加载时
    on_config_load = function(config)
        wezterm.log_info("URL Highlight: config loaded")
    end,

    --- 窗格创建时
    on_pane_create = function(window, pane)
        wezterm.log_info("URL Highlight: pane created")
    end,
}

return M
