-- 性能优化配置
-- 提供启动优化、渲染优化、内存管理等性能相关配置

local wezterm = require("wezterm")
local core = require("ghost.core.init")

local M = {}

--- 应用启动优化配置
--- @param config wezterm.Config 配置对象
--- @param perf_config table 性能配置
--- @return wezterm.Config 配置对象
local function apply_startup_optimization(config, perf_config)
    if not perf_config or not perf_config.enable_startup_optimization then
        return config
    end

    -- 禁用启动动画
    if perf_config.disable_startup_animation ~= false then
        config.animation_fps = 1
    end

    -- 快速启动：跳过某些初始化检查
    if perf_config.fast_startup then
        config.skip_websocket_ping = true
        config.skip_close_confirmation_for_tabs_but_not_windows = true
    end

    return config
end

--- 应用渲染优化配置
--- @param config wezterm.Config 配置对象
--- @param perf_config table 性能配置
--- @return wezterm.Config 配置对象
local function apply_render_optimization(config, perf_config)
    if not perf_config or not perf_config.enable_render_optimization then
        return config
    end

    -- 限制FPS以节省资源
    config.animation_fps = perf_config.max_fps or 60

    -- 渲染性能优化
    if perf_config.prefer_egl then
        config.prefer_egl = true
    end

    -- 禁用某些渲染特性以提升性能
    if perf_config.disable_banded then
        config.disable_banded_tabs = true
    end

    -- 窗口调整行为
    if perf_config.front_end then
        config.front_end = perf_config.front_end  -- "OpenGL", "Software"
    end

    return config
end

--- 应用内存优化配置
--- @param config wezterm.Config 配置对象
--- @param perf_config table 性能配置
--- @return wezterm.Config 配置对象
local function apply_memory_optimization(config, perf_config)
    if not perf_config or not perf_config.enable_memory_optimization then
        return config
    end

    -- 限制回滚行数以减少内存使用
    if perf_config.max_scrollback_lines then
        config.scrollback_lines = perf_config.max_scrollback_lines
    end

    -- 定期清理缓存
    if perf_config.enable_cache_cleanup then
        -- 这里可以添加定期清理缓存的逻辑
        -- 例如：清理已关闭的标签页缓存
    end

    return config
end

--- 应用字体渲染优化
--- @param config wezterm.Config 配置对象
--- @param perf_config table 性能配置
--- @return wezterm.Config 配置对象
local function apply_font_optimization(config, perf_config)
    if not perf_config or not perf_config.enable_font_optimization then
        return config
    end

    -- HarfBuzz字体特性优化
    if perf_config.harfbuzz_features then
        config.harfbuzz_features = perf_config.harfbuzz_features
    else
        -- 默认启用基本特性以提升性能
        config.harfbuzz_features = { "calt" }
    end

    -- 字体渲染提示
    if perf_config.warn_about_missing_glyphs ~= nil then
        config.warn_about_missing_glyphs = perf_config.warn_about_missing_glyphs
    end

    return config
end

--- 应用网络优化配置
--- @param config wezterm.Config 配置对象
--- @param perf_config table 性能配置
--- @return wezterm.Config 配置对象
local function apply_network_optimization(config, perf_config)
    if not perf_config or not perf_config.enable_network_optimization then
        return config
    end

    -- WebSocket ping间隔
    if perf_config.websocket_ping_interval then
        config.websocket_ping_interval = perf_config.websocket_ping_interval
    end

    -- 连接超时
    if perf_config.connection_timeout then
        config.connection_timeout = perf_config.connection_timeout
    end

    return config
end

--- 应用性能配置
--- @param config wezterm.Config 配置对象
--- @param user_config table 用户配置
--- @return wezterm.Config 配置对象
function M.apply(config, user_config)
    local perf_config = user_config.performance or {}

    -- 应用各类性能优化
    config = apply_startup_optimization(config, perf_config)
    config = apply_render_optimization(config, perf_config)
    config = apply_memory_optimization(config, perf_config)
    config = apply_font_optimization(config, perf_config)
    config = apply_network_optimization(config, perf_config)

    return config
end

--- 性能分析工具
local PerformanceProfiler = {
    start_time = nil,

    --- 开始性能分析
    start = function(self)
        self.start_time = os.clock()
    end,

    --- 结束性能分析并返回结果
    --- @return number 执行时间(秒)
    stop = function(self)
        if self.start_time then
            local elapsed = os.clock() - self.start_time
            self.start_time = nil
            return elapsed
        end
        return 0
    end,
}

--- 获取性能报告
--- @return table 性能指标
function M.get_performance_report()
    local report = {
        config_dir = wezterm.config_dir,
        cache_dir = wezterm.cache_dir,
        -- TODO: 添加更多性能指标
    }

    return report
end

--- 清理缓存
--- @return boolean 是否成功
function M.clear_cache()
    local cache_dir = wezterm.cache_dir
    if not cache_dir then
        return false
    end

    -- TODO: 实现缓存清理逻辑
    -- 注意：这需要谨慎处理，避免删除重要文件

    return true
end

return M
