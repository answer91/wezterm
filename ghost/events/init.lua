-- 事件管理器
-- 负责自动发现和注册所有事件模块

local logger = require("ghost.core.logger")
local module = require("ghost.core.module")

local EventManager = {
    events = {},
    auto_discovery = true,
    event_files = {
        "format_tab_title",
        "right_status",
        "window_maximize",
    },
}

--- 注册事件
function EventManager:register(name, event_module)
    self.events[name] = event_module
    logger.debug("events", "Registered event: " .. name)
end

--- 自动发现并注册所有事件
function EventManager:auto_discover_events()
    for _, name in ipairs(self.event_files) do
        local ok, event_module = pcall(require, "ghost.events." .. name)
        if ok and type(event_module) == "table" and event_module.register then
            self:register(name, event_module)
        else
            logger.warn("events", "Failed to load event: " .. name)
        end
    end
end

--- 注册所有事件
function EventManager:register_all()
    logger.info("events", "Registering all events...")

    if self.auto_discovery then
        self:auto_discover_events()
    end

    for name, event_module in pairs(self.events) do
        if event_module.register then
            local ok, err = pcall(event_module.register)
            if ok then
                logger.debug("events", "Event registered: " .. name)
            else
                logger.error("events", "Failed to register event: " .. name .. ", " .. tostring(err))
            end
        end
    end

    logger.info("events", "Registered " .. #self.event_files .. " events")
end

return EventManager
