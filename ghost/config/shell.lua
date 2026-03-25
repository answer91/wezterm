-- Shell集成配置
-- 提供自动Shell检测、项目切换Shell、环境变量管理功能
-- 使用 package.loaded 避免循环引用

local utils = require("ghost.utils.init")
local constants = require("ghost.constants.init")
local string_ops = require("ghost.utils.string")

--- 获取 wezterm（延迟加载，使用 package.loaded 避免循环引用）
local function get_wezterm()
    return package.loaded["wezterm"]
end

local M = {}

--- Shell管理器
local ShellManager = {
    --- 当前使用的Shell
    current_shell = nil,

    --- 按项目的Shell配置
    project_shells = {},

    --- 环境变量配置
    env_vars = {},

    --- 检测默认Shell
    detect_default_shell = function(self)
        if self.current_shell then
            return self.current_shell
        end

        -- 回退到系统默认
        self.current_shell = os.getenv("SHELL") or "/bin/bash"

        return self.current_shell
    end,

    --- 设置项目Shell
    --- @param project_path string 项目路径
    --- @param shell_path string Shell路径
    set_project_shell = function(self, project_path, shell_path)
        self.project_shells[project_path] = shell_path
    end,

    --- 获取项目Shell
    --- @param project_path string 项目路径
    --- @return string|nil Shell路径
    get_project_shell = function(self, project_path)
        return self.project_shells[project_path]
    end,

    --- 设置环境变量
    --- @param key string 变量名
    --- @param value string 变量值
    set_env = function(self, key, value)
        self.env_vars[key] = value
    end,

    --- 批量设置环境变量
    --- @param vars table 环境变量表
    set_env_batch = function(self, vars)
        for k, v in pairs(vars) do
            self.env_vars[k] = v
        end
    end,

    --- 获取环境变量
    --- @param key string 变量名
    --- @return string|nil 变量值
    get_env = function(self, key)
        return self.env_vars[key]
    end,

    --- 获取所有环境变量
    --- @return table 环境变量表
    get_all_env = function(self)
        return self.env_vars
    end,
}

--- 解析SSH配置文件
--- @param ssh_config_path string SSH配置文件路径
--- @return table SSH主机列表
local function parse_ssh_config(ssh_config_path)
    local hosts = {}
    local content = utils.read(ssh_config_path)

    if not content then
        return hosts
    end

    local current_host = nil
    for line in content:gmatch("[^\r\n]+") do
        -- 跳过注释和空行
        if not line:match("^#") and line:match("%S") then
            local key, value = line:match("^%s*(%w+)%s+(.+)$")

            if key and value then
                key = key:lower()
                value = value:gsub("^%s+", ""):gsub("%s+$", "")

                if key == "host" then
                    current_host = { hostname = value, aliases = {} }
                    table.insert(hosts, current_host)
                elseif current_host and key == "hostname" then
                    current_host.hostname = value
                elseif current_host and key == "user" then
                    current_host.user = value
                elseif current_host and key == "port" then
                    current_host.port = value
                elseif current_host and key == "identityfile" then
                    current_host.identity_file = value
                end
            end
        end
    end

    return hosts
end

--- 应用Shell配置
--- @param config wezterm.Config 配置对象
--- @param shell_config table Shell配置
--- @return wezterm.Config 配置对象
local function apply_shell_config(config, shell_config)
    local wezterm = get_wezterm()

    -- 检测或使用指定的Shell
    local shell_path
    if shell_config and shell_config.default_shell then
        shell_path = shell_config.default_shell
    elseif shell_config and shell_config.enabled == false then
        -- 用户明确禁用Shell配置，使用系统默认
        return config
    else
        -- 默认使用 fish
        shell_path = constants.SHELLS.fish or "/usr/local/bin/fish"
    end

    -- 验证 Shell 是否存在
    if utils.exists(shell_path) then
        config.default_prog = { shell_path }
    else
        -- Fish 不存在，回退到系统默认
        if wezterm then
            wezterm.log_info("Fish shell not found at " .. shell_path .. ", using system default")
        end
    end

    -- 设置环境变量
    if shell_config and shell_config.env_vars then
        ShellManager:set_env_batch(shell_config.env_vars)
        config.set_environment_variables = ShellManager:get_all_env()
    end

    return config
end

--- 应用项目相关配置
--- @param config wezterm.Config 配置对象
--- @param project_config table 项目配置
--- @return wezterm.Config 配置对象
local function apply_project_config(config, project_config)
    if not project_config or #project_config == 0 then
        return config
    end

    -- 注册项目特定的Shell配置
    for _, proj in ipairs(project_config) do
        if proj.path and proj.shell then
            ShellManager:set_project_shell(proj.path, proj.shell)
        end
    end

    -- TODO: 添加项目切换检测逻辑
    -- 这需要监听目录变化事件

    return config
end

--- 应用SSH配置
--- @param config wezterm.Config 配置对象
--- @param ssh_config table SSH配置
--- @return wezterm.Config 配置对象
local function apply_ssh_config(config, ssh_config)
    if not ssh_config or not ssh_config.enabled then
        return config
    end

    -- 解析SSH配置文件
    local ssh_config_path = ssh_config.config_path or constants.PATHS.SSH_CONFIG
    local hosts = parse_ssh_config(ssh_config_path)

    -- 保存SSH主机列表供快速启动使用
    config.ssh_hosts = hosts

    return config
end

--- 应用Shell集成配置
--- @param config wezterm.Config 配置对象
--- @param user_config table 用户配置
--- @return wezterm.Config 配置对象
function M.apply(config, user_config)
    local shell_config = user_config.shell or {}

    -- 应用基础Shell配置
    config = apply_shell_config(config, shell_config)

    -- 应用项目配置
    if shell_config.projects then
        config = apply_project_config(config, shell_config.projects)
    end

    -- 应用SSH配置
    local ssh_config = user_config.ssh or {}
    if ssh_config.enabled then
        config = apply_ssh_config(config, ssh_config)
    end

    return config
end

--- 根据工作目录获取Shell
--- @param cwd string 当前工作目录
--- @return string Shell路径
function M.get_shell_for_cwd(cwd)
    -- 检查是否有项目特定的Shell
    for project_path, shell_path in pairs(ShellManager.project_shells) do
        if string_ops.starts_with(cwd, project_path) then
            return shell_path
        end
    end

    -- 返回默认Shell
    return ShellManager:detect_default_shell()
end

--- 获取SSH主机列表
--- @return table SSH主机列表
function M.get_ssh_hosts()
    -- 这个函数可以用于命令面板显示SSH主机列表
    local ssh_config_path = constants.PATHS.SSH_CONFIG
    return parse_ssh_config(ssh_config_path)
end

--- 快速连接SSH
--- @param host string 主机名或别名
--- @return string SSH命令
function M.get_ssh_command(host)
    local hosts = M.get_ssh_hosts()

    -- 查找主机配置
    for _, h in ipairs(hosts) do
        if h.hostname == host then
            if h.user then
                return string.format("ssh %s@%s", h.user, h.hostname)
            else
                return string.format("ssh %s", h.hostname)
            end
        end
    end

    -- 简单的SSH连接
    return string.format("ssh %s", host)
end

return M
