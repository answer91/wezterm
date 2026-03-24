-- 自定义状态栏
-- 显示系统信息、上下文信息、时间等

local wezterm = require("wezterm")
local utils = require("ghost.core.utils")

local M = {}

--- 状态栏配置
local StatusBarConfig = {
    --- 显示哪些部分
    show_left = true,
    show_middle = true,
    show_right = true,

    --- 分隔符
    separator = " | ",

    --- 颜色方案
    colors = {
        left_bg = "#1a1b26",
        left_fg = "#c0caf5",
        middle_bg = "#16161e",
        middle_fg = "#c0caf5",
        right_bg = "#1a1b26",
        right_fg = "#c0caf5",
    },
}

--- 获取CPU使用率
--- @return string CPU使用率
local function get_cpu_usage()
    -- 由于Lua的限制，这里返回模拟数据
    -- 实际实现需要调用系统命令或使用wezterm的API
    return "CPU: --%"
end

--- 获取内存使用率
--- @return string 内存使用率
local function get_memory_usage()
    -- 由于Lua的限制，这里返回模拟数据
    -- 实际实现需要调用系统命令或使用wezterm的API
    return "MEM: --%"
end

--- 获取电池状态
--- @return string 电池状态
local function get_battery_status()
    local os_type = utils.get_os_type()

    if os_type == "linux" then
        -- Linux系统
        local f = io.popen("cat /sys/class/power_supply/BAT0/capacity 2>/dev/null")
        if f then
            local capacity = f:read("*a")
            f:close()
            if capacity and #capacity > 0 then
                return "BAT: " .. capacity:gsub("%s+", "") .. "%"
            end
        end
    elseif os_type == "macos" then
        -- macOS系统
        local f = io.popen("pmset -g batt | grep -o '[0-9]*%' | head -n 1 2>/dev/null")
        if f then
            local capacity = f:read("*a")
            f:close()
            if capacity and #capacity > 0 then
                return "BAT: " .. capacity:gsub("%%", "") .. "%"
            end
        end
    end

    return ""
end

--- 获取当前工作目录
--- @param pane wezterm.Pane 窗格对象
--- @return string 当前目录
local function get_current_directory(pane)
    local cwd = pane and pane:get_current_working_dir()
    if not cwd then
        return "N/A"
    end

    -- 转换文件URI为路径
    local path = cwd:gsub("^file://", "")
    if path:match("^~/") then
        return "~" .. path:sub(2)
    end

    -- 简化路径显示
    local home = wezterm.home_dir
    if path:startswith(home) then
        return "~" .. path:sub(#home + 1)
    end

    -- 只显示最后两级目录
    local parts = utils.split(path, "/")
    if #parts > 2 then
        return ".../" .. table.concat({ unpack(parts, #parts - 1) }, "/")
    end

    return path
end

--- 获取Git分支
--- @param pane wezterm.Pane 窗格对象
--- @return string Git分支
local function get_git_branch(pane)
    if not pane then
        return ""
    end

    local cwd = pane:get_current_working_dir()
    if not cwd then
        return ""
    end

    local path = cwd:gsub("^file://", "")
    local f = io.popen("cd '" .. path .. "' && git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if f then
        local branch = f:read("*a")
        f:close()
        if branch and #branch > 0 then
            branch = branch:gsub("%s+", "")
            if branch ~= "HEAD" then
                return "Git: " .. branch
            end
        end
    end

    return ""
end

--- 获取Shell类型
--- @param pane wezterm.Pane 窗格对象
--- @return string Shell类型
local function get_shell_type(pane)
    if not pane then
        return ""
    end

    local proc_info = pane:get_foreground_process_name()
    if not proc_info then
        return ""
    end

    -- 提取Shell名称
    local shell_name = proc_info:match("([^/]+)$")
    if shell_name then
        return shell_name
    end

    return proc_info
end

--- 获取当前时间
--- @return string 当前时间
local function get_current_time()
    return wezterm.strftime("%H:%M")
end

--- 获取日期
--- @return string 当前日期
local function get_current_date()
    return wezterm.strftime("%Y-%m-%d")
end

--- 获取运行时间
--- @return string 运行时间
local function get_uptime()
    local uptime = wezterm.uptime
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)

    if hours > 0 then
        return string.format("Up: %dh %dm", hours, minutes)
    else
        return string.format("Up: %dm", minutes)
    end
end

--- 构建左侧状态栏（系统信息）
--- @param window wezterm.Window 窗口对象
--- @return table 左侧元素
function M.build_left_section(window)
    local elements = {}

    -- 电池状态
    local battery = get_battery_status()
    if battery and #battery > 0 then
        table.insert(elements, {
            Background = { Color = StatusBarConfig.colors.left_bg },
            Foreground = { Color = StatusBarConfig.colors.left_fg },
            Text = battery,
        })
        table.insert(elements, { Text = StatusBarConfig.separator })
    end

    -- CPU使用率
    local cpu = get_cpu_usage()
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.left_bg },
        Foreground = { Color = StatusBarConfig.colors.left_fg },
        Text = cpu,
    })
    table.insert(elements, { Text = StatusBarConfig.separator })

    -- 内存使用率
    local memory = get_memory_usage()
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.left_bg },
        Foreground = { Color = StatusBarConfig.colors.left_fg },
        Text = memory,
    })

    return elements
