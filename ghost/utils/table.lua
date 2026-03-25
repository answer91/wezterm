-- 表操作工具函数

local M = {}

--- 深度合并多个表
--- @param base table|nil 基础表
--- @param ... table 要合并的表
--- @return table 合并后的表
function M.deep_merge(base, ...)
    local result = base or {}

    for _, tbl in ipairs({...}) do
        if type(tbl) == "table" then
            for k, v in pairs(tbl) do
                local result_type = type(result[k])
                local v_type = type(v)

                if v_type == "table" and (result_type == "table" or result_type == "userdata") then
                    result[k] = M.deep_merge(result[k], v)
                else
                    result[k] = v
                end
            end
        end
    end

    return result
end

--- 检查快捷键冲突
--- @param keys table 快捷键列表
--- @return table 冲突的快捷键列表
function M.detect_key_conflicts(keys)
    local seen = {}
    local conflicts = {}

    for _, binding in ipairs(keys) do
        local key_id = (binding.mods or "") .. "+" .. binding.key
        if seen[key_id] then
            table.insert(conflicts, {
                key = key_id,
                existing = seen[key_id],
                new = binding,
            })
        else
            seen[key_id] = binding
        end
    end

    return conflicts
end

--- 浅合并表
--- @param base table|nil 基础表
--- @param ... table 要合并的表
--- @return table 合并后的表
function M.merge(base, ...)
    local result = base or {}

    for _, tbl in ipairs({...}) do
        if type(tbl) == "table" then
            for k, v in pairs(tbl) do
                result[k] = v
            end
        end
    end

    return result
end

--- 克隆表（浅拷贝）
--- @param tbl table 要克隆的表
--- @return table 克隆后的表
function M.clone(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        result[k] = v
    end
    return result
end

return M
