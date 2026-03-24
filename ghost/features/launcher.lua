-- 命令面板/快速启动器
-- 提供类似IDE的命令面板功能

local wezterm = require("wezterm")
local core = require("ghost.core.init")
local utils = require("ghost.core.utils")

local M = {}

--- 命令历史管理器
local CommandHistory = {
    history = {},
    max_size = 100,
    index = 1,

    --- 添加命令到历史
    --- @param command string 命令
    add = function(self, command)
        table.insert(self.history, command)
        if #self.history > self.max_size then
            table.remove(self.history, 1)
        end
    end,

    --- 获取上一个命令
    --- @return string|nil 命令
    get_previous = function(self)
        if self.index > 1 then
            self.index = self.index - 1
            return self.history[self.index]
        end
        return nil
    end,

    --- 获取下一个命令
    --- @return string|nil 命令
    get_next = function(self)
        if self.index < #self.history then
            self.index = self.index + 1
            return self.history[self.index]
        end
        return nil
    end,

    --- 搜索历史命令
    --- @param pattern string 搜索模式
    --- @return table 匹配的命令列表
    search = function(self, pattern)
        local results = {}
        for _, cmd in ipairs(self.history) do
            if cmd:lower():find(pattern:lower()) then
                table.insert(results, cmd)
            end
        end
        return results
    end,

    --- 重置索引
    reset = function(self)
        self.index = #self.history + 1
    end,
}

--- 快速启动项
local QuickLaunchItems = {
    --- 内置快速启动项
    builtin = {
        {
            label = "New Tab",
            action = wezterm.action.SpawnTab("CurrentPaneDomain"),
            key = "t",
        },
        {
            label = "Split Horizontal",
            action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
            key = "h",
        },
        {
            label = "Split Vertical",
            action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
            key = "v",
        },
        {
            label = "Toggle Fullscreen",
            action = wezterm.action.ToggleFullScreen,
            key = "f",
        },
        {
            label = "Reload Config",
            action = wezterm.action.ReloadConfiguration,
            key = "r",
        },
        {
            label = "Increase Font Size",
            action = wezterm.action.IncreaseFontSize,
            key = "=",
        },
        {
            label = "Decrease Font Size",
            action = wezterm.action.DecreaseFontSize,
            key = "-",
        },
        {
            label = "Reset Font Size",
            action = wezterm.action.ResetFontSize,
            key = "0",
        },
        {
            label = "Search",
            action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
            key = "/",
        },
        {
            label = "Copy Mode",
            action = wezterm.action.ActivateCopyMode,
            key = "[",
        },
    },

    --- 用户自定义快速启动项
    custom = {},

    --- 添加自定义启动项
    --- @param item table 启动项 {label, action, key?}
    add = function(self, item)
        table.insert(self.custom, item)
    end,

    --- 获取所有启动项
    --- @return table 启动项列表
    get_all = function(self)
        local result = {}
        for _, item in ipairs(self.builtin) do
            table.insert(result, item)
        end
        for _, item in ipairs(self.custom) do
            table.insert(result, item)
        end
        return result
    end,

    --- 模糊搜索启动项
    --- @param query string 搜索查询
    --- @return table 匹配的启动项
    fuzzy_search = function(self, query)
        local results = {}
        local query_lower = query:lower()

        for _, item in ipairs(self:get_all()) do
            if item.label:lower():find(query_lower) then
                table.insert(results, item)
            end
        end

        return results
    end,
}

--- 显示命令面板
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show(window, pane)
    wezterm.log_info("Launcher activated")

    -- 这里需要实现一个完整的命令面板UI
    -- 由于wezterm的限制，这需要通过input窗格或其他方式实现

    -- 简化版本：使用wezterm的Prompt功能
    window:perform_action(
        wezterm.action.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Foreground = { AnsiColor = "Cyan" } },
                { Text = "Command:" },
            }),
            action = wezterm.action_callback(function(window, pane, line)
                if not line then
                    return
                end

                -- 添加到历史
                CommandHistory:add(line)

                -- 执行命令
                M.execute_command(window, pane, line)
            end),
        }),
        pane
    )
end

--- 执行命令
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @param command string 命令
function M.execute_command(window, pane, command)
    local items = QuickLaunchItems:fuzzy_search(command)

    if #items == 1 then
        -- 直接执行单个匹配项
        window:perform_action(items[1].action, pane)
    elseif #items > 1 then
        -- 显示多个匹配项供选择
        M.show_selection_menu(window, pane, items)
    else
        -- 没有匹配，作为shell命令执行
        pane:send_text(command .. "\n")
    end
end

--- 显示选择菜单
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @param items table 选项列表
function M.show_selection_menu(window, pane, items)
    wezterm.log_info("Showing selection menu with " .. #items .. " items")

    -- 构建菜单
    local choices = {}
    for _, item in ipairs(items) do
        table.insert(choices, {
            label = item.label,
            id = item.label,
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Select Command",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                -- 查找并执行对应的命令
                for _, item in ipairs(items) do
                    if item.label == label then
                        window:perform_action(item.action, pane)
                        break
                    end
                end
            end),
        }),
        pane
    )
end

--- 显示快速启动菜单
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_quick_launch(window, pane)
    local items = QuickLaunchItems:get_all()

    -- 构建菜单
    local choices = {}
    for _, item in ipairs(items) do
        local label = item.label
        if item.key then
            label = label .. " (" .. item.key .. ")"
        end
        table.insert(choices, {
            label = label,
            id = item.label,
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Quick Launch",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                -- 查找并执行对应的命令
                for _, item in ipairs(items) do
                    if item.label == label:gsub(" %(.+%)$", "") then
                        window:perform_action(item.action, pane)
                        break
                    end
                end
            end),
        }),
        pane
    )
end

--- 显示命令历史
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_history(window, pane)
    if #CommandHistory.history == 0 then
        wezterm.log_info("No command history")
        return
    end

    -- 构建历史菜单
    local choices = {}
    for i, cmd in ipairs(CommandHistory.history) do
        table.insert(choices, {
            label = cmd,
            id = tostring(i),
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Command History",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                -- 执行选中的命令
                pane:send_text(label .. "\n")
                CommandHistory:add(label)
            end),
        }),
        pane
    )
end

--- 添加自定义命令
--- @param label string 命令标签
--- @param action table 动作
--- @param key string|nil 快捷键
function M.add_custom_command(label, action, key)
    QuickLaunchItems:add({
        label = label,
        action = action,
        key = key,
    })
end

return M
