# Wezterm模块化配置库

> 一个功能全面、架构清晰的Wezterm终端配置库，支持模块化配置、丰富的主题和插件系统。

## 特性

- **🎨 丰富的主题** - 内置Tokyo Night、Dracula、Catppuccin等多个主题
- **⌨️ 强大的快捷键系统** - 支持Leader模式、多模式快捷键
- **🔧 模块化架构** - 清晰的代码结构，易于维护和扩展
- **🔌 插件系统** - 支持自定义插件和扩展
- **💡 智能功能** - 命令面板、智能复制粘贴、URL识别
- **📊 自定义状态栏** - 显示系统信息、Git分支等
- **🚀 性能优化** - 懒加载、缓存机制，快速启动
- **🌈 背景支持** - 图片背景、渐变背景、透明度设置

## 快速开始

### 安装

```bash
# 1. 克隆仓库
git clone https://github.com/yourusername/wezterm-config.git ~/.wezterm

# 2. 复制配置文件
cd ~/.wezterm
cp wezterm.lua ~/.wezterm.lua

# 3. 重启Wezterm
```

### 使用预设配置

```lua
-- 在 ~/.wezterm.lua 中
local preset = require("presets.default")
return preset
```

## 配置示例

### 基础配置

```lua
return {
    appearance = {
        theme = "tokyo_night",
        font = {
            font_family = "JetBrains Mono",
            font_size = 11.0,
        },
    },
    keybindings = {
        leader = {
            enabled = true,
            key = "Space",
            mods = "CTRL",
        },
    },
}
```

### 完整配置

参见 [docs/configuration.md](docs/configuration.md) 获取完整配置文档。

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
├── wezterm.lua              # 主入口文件
├── ghost/
│   ├── core/               # 核心模块
│   │   ├── init.lua       # 模块加载器
│   │   ├── utils.lua      # 工具函数
│   │   └── constants.lua  # 常量定义
│   ├── config/             # 配置模块
│   │   ├── appearance.lua  # 外观配置
│   │   ├── keybindings.lua # 快捷键系统
│   │   ├── shell.lua       # Shell集成
│   │   └── performance.lua # 性能优化
│   ├── features/           # 功能特性
│   │   ├── launcher.lua    # 命令面板
│   │   ├── statusbar.lua   # 状态栏
│   │   ├── smart_copy.lua  # 智能复制
│   │   ├── layout.lua      # 布局管理
│   │   └── workspace.lua   # 工作区管理
│   ├── plugins/            # 插件系统
│   │   ├── init.lua       # 插件管理器
│   │   └── examples/      # 示例插件
│   └── themes/             # 主题文件
├── presets/                # 预设配置
├── pictures/               # 背景图片
└── docs/                   # 文档
```

## 功能说明

### 外观配置

- **主题切换**：内置多个高质量主题
- **字体配置**：支持字体族、字重、大小
- **背景效果**：图片、渐变、透明度
- **窗口装饰**：内边距、滚动条、标签栏

### 快捷键系统

- **Leader模式**：类似Vim的前缀键模式
- **多模式支持**：正常模式、窗格模式等
- **自定义绑定**：完全可自定义

### 命令面板

- **快速启动**：常用命令一键执行
- **命令历史**：保存和搜索历史命令
- **模糊搜索**：快速查找命令

### 状态栏

- **系统信息**：CPU、内存、电池
- **上下文信息**：目录、Git分支、Shell
- **时间显示**：当前时间、运行时间

### 工作区管理

- **会话保存**：保存和恢复工作区
- **项目管理**：按项目组织工作区
- **自动保存**：定时保存工作状态

### 插件系统

- **插件加载**：统一的插件管理
- **Hook系统**：事件驱动扩展
- **模板生成**：快速创建插件

## 内置插件

### Smart Move

Vim风格的光标移动功能：
- 普通模式、插入模式
- h/j/k/l 移动
- 模式指示器

### URL Highlight

URL自动识别和快速打开：
- 自动高亮URL
- 快捷键打开
- 多URL选择

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
- [设计文档](docs/plans/2025-03-21-wezterm-configuration-design.md) - 架构设计

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
