# Wezterm模块化配置库

> 一个功能全面、架构清晰的Wezterm终端配置库，支持模块化配置、丰富的主题和插件系统。

## 特性

- **🎨 丰富的主题** - 内置Tokyo Night、Dracula、Catppuccin等多个高质量主题
- **⌨️ 强大的快捷键系统** - 支持Leader模式、窗格调整模式、窗格激活模式等
- **🐚 Shell集成** - 自动检测和配置Shell，支持项目特定Shell配置，默认使用fish
- **🔧 模块化架构** - 清晰的代码结构，配置模块、事件系统分离，易于维护和扩展
- **🔌 插件系统** - 支持自定义插件和扩展，内置Smart Move、URL Highlight等插件
- **💡 智能功能** - 命令面板、智能复制粘贴、URL识别、布局管理
- **📊 自定义状态栏** - 右侧状态栏显示系统信息，标签页标题格式化
- **🚀 性能优化** - 启动优化、渲染优化、内存优化，快速启动
- **🖼️ 背景支持** - 图片背景、透明度设置、毛玻璃效果
- **🪟 窗口管理** - 窗口最大化、窗口装饰自定义、滚动条配置

## 快速开始

### 安装

```bash
# 1. 将配置放置到目标位置
# 假设配置目录为 /path/to/wezterm
cd /path/to/wezterm

# 2. 配置会自动加载，无需额外操作
# 主配置文件：wezterm.lua
# 模块目录：ghost/
# 预设配置：presets/
# 背景图片：pictures/

# 3. 如需自定义配置，可以在 wezterm.lua 中修改模块加载参数
```

### 当前配置方式

```lua
-- wezterm.lua 主配置文件采用模块化架构
local config = wezterm.config_builder()

-- 应用默认配置
config.automatically_reload_config = true
config.check_for_updates = false
config.scrollback_lines = 10000
config.use_ime = true

-- 延迟加载并应用模块
local function apply_modules()
    -- 外观配置（主题、字体、窗口等）
    local ok, appearance = pcall(require, "ghost.config.appearance")
    if ok and appearance then
        config = appearance.apply(config, {})
    end

    -- 快捷键配置（Leader模式、窗格管理等）
    ok, keybindings = pcall(require, "ghost.config.keybindings")
    if ok and keybindings then
        config = keybindings.apply(config, {})
    end

    -- Shell配置（默认fish，支持项目特定配置）
    ok, shell = pcall(require, "ghost.config.shell")
    if ok and shell then
        config = shell.apply(config, {})
    end

    return config
end
```

## 配置示例

### 模块配置（当前推荐）

在 `wezterm.lua` 的模块加载时传递配置参数：

```lua
-- 外观配置
ok, appearance = pcall(require, "ghost.config.appearance")
if ok and appearance then
    config = appearance.apply(config, {
        theme = "tokyo_night",
        font = {
            font_family = "JetBrains Mono",
            font_size = 11.0,
        },
    })
end

-- 快捷键配置
ok, keybindings = pcall(require, "ghost.config.keybindings")
if ok and keybindings then
    config = keybindings.apply(config, {
        leader = {
            enabled = true,
            key = "Space",
            mods = "CTRL",
        },
    })
end

-- Shell配置
ok, shell = pcall(require, "ghost.config.shell")
if ok and shell then
    config = shell.apply(config, {
        enabled = true,
        env_vars = {
            EDITOR = "vim",
        },
    })
end
```

### 预设配置参考

`presets/` 目录提供了完整的配置示例，可以参考这些文件来了解所有可配置选项：

- `presets/default.lua` - 推荐的平衡配置
- `presets/minimal.lua` - 极简配置
- `presets/full_featured.lua` - 完整功能配置

### 完整配置文档

参见 [docs/configuration.md](docs/configuration.md) 获取详细配置说明。

## 预设配置

### Default（推荐）

平衡的配置，适合日常使用：
- Tokyo Night主题
- 常用快捷键
- 基础状态栏

### Minimal

极简配置，专注性能：
- 无背景图片
- 最小快捷键
- 最快启动速度

### Full Featured

完整功能配置：
- 所有功能启用
- 丰富快捷键
- 完整状态栏

## 项目结构

```
wezterm/
├── wezterm.lua              # 主入口文件（模块化配置架构）
├── ghost/
│   ├── core/               # 核心模块
│   │   ├── init.lua       # 模块初始化
│   │   ├── utils.lua      # 工具函数
│   │   ├── logger.lua     # 日志系统
│   │   ├── platform.lua   # 平台检测
│   │   ├── module.lua     # 模块管理
│   │   └── config.lua     # 配置处理
│   ├── config/             # 配置模块
│   │   ├── appearance.lua  # 外观配置（主题、字体、窗口）
│   │   ├── keybindings.lua # 快捷键系统（Leader、窗格管理）
│   │   ├── shell.lua       # Shell集成（默认fish、项目配置）
│   │   └── performance.lua # 性能优化
│   ├── constants/          # 常量定义
│   │   ├── init.lua       # 常量入口
│   │   ├── base.lua       # 基础常量
│   │   ├── themes.lua     # 主题常量
│   │   └── keybindings.lua # 快捷键常量
│   ├── events/             # 事件系统
│   │   ├── init.lua       # 事件管理器
│   │   ├── right_status.lua  # 右侧状态栏
│   │   ├── window_maximize.lua # 窗口最大化
│   │   └── format_tab_title.lua # 标签页标题
│   ├── features/           # 功能特性
│   │   ├── launcher.lua    # 命令面板
│   │   ├── statusbar.lua   # 状态栏组件
│   │   ├── smart_copy.lua  # 智能复制
│   │   ├── layout.lua      # 布局管理
│   │   └── workspace.lua   # 工作区管理
│   ├── utils/              # 工具函数
│   │   ├── init.lua       # 工具入口
│   │   ├── table.lua      # 表操作工具
│   │   └── string.lua     # 字符串工具
│   ├── plugins/            # 插件系统
│   │   ├── init.lua       # 插件管理器
│   │   └── examples/      # 示例插件
│   │       ├── smart_move.lua   # Vim风格移动
│   │       └── url_highlight.lua # URL识别
│   └── themes/             # 主题文件
│       ├── tokyo_night.lua
│       ├── dracula.lua
│       └── catppuccin.lua
├── presets/                # 预设配置
│   ├── default.lua        # 默认推荐配置
│   ├── minimal.lua        # 极简配置
│   └── full_featured.lua  # 完整功能配置
├── pictures/               # 背景图片
├── docs/                   # 文档
│   ├── configuration.md   # 配置文档
│   └── plans/             # 设计文档
└── doc/                    # 其他文档
```

