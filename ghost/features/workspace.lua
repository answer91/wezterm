-- 工作区管理
-- 提供会话保存/恢复、项目切换、自动保存等功能

local wezterm = require("wezterm")
local utils = require("ghost.core.utils")

local M = {}

--- 工作区管理器
local WorkspaceManager = {
    --- 当前工作区
    current_workspace = nil,

    --- 已保存的工作区
    workspaces = {},

    --- 工作区配置文件路径
    config_file = wezterm.config_dir .. "/workspace_state.json",

    --- 自动保存间隔（秒）
    auto_save_interval = 60,

    --- 最后自动保存时间
    last_auto_save = 0,

    --- 初始化工作区管理器
    init = function(self)
        self:load_workspaces()
    end,

    --- 加载工作区配置
    load_workspaces = function(self)
        if not utils.file_exists(self.config_file) then
            return
        end

        local content = utils.read_file(self.config_file)
        if not content then
            return
        end

        local success, data = pcall(wezterm.json_decode, content)
        if success and type(data) == "table" then
            self.workspaces = data.workspaces or {}
        end
    end,

    --- 保存工作区配置
    save_workspaces = function(self)
        local data = {
            workspaces = self.workspaces,
            last_modified = os.time(),
        }

        local content = wezterm.json_encode(data)
        local file = io.open(self.config_file, "w")
        if file then
            file:write(content)
            file:close()
        end
    end,

    --- 保存当前工作区
    --- @param workspace_name string 工作区名称
    --- @param window wezterm.Window 窗口对象
    save_current_workspace = function(self, workspace_name, window)
        local workspace = self:capture_workspace(workspace_name, window)
        if workspace then
            self.workspaces[workspace_name] = workspace
            self:save_workspaces()
            self.current_workspace = workspace_name
            wezterm.log_info("Workspace saved: " .. workspace_name)
        end
    end,

    --- 捕获当前工作区状态
    --- @param workspace_name string 工作区名称
    --- @param window wezterm.Window 窗口对象
    --- @return table|nil 工作区数据
    capture_workspace = function(self, workspace_name, window)
        local mux_window = window:mux_window()
        if not mux_window then
            return nil
        end

        local workspace_data = {
            name = workspace_name,
            timestamp = os.time(),
            tabs = {},
        }

        -- 收集所有标签页信息
        local tabs = mux_window:tabs()
        for _, tab in ipairs(tabs) do
            local tab_data = {
                panes = {},
            }

            -- 收集窗格信息
            local panes = tab:panes()
            for _, pane in ipairs(panes) do
                local pane_data = {
                    cwd = pane:get_current_working_dir(),
                    command = pane:get_foreground_process_info(),
                }
                table.insert(tab_data.panes, pane_data)
            end

            table.insert(workspace_data.tabs, tab_data)
        end

        return workspace_data
    end,

    --- 恢复工作区
    --- @param workspace_name string 工作区名称
    --- @param window wezterm.Window 窗口对象
    restore_workspace = function(self, workspace_name, window)
        local workspace = self.workspaces[workspace_name]
        if not workspace then
            wezterm.log_error("Workspace not found: " .. workspace_name)
            return
        end

        self.current_workspace = workspace_name

        -- 关闭当前所有标签页
        -- 注意：这可能会有破坏性，需要确认
        -- local mux_window = window:mux_window()
        -- for _, tab in ipairs(mux_window:tabs()) do
        --     tab:close()
        -- end

        -- 恢复标签页和窗格
        for _, tab_data in ipairs(workspace.tabs) do
            -- 创建新标签页
            window:perform_action(wezterm.action.SpawnTab("CurrentPaneDomain"), window:active_pane())

            -- 恢复窗格（简化版本）
            -- TODO: 完整实现窗格恢复逻辑
        end

        wezterm.log_info("Workspace restored: " .. workspace_name)
    end,

    --- 列出所有工作区
    --- @return table 工作区列表
    list_workspaces = function(self)
        local list = {}
        for name, workspace in pairs(self.workspaces) do
            table.insert(list, {
                name = name,
                timestamp = workspace.timestamp,
            })
        end
        return list
    end,

    --- 删除工作区
    --- @param workspace_name string 工作区名称
    delete_workspace = function(self, workspace_name)
        if self.workspaces[workspace_name] then
            self.workspaces[workspace_name] = nil
            self:save_workspaces()
            wezterm.log_info("Workspace deleted: " .. workspace_name)
            return true
        end
        return false
    end,

    --- 自动保存工作区
    --- @param window wezterm.Window 窗口对象
    auto_save = function(self, window)
        local current_time = os.time()
        if current_time - self.last_auto_save >= self.auto_save_interval then
            if self.current_workspace then
                self:save_current_workspace(self.current_workspace, window)
                self.last_auto_save = current_time
            end
        end
    end,
}

