-- 配置管理器
-- 使用 package.loaded 避免循环引用

local logger = require("ghost.core.logger")
local utils = require("ghost.utils.init")
local module = require("ghost.core.module")
local constants = require("ghost.constants.init")

local ConfigManager = {
    user_config = {},
    config_search_paths = {
        "user_config.lua",
        ".wezterm.lua",
    },
}

--- 获取 wezterm 引用
local function get_wezterm()
    return package.loaded["wezterm"]
end

--- 加载用户配置
function ConfigManager:load()
    local wezterm = get_wezterm()
    if not wezterm then return false end

    -- 尝试多个配置文件路径
    for _, filename in ipairs(self.config_search_paths) do
        local path = wezterm.config_dir .. "/" .. filename
        if utils.exists(path) then
            self:load_user_file(path)
            return true
        end
    end

    logger.info("config", "No user config found, using defaults")
    return false
end

--- 加载用户配置文件
function ConfigManager:load_user_file(path)
    local success, user_config = pcall(dofile, path)

    if success and type(user_config) == "table" then
        self.user_config = user_config
        logger.info("config", "Loaded user config: " .. path)
        return true
    else
        logger.error("config", "Failed to load: " .. path)
        return false
    end
end

--- 构建配置
function ConfigManager:build()
    local wezterm = get_wezterm()
    if not wezterm then return {} end

    local config = wezterm.config_builder()

    -- 应用默认配置
    config = module.merge_config(config, constants.DEFAULT_CONFIG)

    -- 应用各配置模块
    config = self:apply_appearance(config)
    config = self:apply_keybindings(config)

    return config
end

--- 应用外观配置
function ConfigManager:apply_appearance(config)
    local appearance = module.require("ghost.config.appearance")
    if appearance then
        return appearance.apply(config, self.user_config)
    end
    return config
end

--- 应用快捷键配置
function ConfigManager:apply_keybindings(config)
    local keybindings = module.require("ghost.config.keybindings")
    if keybindings then
        return keybindings.apply(config, self.user_config)
    end
    return config
end

return ConfigManager
