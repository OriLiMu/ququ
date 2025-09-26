# 🎯 ququ + nvim 集成指南

## 概述
ququ 现在支持通过 HTTP API 与外部编辑器（如 nvim）集成，实现通过命令控制录音并将识别结果发送回编辑器。

## 🚀 快速开始

### 1. 启动 ququ 应用
```bash
npm run dev  # 开发模式
# 或
npm run build && npm start  # 生产模式
```

### 2. 测试 HTTP API
应用启动后，HTTP 服务器会自动在端口 38765 启动。

```bash
# 健康检查
curl http://127.0.0.1:38765/api/health

# 状态检查
curl http://127.0.0.1:38765/api/status
```

### 3. 使用测试脚本
```bash
# 快速测试
./test_http_curl.sh quick

# 完整测试
./test_http_curl.sh full

# 手动控制
./test_http_curl.sh start  # 开始录音
# ... 说话 ...
./test_http_curl.sh stop   # 停止录音并获取文本
```

## 📡 HTTP API 参考

### 基础端点

#### 健康检查
```http
GET /api/health
```

响应：
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "timestamp": "2025-09-26T14:00:00.000Z",
    "uptime": 123.45
  }
}
```

#### 状态查询
```http
GET /api/status
```

响应：
```json
{
  "success": true,
  "data": {
    "server": "running",
    "port": 38765,
    "isRecording": false,
    "lastRecordingResult": "识别的文本内容",
    "recordingDuration": 0
  }
}
```

### 录音控制

#### 开始录音
```http
POST /api/recording/start
Content-Type: application/json

{}
```

响应：
```json
{
  "success": true,
  "data": {
    "message": "Recording started",
    "recordingId": "1234567890"
  }
}
```

#### 停止录音
```http
POST /api/recording/stop
Content-Type: application/json

{}
```

响应：
```json
{
  "success": true,
  "data": {
    "message": "Recording stopped",
    "text": "识别的文本内容",
    "duration": 3250
  }
}
```

## 🔧 nvim 配置

### 基本配置
在你的 `init.lua` 或 `init.vim` 中添加：

```lua
-- ququ 语音输入配置
local ququ_port = 38765
local ququ_base_url = "http://127.0.0.1:" .. ququ_port

-- 开始录音
local function ququ_start()
    local handle = io.popen("curl -s -X POST " .. ququ_base_url .. "/api/recording/start -H 'Content-Type: application/json' -d '{}'")
    local result = handle:read("*a")
    handle:close()

    if result:match('"success"%s*:%s*true') then
        print("🎤 开始录音...")
    else
        print("❌ 无法开始录音")
    end
end

-- 停止录音并插入文本
local function ququ_stop()
    local handle = io.popen("curl -s -X POST " .. ququ_base_url .. "/api/recording/stop -H 'Content-Type: application/json' -d '{}'")
    local result = handle:read("*a")
    handle:close()

    -- 提取识别文本
    local text = result:match('"text"%s*:%s*"([^"]*)"')
    if text and #text > 0 then
        -- 在当前光标位置插入文本
        vim.api.nvim_put({text}, '', false, true)
        print("✅ 识别文本已插入")
    else
        print("⚠️  未识别到文本或出错")
    end
end

-- 设置快捷键
vim.keymap.set('n', '\u003cf2\u003e', ququ_start, { desc = "开始语音录音" })
vim.keymap.set('n', '\u003cf3\u003e', ququ_stop, { desc = "停止语音录音并插入文本" })
vim.keymap.set('i', '\u003cf2\u003e', ququ_start, { desc = "开始语音录音" })
vim.keymap.set('i', '\u003cf3\u003e', ququ_stop, { desc = "停止语音录音并插入文本" })
```

### 高级配置（带状态显示）

```lua
-- 高级 ququ 配置
local ququ_config = {
    port = 38765,
    base_url = "http://127.0.0.1:38765",
    auto_insert = true,
    show_status = true,
    recording = false
}

local function ququ_request(endpoint, method, data)
    local curl_cmd = string.format(
        "curl -s -X %s %s/api%s -H 'Content-Type: application/json'",
        method or "GET", ququ_config.base_url, endpoint
    )

    if data then
        curl_cmd = curl_cmd .. " -d '" .. vim.fn.json_encode(data) .. "'"
    end

    local handle = io.popen(curl_cmd)
    local result = handle:read("*a")
    handle:close()

    return result
end

local function ququ_update_status()
    local result = ququ_request("/status", "GET")
    if result:match('"success"%s*:%s*true') then
        local is_recording = result:match('"isRecording"%s*:%s*true') ~= nil
        ququ_config.recording = is_recording

        if ququ_config.show_status then
            vim.g.ququ_recording_status = is_recording and "🔴 录音中" or "⏹️  待机"
        end
    end
end

local function ququ_toggle()
    ququ_update_status()

    if ququ_config.recording then
        -- 停止录音
        local result = ququ_request("/recording/stop", "POST", {})
        local text = result:match('"text"%s*:%s*"([^"]*)"')

        if text and #text > 0 then
            if ququ_config.auto_insert then
                vim.api.nvim_put({text}, '', false, true)
            end
            print("✅ 识别: " .. text)
        else
            print("⚠️  未识别到文本")
        end
    else
        -- 开始录音
        local result = ququ_request("/recording/start", "POST", {})
        if result:match('"success"%s*:%s*true') then
            print("🎤 开始录音...")
        else
            print("❌ 无法开始录音")
        end
    end

    ququ_update_status()
end

-- 设置快捷键（使用同一个按键切换）
vim.keymap.set({'n', 'i'}, '\u003cf2\u003e', ququ_toggle, { desc = "切换语音录音" })
vim.keymap.set({'n', 'i'}, '\u003cf4\u003e', function()
    ququ_config.show_status = not ququ_config.show_status
    print("状态显示: " .. (ququ_config.show_status and "开启" or "关闭"))
end, { desc = "切换状态显示" })

-- 初始化状态
ququ_update_status()
```

## 🧪 故障排除

### 常见问题

1. **HTTP 服务器未启动**
   - 确保 ququ 应用正在运行
   - 检查日志中是否有 HTTP 服务器启动信息
   - 检查端口 38765 是否被占用

2. **curl 命令失败**
   - 确保 curl 已安装
   - 检查防火墙设置
   - 确认应用已完全启动

3. **录音按钮无法点击**
   - 确保应用窗口处于活动状态
   - 检查模型是否已加载完成
   - 查看应用界面是否有错误提示

### 调试步骤

1. **检查服务器状态**
   ```bash
   curl http://127.0.0.1:38765/api/health
   ```

2. **查看应用日志**
   - 开发模式：查看终端输出
   - 生产模式：查看日志文件

3. **测试基本功能**
   ```bash
   ./test_http_curl.sh quick
   ```

## 🔧 配置选项

### 环境变量
- `NVIM_HTTP_PORT`: HTTP 服务器端口（默认 38765）

### 端口配置
如果默认端口被占用，可以修改端口：

```bash
export NVIM_HTTP_PORT=38766
npm run dev
```

然后在 nvim 配置中使用新端口。

## 📚 相关文件

- `src/helpers/httpServerManager.js` - HTTP 服务器实现
- `test_http_server.py` - Python 测试脚本
- `test_http_curl.sh` - Shell 测试脚本
- `test_nvim.lua` - Lua 测试脚本
- `NVIM_INTEGRATION.md` - 本说明文档

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进 nvim 集成功能！

## 📄 许可证

与 ququ 项目相同。