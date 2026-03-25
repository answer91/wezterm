-- 工具函数统一入口
-- 保持向后兼容

local table_ops = require("ghost.utils.table")
local string_ops = require("ghost.utils.string")
local file_ops = require("ghost.utils.file")

local M = {}

-- 表操作
M.deep_merge = table_ops.deep_merge
M.detect_key_conflicts = table_ops.detect_key_conflicts
M.merge = table_ops.merge
M.clone = table_ops.clone

-- 字符串操作
M.split = string_ops.split
M.trim = string_ops.trim
M.starts_with = string_ops.starts_with
M.ends_with = string_ops.ends_with
M.format_size = string_ops.format_size

-- 文件操作
M.exists = file_ops.exists
M.read = file_ops.read
M.write = file_ops.write
M.get_config_dir = file_ops.get_config_dir
M.get_home_dir = file_ops.get_home_dir
M.load_lua_file = file_ops.load_lua_file
M.load_json = file_ops.load_json
M.save_json = file_ops.save_json

--- 兼容旧代码的工具函数集合
M.utils = {
    merge_tables = table_ops.merge,
    split = string_ops.split,
    file_exists = file_ops.exists,
    read_file = file_ops.read,
}

return M
