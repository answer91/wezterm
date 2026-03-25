# 添加新背景图片快速指南

## 🎯 问题：添加新图片后切换无效

### ✅ 解决方案

你添加了 `curry-1.jpg` 和 `kobe-4.jpg`，但切换时仍然只在旧图片之间切换。

## 🔧 立即解决（3种方法）

### 方法1：重新扫描快捷键（推荐）

按 **`Ctrl+Alt+F`** 强制重新扫描背景图片

- 立即生效
- 自动发现新图片
- 显示找到的背景数量

### 方法2：完全重启wezterm

```bash
# 完全退出wezterm，然后重新启动
# 不是 Ctrl+Shift+R 重新加载配置
```

- 清除所有缓存
- 重新初始化所有模块
- 确保发现新图片

### 方法3：删除状态文件

```bash
# 切换到wezterm配置目录
cd /path/to/wezterm

# 删除状态文件
rm background_state.txt

# 重启wezterm
```

## 🛠️ 技术原因

背景切换器使用 `initialized` 标志避免重复初始化：

```lua
if self.initialized then
    return  -- 跳过重新扫描
end
```

这提高了性能，但也意味着添加新图片后需要强制重新扫描。

## 📸 支持的图片格式

背景切换器会自动扫描以下格式的文件：

- `.jpg` / `.jpeg`
- `.png`
- `.gif`
- `.webp`

## 🎨 验证新图片

### 检查文件是否存在

```bash
ls -la pictures/
```

应该看到：
```
curry-1.jpg
kobe-1.jpg
kobe-2.jpg
kobe-3.jpg
kobe-4.jpg
sword.jpg
```

### 检查文件权限

```bash
chmod 644 pictures/curry-1.jpg
chmod 644 pictures/kobe-4.jpg
```

## ⌨️ 新增的快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Alt+F` | 强制重新扫描背景图片 |

## 🔄 更新后的图片列表

重新扫描后，你应该能在以下6个背景之间切换：

1. `curry-1.jpg` 🆕
2. `kobe-1.jpg`
3. `kobe-2.jpg`
4. `kobe-3.jpg`
5. `kobe-4.jpg` 🆕
6. `sword.jpg`

## 📋 快速操作步骤

1. **添加新图片到pictures目录**
   ```bash
   cp /path/to/curry-1.jpg pictures/
   cp /path/to/kobe-4.jpg pictures/
   ```

2. **按 `Ctrl+Alt+F` 重新扫描**
   - 会显示找到的背景数量
   - 例如：`"Rescanned: 6 backgrounds found"`

3. **开始使用快捷键切换**
   - `Ctrl+Alt+B` - 下一个背景
   - 现在应该能看到新图片了

## 🐛 故障排除

### 重新扫描后仍然看不到新图片

1. **检查文件格式**：
   ```bash
   file pictures/curry-1.jpg
   # 应该显示：JPEG image data
   ```

2. **检查文件大小**：
   ```bash
   ls -lh pictures/curry-1.jpg
   # 确保不是0字节
   ```

3. **手动验证**：
   ```bash
   # 直接测试图片是否有效
   eog pictures/curry-1.jpg  # Linux
   # 或
   open pictures/curry-1.jpg # macOS
   ```

### 快捷键不工作

1. 确认背景切换器已启用
2. 检查快捷键冲突
3. 完全重启wezterm

## 💡 最佳实践

1. **添加图片后立即重新扫描**
   ```bash
   # 添加图片
   cp new-bg.jpg pictures/

   # 立即重新扫描
   # 按 Ctrl+Alt+F
   ```

2. **使用命名规范**
   ```
   bg-01.jpg, bg-02.jpg, bg-03.jpg
   或
   landscape-01.jpg, portrait-01.jpg
   ```

3. **保持合理的文件大小**
   ```bash
   # 压缩大图片
   convert large.jpg -quality 85 -resize 1920x1080 pictures/large.jpg
   ```

---

**现在你可以轻松添加和管理背景图片了！** 🎨✨
