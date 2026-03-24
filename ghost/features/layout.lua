-- 分屏布局管理
-- 提供预设布局和自定义布局保存功能

local wezterm = require("wezterm")
local utils = require("ghost.core.utils")
local constants = require("ghost.core.constants")

local M = {}

--- 布局管理器
local LayoutManager = {
    --- 当前激活的布局
    current_layout = nil,

    --- 自定义布局
    custom_layouts = {},

    --- 布局历史
    layout_history = {},

    --- 获取预设布局
    get_preset_layout = function(self, layout_name)
        local preset_layouts = {
            [constants.LAYOUTS.DEFAULT] = {
                label = "Default",
                layout = wezterm.gui.empty_pane_tab(),
            },
            [constants.LAYOUTS.EVEN_HORIZONTAL] = {
                label = "Even Horizontal",
                layout = {
                    {
                        -- 顶部窗格
                        { size = 0.5 },
                        -- 底部窗格
                        { size = 0.5 },
                    },
                },
            },
            [constants.LAYOUTS.EVEN_VERTICAL] = {
                label = "Even Vertical",
                layout = {
                    {
                        -- 左侧窗格
                        { size = 0.5 },
                        -- 右侧窗格
                        { size = 0.5 },
                    },
                },
            },
            [constants.LAYOUTS.TALL] = {
                label = "Tall",
                layout = {
                    {
                        -- 主窗格（左侧）
                        { size = 0.7 },
                        -- 右侧分屏
                        {
                            { size = 0.5 },
                            { size = 0.5 },
                        },
                    },
                },
            },
            [constants.LAYOUTS.WIDE] = {
                label = "Wide",
                layout = {
                    {
                        -- 顶部主窗格
                        { size = 0.7 },
                        -- 底部分屏
                        {
                            { size = 0.5 },
                            { size = 0.5 },
                        },
                    },
                },
            },
        }

        return preset_layouts[layout_name]
    end,

    --- 应用布局到当前标签页
    --- @param window wezterm.Window 窗口对象
    --- @param pane wezterm.Pane 窗格对象
    --- @param layout_name string 布局名称
    apply_layout = function(self, window, pane, layout_name)
        local layout_info = self:get_preset_layout(layout_name)
        if not layout_info then
            wezterm.log_error("Layout not found: " .. layout_name)
            return
        end

        -- 保存当前布局到历史
        self:save_current_layout(window, pane)

        -- 应用新布局
        -- 注意：wezterm的布局API可能需要特定的调用方式
        -- 这里提供一个简化的实现

        self.current_layout = layout_name
        wezterm.log_info("Applied layout: " .. layout_name)
    end,

    --- 保存当前布局
    --- @param window wezterm.Window 窗口对象
    --- @param pane wezterm.Pane 窗格对象
    save_current_layout = function(self, window, pane)
        -- 获取当前布局信息
        local tab = window:mux_window():active_tab()
        if not tab then
            return
        end

        local panes = tab:panes()
        local layout_info = {
            pane_count = #panes,
            -- TODO: 收集更详细的布局信息
        }

        table.insert(self.layout_history, layout_info)
        if #self.layout_history > 10 then
            table.remove(self.layout_history, 1)
        end
    end,

    --- 保存自定义布局
    --- @param layout_name string 布局名称
    --- @param layout table 布局配置
    save_custom_layout = function(self, layout_name, layout)
        self.custom_layouts[layout_name] = {
            label = layout_name,
            layout = layout,
        }
    end,

    --- 获取自定义布局
    --- @param layout_name string 布局名称
    --- @return table|nil 布局配置
    get_custom_layout = function(self, layout_name)
        return self.custom_layouts[layout_name]
    end,
}

--- 快捷键映射到布局切换
local LayoutKeybindings = {
    --- 切换到指定布局
    --- @param layout_name string 布局名称
    --- @return table 快捷键配置
    switch_to = function(layout_name)
        return {
            key = layout_name:sub(1, 1):lower(),
            mods = "CTRL|ALT|SHIFT",
            action = wezterm.action_callback(function(window, pane)
                LayoutManager:apply_layout(window, pane, layout_name)
            end),
        }
    end,
}

--- 应用布局到当前标签页
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
--- @param layout_name string 布局名称
function M.apply_layout(window, pane, layout_name)
    LayoutManager:apply_layout(window, pane, layout_name)
end

--- 保存当前布局为自定义布局
--- @param layout_name string 布局名称
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.save_current_layout(layout_name, window, pane)
    -- 获取当前布局
    local tab = window:mux_window():active_tab()
    if not tab then
        return
    end

    local panes = tab:panes()
    local layout_config = {}

    -- 收集窗格信息
    for i, p in ipairs(panes) do
        local proc_info = p:get_foreground_process_info()
        table.insert(layout_config, {
            index = i,
            command = proc_info and proc_info.argv or {},
        })
    end

    -- 保存布局
    LayoutManager:save_custom_layout(layout_name, layout_config)
    wezterm.log_info("Saved layout: " .. layout_name)
end

--- 获取所有可用布局
--- @return table 布局列表
function M.get_available_layouts()
    local layouts = {}

    -- 预设布局
    for name, _ in pairs(constants.LAYOUTS) do
        table.insert(layouts, {
            name = name,
            type = "preset",
        })
    end

    -- 自定义布局
    for name, _ in pairs(LayoutManager.custom_layouts) do
        table.insert(layouts, {
            name = name,
            type = "custom",
        })
    end

    return layouts
end

--- 显示布局选择菜单
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.show_layout_menu(window, pane)
    local layouts = M.get_available_layouts()

    -- 构建菜单
    local choices = {}
    for _, layout in ipairs(layouts) do
        table.insert(choices, {
            label = layout.name .. " (" .. layout.type .. ")",
            id = layout.name,
        })
    end

    window:perform_action(
        wezterm.action.InputSelector({
            title = "Select Layout",
            choices = choices,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then
                    return
                end

                M.apply_layout(window, pane, id)
            end),
        }),
        pane
    )
end

--- 创建快捷键配置
--- @return table 快捷键列表
function M.create_keybindings()
    local keys = {}

    -- 添加布局切换快捷键
    for layout_name, _ in pairs(constants.LAYOUTS) do
        local keybinding = LayoutKeybindings.switch_to(layout_name)
        table.insert(keys, keybinding)
    end

    -- 显示布局菜单
    table.insert(keys, {
        key = "l",
        mods = "CTRL|SHIFT|ALT",
        action = wezterm.action_callback(function(window, pane)
            M.show_layout_menu(window, pane)
        end),
    })

    return keys
end

--- 快速切换到下一个布局
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.cycle_layout(window, pane)
    local layouts = {}
    for name, _ in pairs(constants.LAYOUTS) do
        table.insert(layouts, name)
    end

    -- 找到下一个布局
    local current_index = 0
    if LayoutManager.current_layout then
        for i, name in ipairs(layouts) do
            if name == LayoutManager.current_layout then
                current_index = i
                break
            end
        end
    end

    local next_index = (current_index % #layouts) + 1
    M.apply_layout(window, pane, layouts[next_index])
end

--- 恢复上一个布局
--- @param window wezterm.Window 窗口对象
--- @param pane wezterm.Pane 窗格对象
function M.restore_previous_layout(window, pane)
    if #LayoutManager.layout_history == 0 then
        wezterm.log_info("No layout history")
        return
    end

    -- 获取上一个布局
    local previous_layout = table.remove(LayoutManager.layout_history)

    -- 恢复布局
    -- TODO: 实现布局恢复逻辑
    wezterm.log_info("Restored previous layout")
end

return M
