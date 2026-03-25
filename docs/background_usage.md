# 背景图片切换功能 - 快速使用指南

## ✅ 快捷键已自动集成

背景切换快捷键已经内置到keybindings模块中，**无需手动配置**！

### 🎹 可用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Alt+B` | 切换到下一个背景 |
| `Ctrl+Shift+Alt+B` | 切换到上一个背景 |
| `Ctrl+Alt+R` | 随机切换背景 |
| `Ctrl+Alt+T` | 启用/停用自动轮播 |

## 🚀 快速开始（3步）

### 1️⃣ 启用背景功能

在 `wezterm.lua` 的外观配置中添加：

```lua
-- 外观配置
ok, appearance = pcall(require, "ghost.config.appearance")
if ok and appearance then
    config = appearance.apply(config, {
        background = {
            enabled = true,           -- 启用背景
            type = "image",           -- 图片类型
            image_path = "kobe-1.jpg", -- 图片文件名
            opacity = 0.8,            -- 透明度 (0.0-1.0)
        },
    })
end
```

### 2️⃣ 重启wezterm

```bash
# 重启wezterm或按 Ctrl+Shift+R 重新加载配置
```

### 3️⃣ 开始使用快捷键

- 按 `Ctrl+Alt+B` 切换背景
- 按 `Ctrl+Alt+R` 随机背景

## 📸 关于 image_path

### ✅ 推荐：相对路径（文件名）

```lua
image_path = "kobe-1.jpg"  -- 只需文件名
```

**优势**：
- 简单易用
- 自动在 `pictures/` 目录查找
- 配置文件更便携

### ❌ 不推荐：绝对路径

```lua
image_path = "/full/path/to/wezterm/pictures/kobe-1.jpg"
```

## 🎨 可用背景图片

你的 `pictures/` 目录中的图片：
- `kobe-1.jpg`
- `kobe-2.jpg`
- `kobe-3.jpg`
- `sword.jpg`

## 🔧 高级配置

### 完整配置示例

```lua
background = {
    enabled = true,
    type = "image",
    image_path = "kobe-1.jpg",

    -- 背景透明度
    opacity = 0.95,

    -- 图片透明度
    image_opacity = 0.8,

    -- 模糊效果
    blur = 20,

    -- HSB颜色调整
    hsb = {
        brightness = 0.3,
        saturation = 0.5,
        hue = 1.0,
    },
}
```

### 添加新的背景图片

1. 将图片文件放到 `pictures/` 目录
2. 支持格式：`.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`
3. 重启wezterm
4. 使用快捷键切换背景

## 🏗️ 架构说明

### 模块化设计

- **`ghost/features/background_switcher.lua`** - 背景切换核心模块
- **`ghost/config/keybindings.lua`** - 自动集成背景切换快捷键
- **`wezterm.lua`** - 主配置文件（保持简洁）

### 快捷键集成流程

```
wezterm.lua
    ↓
keybindings.lua
    ↓
background_switcher.lua (create_keybindings)
    ↓
自动添加快捷键到 config.keys
```

## 🐛 故障排除

### 快捷键不工作

1. **检查背景是否启用**：
   ```lua
   background = { enabled = true }
   ```

2. **检查图片文件是否存在**：
   ```bash
   ls pictures/
   ```

3. **重新加载配置**：
   ```bash
   Ctrl+Shift+R
   ```

### 背景不显示

1. 确认图片路径正确
2. 检查文件格式支持
3. 查看wezterm日志：`Ctrl+Shift+L`

### 切换后没有立即更新

- 这是正常现象，wezterm会重新加载配置
- 切换可能需要1-2秒生效

## 💡 最佳实践

1. **使用相对路径**（文件名）而不是绝对路径
2. **保持图片文件大小适中**（推荐 < 2MB）
3. **使用常见图片格式**（JPG、PNG）
4. **定期清理background_state.txt**（状态文件）

## 📝 配置文件示例

完整的工作示例请参考：
- `presets/default.lua` - 推荐配置
- `presets/full_featured.lua` - 完整功能配置

---

**享受你的背景切换体验！** 🖼️✨
