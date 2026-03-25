# 背景图片分辨率和显示设置指南

## 🖼️ 背景图片分辨率控制

在wezterm中，背景图片的显示方式通过多个参数控制，包括缩放、对齐和重复模式。

## 📐 可用的背景设置参数

### 基础参数

```lua
config.background = {
    {
        source = { File = { path = "/path/to/image.jpg" } },
        opacity = 0.8,           -- 整体透明度 (0.0-1.0)
        hsb = {
            brightness = 0.3,     -- 亮度调整 (0.0-1.0)
            saturation = 0.5,     -- 饱和度 (0.0-1.0)
            hue = 1.0,            -- 色调 (0.0-1.0)
        },
    }
}
```

### 高级分辨率控制参数

```lua
config.background = {
    {
        source = { File = { path = "/path/to/image.jpg" } },

        --- 水平对齐方式
        horizontal_align = "Left",   -- Left, Center, Right

        --- 垂直对齐方式
        vertical_align = "Top",      -- Top, Middle, Bottom

        --- 重复模式
        repeat_x = "NoRepeat",       -- NoRepeat, Repeat, Mirror
        repeat_y = "NoRepeat",       -- NoRepeat, Repeat, Mirror

        --- 透明度
        opacity = 0.8,

        --- HSB颜色调整
        hsb = {
            brightness = 0.3,
            saturation = 0.5,
            hue = 1.0,
        },

        --- 锐化 (仅某些后端支持)
        sharpen = 0,
    }
}
```

## 🎨 常见显示模式

### 1. 居中显示（推荐）

```lua
config.background = {
    {
        source = { File = { path = "background.jpg" } },
        horizontal_align = "Center",
        vertical_align = "Middle",
        repeat_x = "NoRepeat",
        repeat_y = "NoRepeat",
        opacity = 0.8,
    }
}
```

### 2. 拉伸填满

```lua
config.background = {
    {
        source = { File = { path = "background.jpg" } },
        -- wezterm默认会拉伸图片填满窗口
        opacity = 0.8,
    }
}
```

### 3. 平铺重复

```lua
config.background = {
    {
        source = { File = { path = "background.jpg" } },
        repeat_x = "Repeat",
        repeat_y = "Repeat",
        opacity = 0.8,
    }
}
```

### 4. 镜像重复

```lua
config.background = {
    {
        source = { File = { path = "background.jpg" } },
        repeat_x = "Mirror",
        repeat_y = "Mirror",
        opacity = 0.8,
    }
}
```

## 📱 推荐的图片分辨率

### 根据屏幕分辨率选择

| 屏幕分辨率 | 推荐图片分辨率 | 说明 |
|-----------|---------------|------|
| 1920x1080 | 1920x1080 | 全高清屏幕 |
| 2560x1440 | 2560x1440 | 2K屏幕 |
| 3840x2160 | 3840x2160 | 4K屏幕 |
| 多显示器 | 主显示器分辨率 | 会在每个窗口独立显示 |

### 通用建议

```bash
# 检查你的屏幕分辨率
xdpyinfo | grep dimensions

# 或者
xrandr | grep current
```

## 🛠️ 图片处理建议

### 1. 图片大小优化

```bash
# 使用ImageMagick调整图片大小
convert input.jpg -resize 1920x1080 -quality 85 output.jpg

# 保持宽高比
convert input.jpg -resize 1920x1080^ -gravity center -extent 1920x1080 output.jpg
```

### 2. 图片格式选择

- **JPG**：照片类图片，文件小，质量好
- **PNG**：图标类图片，支持透明
- **WebP**：现代格式，压缩率高

### 3. 文件大小控制

```bash
# 压缩图片
convert input.jpg -quality 75 output.jpg

# 查看文件大小
ls -lh pictures/
```

**推荐**：背景图片 < 2MB，确保快速加载

## ⚙️ 在配置中应用

### 方法1：修改background_switcher.lua

```lua
-- 在 ghost/features/background_switcher.lua 中
config.background = {
    {
        source = { File = { path = current_bg } },
        horizontal_align = "Center",   -- 添加对齐设置
        vertical_align = "Middle",
        repeat_x = "NoRepeat",
        repeat_y = "NoRepeat",
        opacity = 0.8,
        hsb = {
            brightness = 0.3,
            saturation = 0.5,
            hue = 1.0,
        },
    },
}
```

### 方法2：在appearance.lua中设置

```lua
-- 在 ghost/config/appearance.lua 的 apply_background 函数中
if background_config.type == "image" and background_config.image_path then
    config.background = {
        {
            source = { File = { path = full_path } },
            horizontal_align = background_config.horizontal_align or "Center",
            vertical_align = background_config.vertical_align or "Middle",
            repeat_x = background_config.repeat_x or "NoRepeat",
            repeat_y = background_config.repeat_y or "NoRepeat",
            opacity = background_config.image_opacity or 0.8,
        }
    }
end
```

## 🎯 最佳实践

### 1. 分辨率匹配

```lua
-- 根据你的屏幕选择合适的图片
-- 1080p屏幕 → 1920x1080 图片
-- 2K屏幕 → 2560x1440 图片
-- 4K屏幕 → 3840x2160 图片
```

### 2. 居中对齐

```lua
-- 大多数情况下的最佳选择
horizontal_align = "Center",
vertical_align = "Middle",
repeat_x = "NoRepeat",
repeat_y = "NoRepeat",
```

### 3. 适度透明

```lua
-- 确保文字可读性
opacity = 0.7,  -- 不要太高，0.6-0.8最佳
hsb = {
    brightness = 0.3,  -- 降低亮度提升可读性
    saturation = 0.5,
    hue = 1.0,
}
```

### 4. 文件大小控制

```bash
# 推荐设置
大小: < 2MB
格式: JPG (质量85)
分辨率: 匹配屏幕
```

## 🔧 故障排除

### 图片显示不全

**问题**：图片只显示一部分

**解决**：
```lua
-- 检查对齐设置
horizontal_align = "Center",
vertical_align = "Middle",
```

### 图片变形

**问题**：图片被拉伸变形

**解决**：
```lua
-- 使用适当分辨率的图片
-- 或调整图片宽高比
```

### 图片模糊

**问题**：背景图片不清晰

**解决**：
```bash
# 使用高分辨率图片
convert input.jpg -resize 2560x1440 -quality 90 output.jpg
```

### 加载缓慢

**问题**：启动时背景加载慢

**解决**：
```bash
# 压缩图片文件
convert input.jpg -quality 75 -strip output.jpg

# 或使用更小的图片
convert input.jpg -resize 1920x1080 -quality 80 output.jpg
```

## 📊 参数速查表

| 参数 | 类型 | 可选值 | 说明 |
|------|------|--------|------|
| `horizontal_align` | string | Left/Center/Right | 水平对齐 |
| `vertical_align` | string | Top/Middle/Bottom | 垂直对齐 |
| `repeat_x` | string | NoRepeat/Repeat/Mirror | 水平重复 |
| `repeat_y` | string | NoRepeat/Repeat/Mirror | 垂直重复 |
| `opacity` | number | 0.0-1.0 | 透明度 |
| `sharpen` | number | 0-100 | 锐化程度 |

---

**选择适合你的配置，享受完美的背景效果！** 🎨✨