end

--- 构建中间状态栏（上下文信息）
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @return table 中间元素
function M.build_middle_section(window, pane)
    local elements = {}

    -- 当前目录
    local cwd = get_current_directory(pane)
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.middle_bg },
        Foreground = { Color = StatusBarConfig.colors.middle_fg },
        Text = cwd,
    })
    table.insert(elements, { Text = StatusBarConfig.separator })

    -- Git分支
    local git_branch = get_git_branch(pane)
    if git_branch and #git_branch > 0 then
        table.insert(elements, {
            Background = { Color = StatusBarConfig.colors.middle_bg },
            Foreground = { Color = StatusBarConfig.colors.middle_fg },
            Text = git_branch,
        })
        table.insert(elements, { Text = StatusBarConfig.separator })
    end

    -- Shell类型
    local shell = get_shell_type(pane)
    if shell and #shell > 0 then
        table.insert(elements, {
            Background = { Color = StatusBarConfig.colors.middle_bg },
            Foreground = { Color = StatusBarConfig.colors.middle_fg },
            Text = shell,
        })
    end

    return elements
end

--- 构建右侧状态栏（时间信息）
--- @param window wezterm.Window 窗口对象
--- @return table 右侧元素
function M.build_right_section(window)
    local elements = {}

    -- 运行时间
    local uptime = get_uptime()
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.right_bg },
        Foreground = { Color = StatusBarConfig.colors.right_fg },
        Text = uptime,
    })
    table.insert(elements, { Text = StatusBarConfig.separator })

    -- 当前时间
    local time = get_current_time()
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.right_bg },
        Foreground = { Color = StatusBarConfig.colors.right_fg },
        Text = time,
    })
    table.insert(elements, { Text = StatusBarConfig.separator })

    -- 当前日期
    local date = get_current_date()
    table.insert(elements, {
        Background = { Color = StatusBarConfig.colors.right_bg },
        Foreground = { Color = StatusBarConfig.colors.right_fg },
        Text = date,
    })

    return elements
end

--- 更新状态栏
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @return table 状态栏元素
function M.update(window, pane)
    local elements = {}

    -- 左侧
    if StatusBarConfig.show_left then
        local left_elements = M.build_left_section(window)
        for _, element in ipairs(left_elements) do
            table.insert(elements, element)
        end
    end

    -- 中间
    if StatusBarConfig.show_middle then
        local middle_elements = M.build_middle_section(window, pane)
        for _, element in ipairs(middle_elements) do
            table.insert(elements, element)
        end
    end

    -- 右侧
    if StatusBarConfig.show_right then
        local right_elements = M.build_right_section(window)
        for _, element in ipairs(right_elements) do
            table.insert(elements, element)
        end
    end

    return elements
end

--- 配置状态栏
--- @param config table 配置表
function M.configure(config)
    if config.show_left ~= nil then
        StatusBarConfig.show_left = config.show_left
    end
    if config.show_middle ~= nil then
        StatusBarConfig.show_middle = config.show_middle
    end
    if config.show_right ~= nil then
        StatusBarConfig.show_right = config.show_right
    end
    if config.separator then
        StatusBarConfig.separator = config.separator
    end
    if config.colors then
        StatusBarConfig.colors = utils.merge_tables(StatusBarConfig.colors, config.colors)
    end
end

--- 添加自定义状态栏项
--- @param position string 位置 ("left", "middle", "right")
--- @param item_function function 生成元素的函数
function M.add_custom_item(position, item_function)
    -- 这个函数允许用户添加自定义状态栏项
    -- 例如：显示天气、股票价格等
end

return M