## 功能说明

### Shell配置

- **默认Shell**：自动使用fish作为默认shell
- **Shell检测**：自动检测系统可用shell，支持fish、zsh、bash
- **项目Shell**：支持为不同项目配置不同的shell
- **环境变量**：支持设置和管理环境变量
- **SSH集成**：解析SSH配置文件，支持快速SSH连接

### 外观配置

- **主题切换**：内置Tokyo Night、Dracula、Catppuccin等高质量主题
- **字体配置**：支持字体族、字重、样式、大小、行高
- **背景效果**：图片背景、透明度、毛玻璃效果
- **窗口装饰**：内边距、滚动条、标签栏样式、窗口装饰
- **光标样式**：多种光标样式和闪烁频率配置

### 快捷键系统

- **Leader模式**：类似Vim的前缀键模式（默认Ctrl+Space）
- **窗格调整模式**：快速调整窗格大小
- **窗格激活模式**：在窗格间快速切换
- **多模式支持**：正常模式、窗格模式、自定义模式
- **自定义绑定**：完全可自定义，支持覆盖默认快捷键
- **键表管理**：支持多个键表组合和去重

### 命令面板

- **快速启动**：常用命令一键执行
- **命令历史**：保存和搜索历史命令
- **模糊搜索**：快速查找命令和文件
- **自定义命令**：支持添加自定义命令

### 状态栏和窗口管理

- **右侧状态栏**：显示系统信息、时间等
- **标签页标题**：智能格式化标签页标题
- **窗口最大化**：支持窗口启动时自动最大化
- **窗口装饰**：自定义窗口装饰和标题栏

### 布局和工作区管理

- **布局保存**：保存和管理窗格布局
- **工作区管理**：创建、切换、删除工作区
- **项目组织**：按项目组织工作区和配置
- **自动保存**：定时保存工作状态
- **会话恢复**：快速恢复之前的工作状态

### 智能复制和粘贴

- **智能复制**：智能选择和复制文本
- **URL识别**：自动识别和打开URL
- **复制模式**：类似Vim的复制模式
- **复制到剪贴板**：支持多种复制方式

### 性能优化

- **启动优化**：延迟加载模块、快速启动
- **渲染优化**：帧率控制、渲染后端选择
- **内存优化**：回退行数限制、内存使用优化
- **字体优化**：字体缓存和优化
- **网络优化**：SSH连接优化（可选）

## 插件系统

### 插件管理

- **统一加载**：统一的插件管理系统
- **事件驱动**：基于Hook的事件系统
- **易于扩展**：简单的插件API

### 内置插件

#### Smart Move

Vim风格的光标移动功能：
- 普通模式、插入模式切换
- h/j/k/l 移动
- 模式指示器
- 快速导航

#### URL Highlight

URL自动识别和快速打开：
- 自动高亮URL
- 快捷键打开链接
- 多URL选择和支持

## 开发

### 创建新主题

```lua
-- ghost/themes/my_theme.lua
local M = {
    name = "my_theme",
    colors = {
        foreground = "#ffffff",
        background = "#000000",
        -- ...
    },
}
return M
```

### 创建新插件

```lua
-- ghost/plugins/examples/my_plugin.lua
local M = {
    name = "my_plugin",
    version = "1.0.0",
}

function M.setup(config)
    -- 初始化
end

M.hooks = {
    on_config_load = function(config)
        -- Hook
    end,
}

return M
```

## 文档

- [配置文档](docs/configuration.md) - 详细配置说明
- [设计文档](docs/plans/2025-03-21-wezterm-configuration-design.md) - 架构设计和理念
- [代码示例](presets/) - 参考预设配置了解使用方法

## 当前配置亮点

- ✅ **默认使用Fish Shell**：开箱即用的现代化shell体验
- ✅ **模块化架构**：配置、事件、工具分离，代码清晰
- ✅ **完整的事件系统**：状态栏、窗口管理、标签页格式化
- ✅ **性能优化**：启动优化、渲染优化、内存优化
- ✅ **丰富的主题**：三个内置高质量主题
- ✅ **强大的快捷键**：Leader模式、多模式快捷键系统
- ✅ **Shell集成**：支持项目特定shell配置和环境变量管理

## 贡献

欢迎贡献！请随时提交Pull Request。

1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 许可证

本项目采用MIT许可证 - 详见 [LICENSE](LICENSE) 文件

## 致谢

- [Wezterm](https://wezfurlong.org/wezterm/) - 强大的终端模拟器
- 所有贡献者

## 联系方式

- 提交Issue反馈问题
- Pull Request贡献代码
- Star支持项目

---

**享受你的Wezterm配置体验！** 🚀
