# Wezterm配置库设计方案

**日期**: 2025-03-21
**设计师**: Claude
**目标**: 创建一个功能全面、架构清晰的wezterm配置库

## 1. 整体架构

### 目录结构

```
wezterm/
├── wezterm.lua                    # 主入口文件
├── lua/
│   ├── core/                      # 核心功能模块
│   │   ├── init.lua              # 模块加载器
│   │   ├── utils.lua             # 工具函数
│   │   └── constants.lua         # 常量定义
│   ├── config/                    # 配置模块
│   │   ├── appearance.lua        # 外观配置（主题、字体、背景）
│   │   ├── keybindings.lua       # 快捷键系统
│   │   ├── shell.lua             # Shell集成
│   │   ├── ssh.lua               # SSH配置管理
│   │   └── performance.lua       # 性能优化
│   ├── features/                  # 功能特性
│   │   ├── launcher.lua          # 命令面板/快速启动器
│   │   ├── statusbar.lua         # 自定义状态栏
│   │   ├── smart_copy.lua        # 智能复制粘贴
│   │   ├── layout.lua            # 分屏布局预设
│   │   └── workspace.lua         # 工作区管理
│   ├── plugins/                   # 插件系统
│   │   ├── init.lua              # 插件管理器
│   │   └── examples/             # 示例插件
│   └── themes/                    # 预设主题
│       ├── tokyo_night.lua       # 示例主题
│       ├── dracula.lua
│       └── catppuccin.lua
├── presets/                       # 预设配置示例
│   ├── default.lua               # 默认配置
│   ├── minimal.lua               # 极简配置
│   └── full_featured.lua         # 完整功能配置
├── pictures/                      # 背景图片资源
│   ├── README.md                 # 图片使用说明
│   └── .gitkeep                  # 保持目录结构
└── docs/                          # 文档
    └── configuration.md          # 配置说明
```

### 架构优势

- **模块化**：每个功能独立，便于维护和扩展
- **按需加载**：通过懒加载机制提升启动速度
- **可测试**：每个模块可独立测试
- **预设丰富**：提供不同场景的配置示例

## 2. 核心模块

### core/init.lua - 模块加载器

- 懒加载缓存机制
- 配置合并工具
- 模块依赖管理

### core/utils.lua - 工具函数库

- 文件操作：读取配置、检测文件存在
- 字符串处理：URL/路径识别
- 表操作：深度复制、合并
- 系统检测：OS检测、Shell检测
- 性能工具：执行时间测量

### core/constants.lua - 常量定义

- 支持的OS列表
- 默认路径配置
- 常用颜色映射
- 默认快捷键映射

## 3. 配置模块

### config/appearance.lua - 外观配置

- 三种主题模式：预设主题、自定义颜色、混合模式
- 字体配置：字体族、字重、斜体
- 背景效果：图片背景、渐变背景、透明度
- 窗口配置：内边距、透明度

### config/keybindings.lua - 快捷键系统

- 默认键表：基础操作（复制、粘贴、切换标签）
- 模式键表：类似Vim的多模式系统
- 自定义覆盖：用户可覆盖默认配置

### config/shell.lua - Shell集成

- 自动检测：检测系统可用Shell（zsh、bash、fish）
- 按项目切换：根据目录自动切换Shell
- 环境变量管理：per-directory环境变量

### config/ssh.lua - SSH配置管理

- 解析 `~/.ssh/config`
- 提供SSH主机列表
- 快速连接功能

### config/performance.lua - 性能优化

- 启动优化：按需加载
- 渲染优化：FPS控制
- 内存管理：清理缓存

## 4. 功能特性

### features/launcher.lua - 命令面板

- 快速启动器：类似IDE的命令面板（Ctrl+Shift+P）
- 命令历史：保存最近执行的命令
- 模糊搜索：快速查找命令

### features/statusbar.lua - 自定义状态栏

- 系统信息：CPU、内存、电池（左侧）
- 上下文信息：当前目录、Git分支、Shell类型（中间）
- 时间信息：当前时间、运行时间（右侧）
- 自定义字段：用户可添加自定义信息

### features/smart_copy.lua - 智能复制粘贴

- URL识别：自动识别HTTP(S)链接，提供快捷打开
- 路径识别：识别文件路径，支持快速复制
- 智能选择：三击选择整行，双击选择单词
- 剪贴板历史：保存最近N次复制内容

### features/layout.lua - 分屏布局预设

- 预设布局：default、even_horizontal、even_vertical、tall、wide
- 自定义布局：用户自定义布局保存
- 快捷切换：快速切换布局

### features/workspace.lua - 工作区管理

- 会话保存/恢复：保存标签页、窗格布局
- 项目切换：不同项目的工作区配置
- 自动保存：定时保存工作区状态

## 5. 插件系统

### plugins/init.lua - 插件管理器

- 插件加载API：统一的插件加载接口
- 插件配置：每个插件独立配置
- 插件安装API：支持从本地路径或git仓库安装（未来扩展）

### 示例插件

- smart-move.lua：智能光标移动（类似Vim）
- url-highlight.lua：URL高亮和快速打开
- session-saver.lua：会话持久化

## 6. 预设配置

### presets/default.lua - 平衡的默认配置

- tokyo_night主题
- 常用快捷键
- 基础状态栏
- 适合日常使用

### presets/minimal.lua - 极简配置

- 无背景图片
- 最小快捷键
- 禁用插件
- 最快启动速度

### presets/full_featured.lua - 完整功能

- 所有功能启用
- 丰富快捷键
- 完整状态栏
- 所有插件加载
- 适合演示和探索

## 7. 文档

### docs/configuration.md

- 快速开始指南
- 模块说明文档
- 配置选项详解
- 自定义主题教程
- 插件开发指南
- 常见问题FAQ

## 8. 实施优先级

### Phase 1: 核心架构
- 目录结构创建
- core/init.lua、utils.lua、constants.lua
- wezterm.lua主入口

### Phase 2: 基础配置
- config/appearance.lua
- config/keybindings.lua
- presets/default.lua

### Phase 3: 核心功能
- features/launcher.lua
- features/statusbar.lua
- features/layout.lua

### Phase 4: 高级功能
- config/shell.lua、ssh.lua
- features/smart_copy.lua
- features/workspace.lua

### Phase 5: 生态系统
- plugins/init.lua
- 示例插件
- 更多主题和预设

## 9. 技术要求

- Lua 5.1+（wezterm内置）
- Wezterm 2023.10.25+
- 模块化编程
- 性能优化：懒加载、缓存机制
- 可扩展性：插件系统、主题系统

## 10. 成功标准

- 启动时间 < 100ms（minimal模式）
- 模块可独立加载和测试
- 支持用户自定义配置覆盖
- 提供完整的配置示例
- 文档清晰易懂