--- 项目管理器
local ProjectManager = {
    --- 项目配置
    projects = {},

    --- 项目配置文件路径
    config_file = wezterm.config_dir .. "/projects.json",

    --- 加载项目配置
    load_projects = function(self)
        if not utils.file_exists(self.config_file) then
            return
        end

        local content = utils.read_file(self.config_file)
        if not content then
            return
        end

        local success, data = pcall(wezterm.json_decode, content)
        if success and type(data) == "table" then
            self.projects = data.projects or {}
        end
    end,

    --- 保存项目配置
    save_projects = function(self)
        local data = {
            projects = self.projects,
        }

        local content = wezterm.json_encode(data)
        local file = io.open(self.config_file, "w")
        if file then
            file:write(content)
            file:close()
        end
    end,

    --- 添加项目
    --- @param project_name string 项目名称
    --- @param project_path string 项目路径
    --- @param workspace_name string 关联的工作区名称
    add_project = function(self, project_name, project_path, workspace_name)
        self.projects[project_name] = {
            path = project_path,
            workspace = workspace_name,
            timestamp = os.time(),
        }
        self:save_projects()
    end,

    --- 获取项目路径
    --- @param project_name string 项目名称
    --- @return string|nil 项目路径
    get_project_path = function(self, project_name)
        local project = self.projects[project_name]
        return project and project.path or nil
    end,
}

--- 初始化工作区管理
function M.init()
    WorkspaceManager:init()
    ProjectManager:load_projects()
end

--- 保存当前工作区
--- @param workspace_name string 工作区名称
--- @param window wezterm.Window 窗口对象
function M.save_workspace(workspace_name, window)
    WorkspaceManager:save_current_workspace(workspace_name, window)
end

--- 恢复工作区
--- @param workspace_name string 工作区名称
--- @param window wezterm.Window 窗口对象
function M.restore_workspace(workspace_name, window)
    WorkspaceManager:restore_workspace(workspace_name, window)
end

--- 显示工作区列表
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_workspace_list(window, pane)
    local workspaces = WorkspaceManager:list_workspaces()

    if #workspaces == 0 then
        wezterm.log_info("No saved workspaces")
        return
    end

    -- 构建菜单
    local choices = {}
    for _, ws in ipairs(workspaces) do
        local time_str = os.date("%Y-%m-%d %H:%M", ws.timestamp)
        table.insert(choices, {
            label = ws.name .. " (" .. time_str .. ")",
            id = ws.name,
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Select Workspace",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                M.restore_workspace(id, window)
            end),
        }),
        pane
    )
end

--- 删除工作区
--- @param workspace_name string 工作区名称
function M.delete_workspace(workspace_name)
    WorkspaceManager:delete_workspace(workspace_name)
end

--- 快速保存当前工作区
--- @param window wezterm.Window 窗口对象
function M.quick_save(window)
    local workspace_name = "auto_save_" .. os.date("%Y%m%d_%H%M%S")
    M.save_workspace(workspace_name, window)
end

--- 自动保存工作区
--- @param window wezterm.Window 窗口对象
function M.on_window_create(window, pane)
    -- 检查是否应该自动恢复工作区
    -- 这里可以实现自动恢复逻辑
end

--- 设置自动保存间隔
--- @param interval_seconds number 间隔（秒）
function M.set_auto_save_interval(interval_seconds)
    WorkspaceManager.auto_save_interval = interval_seconds
end

--- 添加项目
--- @param project_name string 项目名称
--- @param project_path string 项目路径
function M.add_project(project_name, project_path)
    local workspace_name = "project_" .. project_name
    ProjectManager:add_project(project_name, project_path, workspace_name)
    wezterm.log_info("Project added: " .. project_name)
end

--- 切换到项目
--- @param project_name string 项目名称
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.switch_to_project(project_name, window, pane)
    local project_path = ProjectManager:get_project_path(project_name)
    if not project_path then
        wezterm.log_error("Project not found: " .. project_name)
        return
    end

    -- cd到项目目录
    pane:send_text("cd " .. project_path .. "\n")

    -- 尝试恢复关联的工作区
    local project = ProjectManager.projects[project_name]
    if project and project.workspace then
        M.restore_workspace(project.workspace, window)
    end

    wezterm.log_info("Switched to project: " .. project_name)
end

--- 显示项目列表
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_project_list(window, pane)
    local choices = {}
    for name, _ in pairs(ProjectManager.projects) do
        table.insert(choices, {
            label = name,
            id = name,
        })
    end

    if #choices == 0 then
        wezterm.log_info("No projects configured")
        return
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Select Project",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                M.switch_to_project(id, window, pane)
            end),
        }),
        pane
    )
end

return M
