-- 日志系统
-- 使用 wezterm 原生日志系统
-- 使用 package.loaded 避免循环引用

local LogLevel = {
    DEBUG = 0,
    INFO = 1,
    WARN = 2,
    ERROR = 3,
}

local Logger = {
    level = LogLevel.INFO,
    module_name = "ghost",
}

--- 获取 wezterm 引用（使用 package.loaded 避免循环）
local function get_wezterm()
    return package.loaded["wezterm"]
end

--- 设置日志级别
function Logger.set_level(level)
    Logger.level = level
end

--- 设置模块名称前缀
function Logger.set_module_name(name)
    Logger.module_name = name
end

--- 核心日志函数
function Logger.log(level, module, message, ...)
    if level < Logger.level then return end

    local wezterm = get_wezterm()
    if not wezterm then
        return  -- wezterm 尚未初始化，跳过日志
    end

    local prefix = string.format("[%s] %s:", Logger.module_name, module or "core")
    local msg = string.format("%s %s", prefix, string.format(message, ...))

    if level == LogLevel.ERROR then
        wezterm.log_error(msg)
    elseif level == LogLevel.WARN then
        wezterm.log_warn(msg)
    else
        wezterm.log_info(msg)
    end
end

-- 便捷方法
function Logger.debug(module, ...)
    return Logger.log(LogLevel.DEBUG, module, ...)
end

function Logger.info(module, ...)
    return Logger.log(LogLevel.INFO, module, ...)
end

function Logger.warn(module, ...)
    return Logger.log(LogLevel.WARN, module, ...)
end

function Logger.error(module, ...)
    return Logger.log(LogLevel.ERROR, module, ...)
end

return Logger
