-- 标签页标题格式化事件
-- 负责格式化标签页标题，显示进程名和工作目录
-- 显示格式: 进程名 ~ 目录名
-- 使用 package.loaded 避免循环引用

local M = {}

--- 格式化标签页标题
--- 显示格式: 进程名 ~ 目录名
--- @param tab_info TabInformation 标签页信息
--- @param _tabs table 所有标签页
--- @param _panes table 所有窗格
--- @param _conf table 配置
--- @return string 格式化后的标题
function M.format(tab_info, _tabs, _panes, _conf)
    -- 获取进程名（提取 basename）
    local process_name = tab_info.active_pane.foreground_process_name or "shell"
    process_name = process_name:match("([^/]+)$") or process_name

    -- 获取当前工作目录
    local cwd = tab_info.active_pane.current_working_dir
    local cwd_display = ""
    if cwd and cwd.file_path then
        local path = cwd.file_path
        cwd_display = path:match("([^/]+)$") or path
        if cwd_display == "" then
            cwd_display = "/"
        end
    end

    -- 组合标题: shell信息
    return process_name .. " ~ " .. cwd_display
end

--- 注册事件到 wezterm
function M.register()
    local wezterm = package.loaded["wezterm"]
    if not wezterm then return end

    wezterm.on("format-tab-title", M.format)
end

return M
