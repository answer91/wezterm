# 背景图片目录

此目录用于存放Wezterm终端的背景图片。

## 使用说明

1. 将您喜欢的背景图片放入此目录
2. 在配置文件中引用图片路径，例如：

```lua
-- 在 lua/config/appearance.lua 中配置
background = {
    {
        source = { File = { path = wezterm.config_dir .. "/pictures/your-image.png" } },
        opacity = 0.8,
    }
}
```

## 支持的图片格式

- PNG (.png)
- JPEG (.jpg, .jpeg)
- GIF (.gif)
- 其他Wezterm支持的格式

## 推荐的图片规格

- **分辨率**: 1920x1080 或更高
- **宽高比**: 16:9
- **文件大小**: 建议小于 5MB，以保证加载速度

## 示例图片

您可以从以下网站获取高质量的背景图片：
- Unsplash (https://unsplash.com)
- Pexels (https://pexels.com)
- Pixabay (https://pixabay.com)

## 注意事项

- 请确保您有权使用放置在此目录的图片
- 避免使用过于明亮或对比度高的图片，以免影响终端文字的可读性
- 建议使用深色或半透明的图片
