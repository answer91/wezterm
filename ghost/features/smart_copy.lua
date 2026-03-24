-- 智能复制粘贴
-- 提供URL识别、路径识别、智能选择等功能

local wezterm = require("wezterm")
local utils = require("ghost.core.utils")

local M = {}

--- 剪贴板历史管理器
local ClipboardHistory = {
    history = {},
    max_size = 50,
    current_index = 0,

    --- 添加到历史
    --- @param text string 复制的文本
    add = function(self, text)
        -- 避免重复
        if #self.history > 0 and self.history[1] == text then
            return
        end

        table.insert(self.history, 1, text)
        if #self.history > self.max_size then
            table.remove(self.history)
        end
        self.current_index = 0
    end,

    --- 获取上一个条目
    --- @return string|nil 文本
    get_previous = function(self)
        if self.current_index < #self.history - 1 then
            self.current_index = self.current_index + 1
            return self.history[self.current_index + 1]
        end
        return nil
    end,

    --- 获取下一个条目
    --- @return string|nil 文本
    get_next = function(self)
        if self.current_index > 0 then
            self.current_index = self.current_index - 1
            return self.history[self.current_index + 1]
        end
        return nil
    end,

    --- 获取当前条目
    --- @return string|nil 文本
    get_current = function(self)
        if self.current_index >= 0 and self.current_index < #self.history then
            return self.history[self.current_index + 1]
        end
        return nil
    end,

    --- 重置索引
    reset = function(self)
        self.current_index = 0
    end,
}

--- URL识别器
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
                url = url:gsub("[%.,;:!?)%]]+$", "")
                table.insert(urls, url)
            end
        end

        return urls
    end,

    --- 检测是否为URL
    --- @param text string 输入文本
    --- @return boolean 是否为URL
    is_url = function(self, text)
        return utils.is_url(text)
    end,
}

--- 路径识别器
local PathDetector = {
    --- 路径模式
    patterns = {
        "^~/.+",
        "^/%w",
        "^[A-Za-z]:[/\\].+",
        "^%.%./.+",
        "^%./.+",
    },

    --- 检测文本中的路径
    --- @param text string 输入文本
    --- @return table 路径列表
    detect = function(self, text)
        local paths = {}

        for _, pattern in ipairs(self.patterns) do
            if text:match(pattern) then
                -- 清理路径
                local path = text:gsub("[\"'`]+$", ""):gsub("^[\"'`]+", "")
                path = path:gsub("%s.*$", "")  -- 去除路径后的空格和内容
                table.insert(paths, path)
                break
            end
        end

        return paths
    end,

    --- 检测是否为路径
    --- @param text string 输入文本
    --- @return boolean 是否为路径
    is_path = function(self, text)
        return utils.is_path(text)
    end,
}

--- 智能复制
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.smart_copy(window, pane)
    -- 获取当前选中的文本
    local selection = pane:get_selection_text_for_pane()

    if not selection or #selection == 0 then
        wezterm.log_info("No text selected")
        return
    end

    -- 去除首尾空白
    selection = selection:gsub("^%s+", ""):gsub("%s+$", "")

    -- 添加到剪贴板历史
    ClipboardHistory:add(selection)

    -- 复制到系统剪贴板
    window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)

    -- 检测选中文本的类型
    local urls = URLDetector:detect(selection)
    local paths = PathDetector:detect(selection)

    -- 根据类型执行不同操作
    if #urls > 0 then
        -- 检测到URL
        wezterm.log_info("URL detected: " .. urls[1])
        M.handle_url(window, pane, urls[1])
    elseif #paths > 0 then
        -- 检测到路径
        wezterm.log_info("Path detected: " .. paths[1])
        M.handle_path(window, pane, paths[1])
    else
        -- 普通文本
        wezterm.log_info("Copied: " .. selection)
    end
end

--- 处理URL
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @param url string URL
function M.handle_url(window, pane, url)
    -- 提供操作选项
    window:perform_action(
        wezterm.action.InputSelector({
            title = "URL detected: " .. url,
            choices = {
                { label = "Open in browser", id = "open_browser" },
                { label = "Copy to clipboard", id = "copy" },
                { label = "Cancel", id = "cancel" },
            },
            action = wezterm.action_callback(function(window, pane, id, label)
                if id == "open_browser" then
                    M.open_url(url)
                elseif id == "copy" then
                    -- 已经复制了
                    wezterm.log_info("URL copied: " .. url)
                end
            end),
        }),
        pane
    )
end

--- 处理路径
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @param path string 路径
function M.handle_path(window, pane, path)
    -- 提供操作选项
    window:perform_action(
        wezterm.action.InputSelector({
            title = "Path detected: " .. path,
            choices = {
                { label = "Copy path", id = "copy" },
                { label = "cd to directory", id = "cd" },
                { label = "Open in editor", id = "edit" },
                { label = "Cancel", id = "cancel" },
            },
            action = wezterm.action_callback(function(window, pane, id, label)
                if id == "copy" then
                    -- 已经复制了
                    wezterm.log_info("Path copied: " .. path)
                elseif id == "cd" then
                    -- cd到目录
                    pane:send_text("cd " .. path .. "\n")
                elseif id == "edit" then
                    -- 在编辑器中打开
                    pane:send_text("$EDITOR '" .. path .. "'\n")
                end
            end),
        }),
        pane
    )
end

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
        return
    end

    os.execute(command .. " &")
end

--- 显示剪贴板历史
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_clipboard_history(window, pane)
    if #ClipboardHistory.history == 0 then
        wezterm.log_info("Clipboard history is empty")
        return
    end

    -- 构建历史菜单
    local choices = {}
    for i, text in ipairs(ClipboardHistory.history) do
        local label = text
        if #text > 50 then
            label = text:sub(1, 50) .. "..."
        end
        table.insert(choices, {
            label = label,
            id = tostring(i),
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Clipboard History",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                -- 粘贴选中的文本
                local index = tonumber(id)
                if index and ClipboardHistory.history[index] then
                    pane:paste(ClipboardHistory.history[index])
                end
            end),
        }),
        pane
    )
end

--- 智能粘贴
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.smart_paste(window, pane)
    window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
end

--- 清空剪贴板历史
function M.clear_clipboard_history()
    ClipboardHistory.history = {}
    ClipboardHistory.current_index = 0
    wezterm.log_info("Clipboard history cleared")
end

--- 获取剪贴板历史大小
--- @return number 历史条目数
function M.get_history_size()
    return #ClipboardHistory.history
end

return M
