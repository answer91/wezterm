# 背景切换故障排除指南

## 🔧 常见问题解决

### 问题1：快捷键无效，背景不切换

**症状**：按快捷键后日志显示切换，但背景没有变化

**原因**：模块加载顺序问题，背景切换器被外观模块覆盖

**解决方案**：
1. 确保wezterm.lua中的模块加载顺序正确：
```lua
-- 正确的顺序
appearance → keybindings → shell → background_switcher
```

2. 背景切换器应该在**最后**初始化，确保覆盖其他模块的背景设置

### 问题2：重复初始化日志

**症状**：日志中出现多次"Found X background images"

**原因**：每次重载配置都重新初始化

**解决方案**：已修复 - 使用`initialized`标志避免重复初始化

### 问题3：切换后背景立即恢复

**症状**：按快捷键后背景短暂变化，然后又恢复原样

**原因**：背景切换器和外观模块冲突

**解决方案**：
- 确保背景切换器在appearance之后初始化
- 或者在外观配置中不设置背景，只由background_switcher管理

## 🎯 正确的配置方式

### 方案1：完全由background_switcher管理（推荐）

```lua
-- 在wezterm.lua中
ok, appearance = pcall(require, "ghost.config.appearance")
if ok and appearance then
    config = appearance.apply(config, {
        -- 不设置background，让background_switcher管理
        -- background = { enabled = false }
    })
end
```

### 方案2：设置初始背景，然后切换

```lua
-- 在wezterm.lua中
ok, appearance = pcall(require, "ghost.config.appearance")
if ok and appearance then
    config = appearance.apply(config, {
        background = {
            enabled = true,
            type = "image",
            image_path = "kobe-1.jpg", -- 初始背景
        },
    })
end

-- background_switcher会在最后覆盖这个设置
```

## 🔍 诊断步骤

### 1. 检查模块加载顺序

查看wezterm.lua中的`apply_modules()`函数：
```lua
local function apply_modules()
    -- 1. 外观配置
    -- 2. 快捷键配置
    -- 3. Shell配置
    -- 4. 背景切换器（最后，覆盖背景设置）
end
```

### 2. 验证背景图片

```bash
# 检查图片是否存在
ls -la pictures/

# 应该看到：
# kobe-1.jpg
# kobe-2.jpg
# kobe-3.jpg
# sword.jpg
```

### 3. 查看日志

按`Ctrl+Shift+L`打开日志，查找：
```
background_switcher: Found X background images
background_switcher: Applied background: /path/to/image.jpg
```

### 4. 测试快捷键

1. 启动wezterm
2. 按`Ctrl+Alt+B`切换背景
3. 观察日志和实际效果

## 🛠️ 高级故障排除

### 强制重新初始化

删除状态文件：
```bash
rm background_state.txt
```

重启wezterm，系统会从头开始。

### 检查模块冲突

如果仍然有问题，临时禁用外观模块的背景设置：

```lua
ok, appearance = pcall(require, "ghost.config.appearance")
if ok and appearance then
    config = appearance.apply(config, {
        background = {
            enabled = false, -- 临时禁用
        },
    })
end
```

### 手动测试背景切换

在wezterm.lua中直接设置：
```lua
config.background = {
    {
        source = { File = { path = "/full/path/to/pictures/kobe-2.jpg" } },
    }
}
```

重启wezterm验证该背景是否正常显示。

## 📋 已修复的问题

✅ **重复初始化** - 使用`initialized`标志
✅ **模块覆盖** - 调整初始化顺序
✅ **快捷键集成** - 自动检测并创建快捷键
✅ **状态管理** - 正确保存和恢复背景状态

## 💡 最佳实践

1. **保持简单**：只在一个地方管理背景
2. **使用相对路径**：`image_path = "kobe-1.jpg"`
3. **信任自动化**：让background_switcher自动发现背景
4. **检查日志**：出现问题时首先查看日志

## 🆘 仍然无法解决？

1. 完全重启wezterm（不是重新加载配置）
2. 检查wezterm版本：`wezterm --version`
3. 查看完整日志：按`Ctrl+Shift+L`
4. 确认图片文件格式正确

---

**背景切换应该正常工作了！** 🎨✨
