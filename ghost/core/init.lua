-- 核心模块加载器
-- 提供懒加载机制和配置合并功能

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
            wezterm.log_error("Failed to load module: " .. module_name)
            wezterm.log_error(result)
            return nil
        end
        loaded_modules[module_name] = result
    end
    return loaded_modules[module_name]
end

--- 深度合并配置表
--- @param base table|nil 基础配置表（WezTerm config 对象）
--- @param ... table 多个配置表
--- @return table 合并后的配置表
function M.merge_config(base, ...)
    -- 如果 base 为空或不是 table/userdata，创建新表
    if not base or (type(base) ~= "table" and type(base) ~= "userdata") then
        base = {}
    end

    local configs = {...}
    local result = base

    for _, config in ipairs(configs) do
        if type(config) == "table" then
            for k, v in pairs(config) do
                local result_type = type(result[k])
                local v_type = type(v)

                -- 递归合并子表
                if v_type == "table" and (result_type == "table" or result_type == "userdata") then
                    result[k] = M.merge_config(result[k], v)
                else
                    -- 直接赋值（WezTerm config 对象支持直接设置属性）
                    result[k] = v
                end
            end
        end
    end

    return result
end

--- 检查模块是否已加载
--- @param module_name string 模块名称
--- @return boolean 是否已加载
function M.is_loaded(module_name)
    return loaded_modules[module_name] ~= nil
end

--- 清除模块缓存（用于开发调试）
--- @param module_name string|nil 模块名称，为nil时清除所有缓存
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
