-- 常量统一入口
-- 保持向后兼容

local base = require("ghost.constants.base")
local themes = require("ghost.constants.themes")
local keybindings = require("ghost.constants.keybindings")

local M = {}

--- 直接暴露常用常量
M.VERSION = base.VERSION
M.OS = base.OS
M.DEFAULT_CONFIG = base.DEFAULT_CONFIG
M.DEFAULT_BACKGROUND = base.DEFAULT_BACKGROUND
M.LAYOUTS = base.LAYOUTS
M.STATUSBAR = base.STATUSBAR
M.PLUGIN_HOOKS = base.PLUGIN_HOOKS
M.SHELLS = base.SHELLS
M.PATHS = base.PATHS

--- 主题相关
M.THEMES = themes
M.get_theme = themes.get

--- 快捷键相关（延迟加载）
function M:get_keybindings()
    return keybindings.get_defaults()
end

function M:get_leader()
    return keybindings.get_leader()
end

function M:get_key_tables()
    return keybindings.get_key_tables()
end

function M:get_mouse_bindings()
    return keybindings.get_mouse_bindings()
end

--- 向后兼容的直接访问（通过 metatable）
setmetatable(M, {
    __index = function(_, key)
        if key == "THEMES" then return themes end
        if key == "DEFAULT_KEYBINDINGS" then return keybindings.get_defaults() end
        if key == "LEADER_CONFIG" then return keybindings.get_leader() end
        if key == "KEY_TABLES" then return keybindings.get_key_tables() end
        if key == "MOUSE_BINDINGS" then return keybindings.get_mouse_bindings() end
        if key == "FONTS" then
            return {"JetBrains Mono", "Fira Code", "Consolas", "Source Code Pro", "Monaco",
                    "Sarasa Gothic SC", "Noto Sans CJK SC", "Microsoft YaHei", "PingFang SC"}
        end
        if key == "SHELLS" then
            return {zsh = "/usr/bin/zsh", bash = "/bin/bash", fish = "/usr/bin/fish"}
        end
        return base[key]
    end
})

return M
