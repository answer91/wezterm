-- 核心模块加载器
-- 提供懒加载机制和配置合并功能

local logger = require("ghost.core.logger")

local M = {}

-- 懒加载缓存
local loaded_modules = {}

--- 懒加载模块
--- @param module_name string 模块名称
--- @return table|nil 模块返回值
function M.require(module_name)
    if not loaded_modules[module_name] then
        local success, result = pcall(require, module_name)
        if not success then
            logger.error("init", "Failed to load module: " .. module_name)
            logger.error("init", tostring(result))
            return nil
        end
        loaded_modules[module_name] = result
        logger.debug("init", "Loaded module: " .. module_name)
    end
    return loaded_modules[module_name]
end

--- 深度合并配置表（兼容旧接口）
--- @param base table|nil 基础配置表
--- @param ... table 多个配置表
--- @return table 合并后的配置表
function M.merge_config(base, ...)
    local table_ops = require("ghost.utils.table")
    return table_ops.deep_merge(base, ...)
end

--- 检查模块是否已加载
--- @param module_name string 模块名称
--- @return boolean 是否已加载
function M.is_loaded(module_name)
    return loaded_modules[module_name] ~= nil
end

--- 清除模块缓存
--- @param module_name string|nil 模块名称
function M.clear_cache(module_name)
    if module_name then
        loaded_modules[module_name] = nil
    else
        loaded_modules = {}
    end
end

--- 获取已加载模块列表
--- @return table 已加载模块名称列表
function M.get_loaded_modules()
    local modules = {}
    for name, _ in pairs(loaded_modules) do
        table.insert(modules, name)
    end
    return modules
end

return M
