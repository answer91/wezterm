# Wezterm配置库使用文档

## 快速开始

### 安装

1. 克隆或下载此配置库到您的配置目录：
```bash
# 备份现有配置（如果有）
mv ~/.wezterm.lua ~/.wezterm.lua.backup

# 复制配置文件
cp wezterm.lua ~/.wezterm.lua
cp -r ghost/ ~/.wezterm/ghost/
cp -r presets/ ~/.wezterm/presets/
cp -r pictures/ ~/.wezterm/pictures/
```

2. 重新启动Wezterm，配置将自动生效。

### 使用预设配置

配置库提供了三种预设配置，您可以根据需求选择：

- **default.lua**: 平衡的默认配置，适合日常使用
- **minimal.lua**: 极简配置，专注于性能
- **full_featured.lua**: 完整功能配置，包含所有特性

要使用预设配置，创建 `~/.wezterm/user_config.lua` 文件：

```lua
local presets = require("presets.full_featured")
return presets
```

## 配置结构

### 模块化架构

配置采用模块化架构，便于管理和扩展：

```
~/.wezterm/
├── wezterm.lua              # 主入口文件
├── ghost/                     # 核心模块
│   ├── core/               # 核心功能
│   ├── config/             # 配置模块
│   ├── features/           # 功能特性
│   ├── plugins/            # 插件系统
│   └── themes/             # 主题文件
├── presets/                # 预设配置
├── pictures/               # 背景图片
└── docs/                   # 文档
```

### 自定义配置

在 `~/.wezterm/user_config.lua` 中自定义配置：

```lua
-- 引入预设配置
local preset = require("presets.default")

-- 自定义配置
local custom = {
    appearance = {
        theme = "dracula",
        font = {
            font_family = "Your Favorite Font",
            font_size = 14.0,
        },
    },
    keybindings = {
        leader = {
            enabled = true,
            key = "a",
        },
    },
}

-- 合并配置
return require("ghost.core.init").merge_config(preset, custom)
```

## 核心功能

### 1. 外观配置

#### 主题切换

支持多个内置主题：

```lua
appearance = {
    theme = "tokyo_night",  -- 或 "dracula", "catppuccin"
}
```

#### 自定义颜色

```lua
appearance = {
    custom_colors = {
        background = "#1a1b26",
        foreground = "#c0caf5",
    },
}
```

#### 背景设置

支持图片背景和渐变背景：

```lua
appearance = {
    background = {
        enabled = true,
        type = "image",
        image_path = "background.png",  -- 放在pictures目录
        opacity = 0.8,
    },
}
```

### 2. 快捷键系统

#### Leader模式

启用类似Vim的Leader模式：

```lua
keybindings = {
    leader = {
        enabled = true,
        key = "Space",
        mods = "CTRL",
    },
}
```

#### 自定义快捷键

```lua
keybindings = {
    custom_keys = {
        {
            key = "e",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SpawnCommandInNewTab({
                args = { "vim" }
            }),
        },
    },
}
```

### 3. Shell集成

#### 自动Shell检测

```lua
shell = {
    enabled = true,
    -- 自动检测系统可用Shell
}
```

#### 项目特定Shell

```lua
shell = {
    projects = {
        {
            path = "/path/to/project",
            shell = "/bin/zsh",
        },
    },
}
```

### 4. 命令面板

快速启动常用命令：

- 快捷键：`Ctrl+Shift+P`
- 提供命令历史记录
- 模糊搜索功能

### 5. 状态栏

自定义状态栏显示：

- **左侧**：CPU、内存、电池
- **中间**：当前目录、Git分支、Shell类型
- **右侧**：时间、运行时间

### 6. 工作区管理

#### 保存工作区

```lua
-- 快捷键：Ctrl+Shift+Alt+S
local workspace = require("ghost.features.workspace")
workspace.quick_save(window)
```

#### 恢复工作区

```lua
-- 快捷键：Ctrl+Shift+Alt+W
workspace.restore_workspace("workspace_name", window)
```

### 7. 智能复制粘贴

自动识别：

- URL链接（提供快速打开）
- 文件路径（提供快速操作）
- 智能文本选择

## 插件系统

### 使用内置插件

```lua
plugins = {
    "smart_move",
    "url_highlight",
}
```

### 创建自定义插件

使用插件管理器创建模板：

```lua
local plugin_manager = require("ghost.plugins.init")
plugin_manager:create_plugin_template("my_plugin")
```

插件结构：

```lua
local M = {
    name = "my_plugin",
    version = "1.0.0",
    description = "Plugin description",
}

function M.setup(config)
    -- 初始化插件
end

function M.cleanup()
    -- 清理插件
end

M.hooks = {
    on_config_load = function(config)
        -- 配置加载时执行
    end,
}

return M
```

## 主题定制

### 创建自定义主题

在 `ghost/themes/` 目录下创建新主题文件：

```lua
local M = {
    name = "my_theme",
    description = "My custom theme",
    colors = {
        foreground = "#ffffff",
        background = "#000000",
        -- ... 其他颜色
    },
}

return M
```

### 使用自定义主题

```lua
appearance = {
    theme = "my_theme",
}
```

## 性能优化

### 性能配置选项

```lua
performance = {
    -- 启动优化
    enable_startup_optimization = true,
    fast_startup = true,

    -- 渲染优化
    max_fps = 60,

    -- 内存优化
    max_scrollback_lines = 10000,
}
```

### 针对不同场景的建议

**日常使用（default.lua）**：
- 平衡性能和功能
- 启用常用功能

**高性能要求（minimal.lua）**：
- 禁用所有非必要功能
- 最小化资源占用

**完整功能（full_featured.lua）**：
- 启用所有功能
- 适合演示和探索

## 故障排除

### 配置不生效

1. 检查配置文件语法：
```bash
wezterm verify-config
```

2. 查看Wezterm日志：
```bash
wezterm start -- log-level=debug
```

### 启动缓慢

1. 使用minimal预设
2. 禁用不必要的插件
3. 减少回滚行数
4. 禁用背景图片

### 快捷键冲突

1. 检查是否有重复的快捷键定义
2. 使用 `custom_keys` 覆盖默认快捷键

## 常见问题

**Q: 如何切换主题？**
A: 修改 `user_config.lua` 中的 `appearance.theme` 配置。

**Q: 如何添加背景图片？**
A: 将图片放在 `pictures/` 目录，然后在配置中引用。

**Q: 如何创建新插件？**
A: 使用插件管理器的 `create_plugin_template` 函数。

**Q: 如何提升启动速度？**
A: 使用minimal预设或启用性能优化选项。

## 进阶技巧

### 动态配置

根据不同环境使用不同配置：

```lua
local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")

if hostname == "work-pc" then
    return require("presets.work_config")
else
    return require("presets.home_config")
end
```

### 条件加载

根据时间或条件加载不同配置：

```lua
local hour = tonumber(os.date("%H"))

if hour >= 9 and hour < 18 then
    -- 工作时间配置
    config.appearance.theme = "tokyo_night"
else
    -- 休息时间配置
    config.appearance.theme = "dracula"
end
```

## 贡献指南

欢迎贡献新的主题、插件和改进建议！

1. Fork项目
2. 创建特性分支
3. 提交更改
4. 发起Pull Request

## 许可证

MIT License

## 联系方式

如有问题或建议，请提交Issue。
