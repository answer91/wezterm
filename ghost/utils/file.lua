-- 文件操作工具函数
-- 使用 package.loaded 避免循环引用

local logger = require("ghost.core.logger")

local function get_wezterm()
    return package.loaded["wezterm"]
end

local M = {}

--- 检查文件是否存在
function M.exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

--- 读取文件内容
function M.read(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end

    local content = file:read("*a")
    file:close()
    return content
end

--- 写入文件内容
function M.write(path, content)
    local file = io.open(path, "w")
    if not file then
        return false
    end

    file:write(content)
    file:close()
    return true
end

--- 获取配置目录
function M.get_config_dir()
    local wezterm = get_wezterm()
    return wezterm and wezterm.config_dir or ""
end

--- 获取主目录
function M.get_home_dir()
    local wezterm = get_wezterm()
    return wezterm and wezterm.home_dir or ""
end

--- 加载 Lua 文件
function M.load_lua_file(path)
    if not M.exists(path) then
        return nil
    end

    local success, result = pcall(dofile, path)
    if success then
        return result
    end

    logger.error("file", "Failed to load: " .. path)
    return nil
end

--- 解析 JSON 文件
function M.load_json(path)
    local content = M.read(path)
    if not content then
        return nil
    end

    local wezterm = get_wezterm()
    if wezterm then
        local success, data = pcall(wezterm.json_decode, content)
        if success then
            return data
        end
    end

    logger.error("file", "Failed to parse JSON: " .. path)
    return nil
end

--- 保存 JSON 文件
function M.save_json(path, data)
    local wezterm = get_wezterm()
    if wezterm then
        local content = wezterm.json_encode(data)
        return M.write(path, content)
    end
    return false
end

return M
