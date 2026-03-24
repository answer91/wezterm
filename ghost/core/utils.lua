-- 工具函数库
-- 提供文件操作、字符串处理、系统检测等常用功能

local M = {}
local wezterm = require("wezterm")

-- ==================== 文件操作 ====================

--- 检查文件是否存在
--- @param filepath string 文件路径
--- @return boolean 是否存在
function M.file_exists(filepath)
    local f = io.open(filepath, "r")
    if f then
        f:close()
        return true
    end
    return false
end

--- 读取文件内容
--- @param filepath string 文件路径
--- @return string|nil 文件内容，失败返回nil
function M.read_file(filepath)
    local f, err = io.open(filepath, "r")
    if not f then
        return nil, err
    end
    local content = f:read("*a")
    f:close()
    return content
end

--- 获取wezterm配置目录
--- @return string 配置目录路径
function M.get_config_dir()
    return wezterm.config_dir
end

--- 获取项目根目录
--- @return string 项目根目录
function M.get_project_root()
    return M.get_config_dir()
end

-- ==================== 字符串处理 ====================

--- 检测字符串是否为URL
--- @param str string 输入字符串
--- @return boolean 是否为URL
function M.is_url(str)
    return str:match("^https?://") ~= nil
end

--- 检测字符串是否为文件路径
--- @param str string 输入字符串
--- @return boolean 是否为文件路径
function M.is_path(str)
    return str:match("^~?/") ~= nil or str:match("^[A-Za-z]:") ~= nil
end

--- 提取字符串中的URL
--- @param str string 输入字符串
--- @return table|nil URL列表
function M.extract_urls(str)
    local urls = {}
    for url in str:gmatch("https?://[^%s]+") do
        table.insert(urls, url)
    end
    return #urls > 0 and urls or nil
end

--- 分割字符串
--- @param str string 输入字符串
--- @param sep string 分隔符
--- @return table 分割后的字符串列表
function M.split(str, sep)
    local result = {}
    for match in (str .. sep):gmatch("(.-)" .. sep) do
        table.insert(result, match)
    end
    return result
end

--- 去除字符串首尾空白
--- @param str string 输入字符串
--- @return string 处理后的字符串
function M.trim(str)
    return str:match("^%s*(.-)%s*$")
end

-- ==================== 表操作 ====================

--- 深度复制表
--- @param original table 原始表
--- @return table 复制后的表
function M.deep_copy(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for key, value in next, original, nil do
            copy[M.deep_copy(key)] = M.deep_copy(value)
        end
        setmetatable(copy, M.deep_copy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

--- 合并表
--- @param t1 table 表1
--- @param t2 table 表2
--- @return table 合并后的表
function M.merge_tables(t1, t2)
    local result = M.deep_copy(t1)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(result[k]) == "table" then
            result[k] = M.merge_tables(result[k], v)
        else
            result[k] = v
        end
    end
    return result
end

--- 检查表中是否包含某个值
--- @param tbl table 表
--- @param value any 值
--- @return boolean 是否包含
function M.table_contains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- ==================== 系统检测 ====================

--- 获取操作系统类型
--- @return string 操作系统类型 (linux, macos, windows)
function M.get_os_type()
    local os_type = wezterm.target_triple
    if os_type:match("linux") then
        return "linux"
    elseif os_type:match("apple") or os_type:match("darwin") then
        return "macos"
    elseif os_type:match("windows") or os_type:match("mingw") then
        return "windows"
    end
    return "unknown"
end

--- 检测是否为WSL环境
--- @return boolean 是否为WSL
function M.is_wsl()
    local f = io.popen("uname -r 2>/dev/null")
    if f then
        local uname = f:read("*a")
        f:close()
        return uname:lower():match("microsoft") ~= nil
    end
    return false
end

--- 检测默认Shell
--- @return string|nil Shell路径
function M.get_default_shell()
    local shells = { "fish", "zsh", "bash" }
    for _, shell in ipairs(shells) do
        local f = io.popen("which " .. shell .. " 2>/dev/null")
        if f then
            local path = f:read("*a")
            f:close()
            if path and #path > 0 then
                return M.trim(path)
            end
        end
    end
    return nil
end

-- ==================== 性能工具 ====================

--- 测量函数执行时间
--- @param func function 要测量的函数
--- @param ... any 函数参数
--- @return any 函数返回值, number 执行时间(秒)
function M.measure_time(func, ...)
    local start = os.clock()
    local results = { func(...) }
    local elapsed = os.clock() - start
    return table.unpack(results), elapsed
end

--- 简单的 Debounce 实现
--- @param func function 要执行的函数
--- @param delay number 延迟时间(毫秒)
--- @return function 包装后的函数
function M.debounce(func, delay)
    local timer = nil
    return function(...)
        local args = {...}
        if timer then
            timer:stop()
        end
        timer = wezterm.action_callback(function()
            func(table.unpack(args))
        end)
        wezterm.sleep_ms(delay)
    end
end

-- ==================== 颜色工具 ====================

--- 解析十六进制颜色
--- @param hex string 十六进制颜色字符串 (#RRGGBB)
--- @return table|nil RGBA表
function M.parse_hex_color(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then
        return nil
    end

    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255

    return { r = r, g = g, b = b, a = 1.0 }
end

--- 调整颜色亮度
--- @param color table RGBA表
--- @param factor number 调整因子 (0-2, 1为原始亮度)
--- @return table 调整后的颜色
function M.adjust_brightness(color, factor)
    return {
        r = math.min(1.0, color.r * factor),
        g = math.min(1.0, color.g * factor),
        b = math.min(1.0, color.b * factor),
        a = color.a
    }
end

return M
