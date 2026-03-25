-- 平台检测模块
-- 提供平台判断和平台相关配置

local Platform = {
    type = nil,
    is_cached = false,
}

--- 检测平台类型
--- @return string 平台类型 (linux/macos/windows)
function Platform.detect()
    if Platform.is_cached then return Platform.type end

    local wezterm = package.loaded["wezterm"]
    if not wezterm then
        Platform.type = "unknown"
        Platform.is_cached = true
        return Platform.type
    end
    local triple = wezterm.target_triple or ""

    if triple:match("linux") then
        Platform.type = "linux"
    elseif triple:match("darwin") then
        Platform.type = "macos"
    elseif triple:match("windows") then
        Platform.type = "windows"
    else
        Platform.type = "unknown"
    end

    Platform.is_cached = true
    return Platform.type
end

--- 判断是否为 Linux
--- @return boolean
function Platform.is_linux()
    return Platform.detect() == "linux"
end

--- 判断是否为 macOS
--- @return boolean
function Platform.is_macos()
    return Platform.detect() == "macos"
end

--- 判断是否为 Windows
--- @return boolean
function Platform.is_windows()
    return Platform.detect() == "windows"
end

--- 获取平台相关的修饰键配置
--- @return table { SUPER, SUPER_REV }
function Platform.get_mod_keys()
    if Platform.is_macos() then
        return { SUPER = "SUPER", SUPER_REV = "SUPER|CTRL" }
    else
        return { SUPER = "ALT", SUPER_REV = "ALT|CTRL" }
    end
end

--- 获取平台相关的 Shell 路径
--- @return table { bash, zsh, fish }
function Platform.get_shell_paths()
    if Platform.is_macos() then
        return {
            bash = "/bin/bash",
            zsh = "/bin/zsh",
            fish = "/opt/homebrew/bin/fish",
        }
    else
        return {
            bash = "/bin/bash",
            zsh = "/usr/bin/zsh",
            fish = "/usr/bin/fish",
        }
    end
end

return Platform
