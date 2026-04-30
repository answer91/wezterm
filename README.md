# WezTerm Configuration

## 目录结构

```
~/.config/wezterm/
├── wezterm.lua                          # 主配置文件
├── constants/
│   └── keybindings.lua                  # 快捷键定义
├── artificial_plugins/
│   ├── bar_init.lua                     # bar 插件入口（已禁用）
│   ├── bar/                             # bar 插件子模块
│   ├── tabline_init.lua                 # tabline 插件入口
│   └── tabline/                         # tabline 插件子模块
└── README.md
```

## 基础配置

| 配置项 | 值 | 说明 |
|--------|-----|------|
| color_scheme | zenburned | Zenburn 配色方案 |
| default_prog | /usr/bin/fish | 默认 Shell 为 fish |
| tab_bar_at_bottom | true | 标签栏置于窗口底部 |
| status_update_interval | 500ms | 状态栏刷新间隔 |
| leader | Ctrl+Space | Leader 键，超时 1 秒 |

启动时自动最大化窗口。

## 插件

本配置使用本地化插件，所有插件均从 GitHub 克隆到本地 `artificial_plugins/` 目录加载，无需联网。

### 已安装插件

| 插件 | 来源 | 状态 | 说明 |
|------|------|------|------|
| [tabline.wez](https://github.com/michaelbrusegard/tabline.wez) | michaelbrusegard/tabline.wez | 启用 | 标签栏美化，显示模式、工作区、目录、CPU、内存、时间、电池等 |
| [bar.wezterm](https://github.com/adriankarlen/bar.wezterm) | adriankarlen/bar.wezterm | 禁用 | 底部状态栏，含 Spotify 集成、窗口标签等 |

### 插件本地化方法

由于内网环境无法使用 `wezterm.plugin.require()` 从 GitHub URL 自动下载插件，采用手动本地化方案：

1. 手动克隆插件仓库到 `~/.local/share/wezterm/plugins/`
2. 将插件入口文件及子模块复制到 `~/.config/wezterm/artificial_plugins/`
3. 在 `wezterm.lua` 中通过 `package.path` 设置搜索路径，使用标准 `require` 加载

### 插件更新

如需更新插件，从 GitHub 拉取最新代码后替换 `artificial_plugins/` 下对应文件即可。

## 快捷键

### Leader 键

`Ctrl+Space` 后跟以下按键：

| 快捷键 | 功能 |
|--------|------|
| `Space` → `F` | 进入字体大小调整模式（见下方键表） |
| `Space` → `P` | 进入窗格大小调整模式（见下方键表） |

#### 字体调整键表（resize_font）

进入后按以下键操作，`Escape` 或 `Q` 退出：

| 按键 | 功能 |
|------|------|
| `K` | 增大字体 |
| `J` | 缩小字体 |
| `R` | 重置字体大小 |
| `Escape` / `Q` | 退出键表 |

#### 窗格缩放键表（resize_pane）

进入后按以下键操作，`Escape` 或 `Q` 退出：

| 按键 | 功能 |
|------|------|
| `K` | 窗格上边扩大 |
| `J` | 窗格下边扩大 |
| `H` | 窗格左边扩大 |
| `L` | 窗格右边扩大 |
| `Escape` / `Q` | 退出键表 |

### 功能键

| 快捷键 | 功能 |
|--------|------|
| `F1` | 进入复制模式 |
| `F2` | 打开命令面板 |
| `F3` | 打开启动器 |
| `F4` | 模糊搜索标签页 |
| `F5` | 模糊搜索工作区 |
| `F11` | 切换全屏 |
| `F12` | 显示调试覆盖层 |

### 基础操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+C` | 复制到系统剪贴板 |
| `Ctrl+Shift+V` | 从系统剪贴板粘贴 |
| `Ctrl+Shift+R` | 重新加载配置 |

### 标签页操作

| 快捷键 | 功能 |
|--------|------|
| `Alt+T` | 新建标签页 |
| `Alt+Ctrl+W` | 关闭当前标签页 |
| `Alt+[` | 上一个标签页 |
| `Alt+]` | 下一个标签页 |
| `Alt+Ctrl+[` | 标签页左移 |
| `Alt+Ctrl+]` | 标签页右移 |
| `Ctrl+Shift+1~8` | 切换到第 1~8 个标签页 |
| `Ctrl+Shift+9` | 切换到最后一个标签页 |

### 窗口操作

| 快捷键 | 功能 |
|--------|------|
| `Alt+N` | 新建窗口 |
| `Alt+Ctrl+Enter` | 最大化/还原窗口 |

### 窗格操作

| 快捷键 | 功能 |
|--------|------|
| `Alt+\` | 垂直分割窗格 |
| `Alt+Ctrl+\` | 水平分割窗格 |
| `Alt+Enter` | 切换窗格全屏 |
| `Alt+W` | 关闭当前窗格 |
| `Alt+Ctrl+H` | 切换到左侧窗格 |
| `Alt+Ctrl+J` | 切换到下方窗格 |
| `Alt+Ctrl+K` | 切换到上方窗格 |
| `Alt+Ctrl+L` | 切换到右侧窗格 |
| `Alt+Ctrl+P` | 选择窗格并交换位置（数字键 1-0 选择） |

### 窗格滚动

| 快捷键 | 功能 |
|--------|------|
| `Alt+U` | 向上滚动 5 行 |
| `Alt+D` | 向下滚动 5 行 |
| `PageUp` | 向上滚动 3/4 页 |
| `PageDown` | 向下滚动 3/4 页 |

### 字体大小

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Shift+=` | 增大字体 |
| `Ctrl+-` | 缩小字体 |
| `Ctrl+Shift+0` | 重置字体大小 |

### 搜索

| 快捷键 | 功能 |
|--------|------|
| `Alt+F` | 搜索（不区分大小写） |

### 鼠标

| 操作 | 功能 |
|------|------|
| `Ctrl+左键点击` | 打开链接 |

## License

MIT
