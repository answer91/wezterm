-- 背景图片切换器
-- 支持快捷键切换背景图片，自动轮播，背景图片列表管理

--- 获取 wezterm（延迟加载，使用 package.loaded 避免循环引用）
local function get_wezterm()
    return package.loaded["wezterm"]
end

local utils = require("ghost.utils.init")
local logger = require("ghost.core.logger")

local M = {}

--- 背景图片管理器
local BackgroundSwitcher = {
    --- 当前背景图片索引
    current_index = 1,

    --- 可用背景图片列表
    backgrounds = {},

    --- 配置目录
    config_dir = "",

    --- 是否自动轮播
    auto_rotate = false,

    --- 轮播间隔（秒）
    rotate_interval = 300, -- 5分钟

    --- 轮播定时器
    rotate_timer = nil,

    --- 是否已初始化
    initialized = false,

    --- 初始化背景列表
    init = function(self)
        -- 避免重复初始化
        if self.initialized then
            return
        end

        self.config_dir = utils.get_config_dir()
        self.backgrounds = self:scan_backgrounds()

        if #self.backgrounds == 0 then
            logger.warn("background_switcher", "No background images found")
        else
            logger.info("background_switcher", "Found " .. #self.backgrounds .. " background images")
            -- 尝试恢复上次使用的背景
            self:restore_last_background()
        end

        self.initialized = true
    end,

    --- 扫描背景图片目录
    --- @return table 背景图片列表
    scan_backgrounds = function(self)
        local backgrounds = {}
        local pictures_dir = self.config_dir .. "/pictures"

        -- 已知的背景图片文件
        local known_files = {
            "kobe-1.jpg",
            "kobe-2.jpg",
            "kobe-3.jpg",
            "sword.jpg",
        }

        -- 检查每个文件是否存在
        for _, filename in ipairs(known_files) do
            local filepath = pictures_dir .. "/" .. filename
            if utils.exists(filepath) then
                table.insert(backgrounds, filepath)
            end
        end

        -- 按文件名排序
        table.sort(backgrounds)

        return backgrounds
    end,

    --- 获取背景图片列表
    --- @return table 背景图片列表
    get_backgrounds = function(self)
        return self.backgrounds
    end,

    --- 获取当前背景图片
    --- @return string|nil 当前背景图片路径
    get_current_background = function(self)
        if #self.backgrounds == 0 then
            return nil
        end
        return self.backgrounds[self.current_index]
    end,

    --- 切换到指定背景图片
    --- @param index number 背景图片索引
    --- @return boolean 是否成功
    set_background = function(self, index)
        if #self.backgrounds == 0 then
            return false
        end

        -- 确保索引在有效范围内
        if index < 1 then
            index = #self.backgrounds
        elseif index > #self.backgrounds then
            index = 1
        end

        self.current_index = index
        local background_path = self.backgrounds[index]

        logger.info("background_switcher", "Switching to background: " .. background_path)

        -- 保存当前背景设置
        self:save_current_background(background_path)

        -- 重新加载配置以应用新背景
        local wezterm = get_wezterm()
        if wezterm then
            wezterm.reload_configuration()
        end

        return true
    end,

    --- 切换到下一个背景图片
    --- @return boolean 是否成功
    next_background = function(self)
        return self:set_background(self.current_index + 1)
    end,

    --- 切换到上一个背景图片
    --- @return boolean 是否成功
    prev_background = function(self)
        return self:set_background(self.current_index - 1)
    end,

    --- 随机切换背景图片
    --- @return boolean 是否成功
    random_background = function(self)
        if #self.backgrounds == 0 then
            return false
        end

        local random_index = math.random(1, #self.backgrounds)
        return self:set_background(random_index)
    end,

    --- 保存当前背景设置
    --- @param background_path string 背景图片路径
    save_current_background = function(self, background_path)
        local state_file = self.config_dir .. "/background_state.txt"
        local file = io.open(state_file, "w")
        if file then
            file:write(background_path)
            file:close()
        end
    end,

    --- 恢复上次使用的背景
    restore_last_background = function(self)
        local state_file = self.config_dir .. "/background_state.txt"
        local file = io.open(state_file, "r")
        if file then
            local current_bg = file:read("*line")
            file:close()

            if current_bg then
                -- 查找对应索引
                for i, bg in ipairs(self.backgrounds) do
                    if bg == current_bg then
                        self.current_index = i
                        logger.info("background_switcher", "Restored background: " .. current_bg)
                        return true
                    end
                end
            end
        end
        return false
    end,

    --- 启用自动轮播
    --- @param interval number 轮播间隔（秒）
    start_auto_rotate = function(self, interval)
        interval = interval or self.rotate_interval
        self.auto_rotate = true
        self.rotate_interval = interval

        -- TODO: 实现自动轮播功能
        -- 由于wezterm的定时器API限制，此功能暂时禁用
        logger.info("background_switcher", "Auto rotate requested but not implemented yet")

        return false
    end,

    --- 停止自动轮播
    stop_auto_rotate = function(self)
        self.auto_rotate = false
        logger.info("background_switcher", "Auto rotate stopped")
    end,

    --- 切换自动轮播状态
    toggle_auto_rotate = function(self, interval)
        if self.auto_rotate then
            self:stop_auto_rotate()
        else
            self:start_auto_rotate(interval)
        end
    end,
}

--- 初始化背景切换器
--- @param config table 配置对象
function M.setup(config)
    BackgroundSwitcher:init()

    -- 设置初始背景
    local current_bg = BackgroundSwitcher:get_current_background()
    if current_bg then
        -- 直接应用当前背景，覆盖其他设置
        config.background = {
            {
                source = { File = { path = current_bg } },
                opacity = 1,
                hsb = {
                    brightness = 0.3,
                    saturation = 0.5,
                    hue = 1.0,
                },
            },
        }
        logger.info("background_switcher", "Applied background: " .. current_bg)
    end

    return config
end

--- 获取背景切换器实例
--- @return table 背景切换器实例
function M.get_switcher()
    -- 确保已初始化
    if not BackgroundSwitcher.initialized then
        BackgroundSwitcher:init()
    end
    return BackgroundSwitcher
end

--- 创建背景切换快捷键
--- @param config wezterm.Config 配置对象
--- @return wezterm.Config 配置对象
function M.create_keybindings(config)
    local wezterm = get_wezterm()
    if not wezterm then
        return config
    end

    -- 确保已初始化
    if not BackgroundSwitcher.initialized then
        BackgroundSwitcher:init()
    end

    -- 如果没有背景图片，不创建快捷键
    if #BackgroundSwitcher.backgrounds == 0 then
        return config
    end

    -- 切换到下一个背景 (Ctrl+Alt+B)
    table.insert(config.keys, {
        key = "b",
        mods = "CTRL|ALT",
        action = wezterm.action_callback(function()
            BackgroundSwitcher:next_background()
            wezterm.reload_configuration()
        end),
    })

    -- 切换到上一个背景 (Ctrl+Shift+Alt+B)
    table.insert(config.keys, {
        key = "b",
        mods = "CTRL|SHIFT|ALT",
        action = wezterm.action_callback(function()
            BackgroundSwitcher:prev_background()
            wezterm.reload_configuration()
        end),
    })

    -- 随机背景 (Ctrl+Alt+R)
    table.insert(config.keys, {
        key = "r",
        mods = "CTRL|ALT",
        action = wezterm.action_callback(function()
            BackgroundSwitcher:random_background()
            wezterm.reload_configuration()
        end),
    })

    -- 切换自动轮播 (Ctrl+Alt+T)
    table.insert(config.keys, {
        key = "t",
        mods = "CTRL|ALT",
        action = wezterm.action_callback(function(window)
            BackgroundSwitcher:toggle_auto_rotate()
            local status = BackgroundSwitcher.auto_rotate and "enabled" or "disabled"
            window:toast_notification("Background Switcher", "Auto rotate " .. status, nil, 4000)
        end),
    })

    return config
end

--- 显示背景列表命令面板
function M.show_background_list()
    local wezterm = get_wezterm()
    if not wezterm then
        return
    end

    local backgrounds = BackgroundSwitcher:get_backgrounds()
    local window = wezterm.mux.active_window()
    if not window then
        return
    end

    -- 构建选择项
    local items = {}
    for i, bg in ipairs(backgrounds) do
        local filename = bg:match("([^/]+)$")
        local current = (i == BackgroundSwitcher.current_index) and "✓ " or ""
        table.insert(items, {
            label = current .. filename,
            id = tostring(i),
        })
    end

    -- 显示选择器（需要launcher支持）
    -- 这里可以扩展为与launcher模块集成
end

return M
