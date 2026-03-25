-- 字符串操作工具函数

local M = {}

--- 分割字符串
--- @param str string 要分割的字符串
--- @param sep string 分隔符
--- @return table 分割后的数组
function M.split(str, sep)
    local result = {}
    local pattern = string.format("([^%s]+)", sep)
    for match in string.gmatch(str, pattern) do
        table.insert(result, match)
    end
    return result
end

--- 去除字符串首尾空白
--- @param str string 要处理的字符串
--- @return string 处理后的字符串
function M.trim(str)
    return str:match("^%s*(.-)%s*$")
end

--- 判断字符串是否以指定前缀开头
--- @param str string 要检查的字符串
--- @param prefix string 前缀
--- @return boolean
function M.starts_with(str, prefix)
    return str:sub(1, #prefix) == prefix
end

--- 判断字符串是否以指定后缀结尾
--- @param str string 要检查的字符串
--- @param suffix string 后缀
--- @return boolean
function M.ends_with(str, suffix)
    return str:sub(-#suffix) == suffix
end

--- 格式化文件大小
--- @param bytes number 字节数
--- @return string 格式化后的大小
function M.format_size(bytes)
    if not bytes or bytes == 0 then return "0 B" end

    local units = {"B", "KB", "MB", "GB", "TB"}
    local unit = 1

    while bytes >= 1024 and unit <= #units do
        bytes = bytes / 1024
        unit = unit + 1
    end

    return string.format("%.1f %s", bytes, units[unit] or "B")
end

return M
