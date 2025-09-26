-- ququ HTTP API 测试脚本
-- 用于测试与 ququ 应用的 HTTP 通信

local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("dkjson") -- 需要安装 dkjson 库

-- 配置
local BASE_URL = "http://127.0.0.1:38765"
local TIMEOUT = 10 -- 秒

-- 设置超时
http.TIMEOUT = TIMEOUT

-- 辅助函数：发送HTTP请求
local function send_request(method, endpoint, data)
    local url = BASE_URL .. endpoint
    local response_body = {}
    local request_body = data and json.encode(data) or nil

    local headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    }

    if request_body then
        headers["Content-Length"] = tostring(#request_body)
    end

    local result, status_code = http.request{
        url = url,
        method = method,
        headers = headers,
        source = request_body and ltn12.source.string(request_body) or nil,
        sink = ltn12.sink.table(response_body)
    }

    if not result then
        return false, "HTTP请求失败: " .. tostring(status_code)
    end

    local response_text = table.concat(response_body)

    if status_code ~= 200 then
        return false, "HTTP错误: " .. tostring(status_code) .. " - " .. response_text
    end

    -- 解析JSON响应
    local response_data, err = json.decode(response_text)
    if not response_data then
        return false, "JSON解析失败: " .. tostring(err)
    end

    if not response_data.success then
        return false, "API错误: " .. tostring(response_data.error)
    end

    return true, response_data.data
end

-- 测试函数
local function test_health_check()
    print("🧪 测试健康检查...")
    local success, data = send_request("GET", "/api/health")

    if success then
        print("✅ 健康检查通过")
        print("   状态: " .. data.status)
        print("   时间: " .. data.timestamp)
        print("   运行时间: " .. data.uptime .. " 秒")
    else
        print("❌ 健康检查失败: " .. data)
        return false
    end

    return true
end

local function test_status_check()
    print("\n🧪 测试状态检查...")
    local success, data = send_request("GET", "/api/status")

    if success then
        print("✅ 状态检查通过")
        print("   服务器: " .. data.server)
        print("   端口: " .. data.port)
        print("   正在录音: " .. tostring(data.isRecording))
        print("   最后结果: " .. (data.lastRecordingResult or "无"))
    else
        print("❌ 状态检查失败: " .. data)
        return false
    end

    return true
end

local function test_start_recording()
    print("\n🧪 测试开始录音...")
    local success, data = send_request("POST", "/api/recording/start", {})

    if success then
        print("✅ 开始录音成功")
        print("   消息: " .. data.message)
        print("   录音ID: " .. data.recordingId)
    else
        print("❌ 开始录音失败: " .. data)
        return false
    end

    return true
end

local function test_stop_recording()
    print("\n🧪 测试停止录音...")
    local success, data = send_request("POST", "/api/recording/stop", {})

    if success then
        print("✅ 停止录音成功")
        print("   消息: " .. data.message)
        print("   识别文本: " .. (data.text or "无"))
        print("   录音时长: " .. (data.duration or 0) .. " 毫秒")

        -- 保存识别结果
        if data.text and #data.text > 0 then
            print("\n📝 识别结果:")
            print("   " .. data.text)
        end
    else
        print("❌ 停止录音失败: " .. data)
        return false
    end

    return true
end

local function test_full_workflow()
    print("\n🔄 测试完整工作流...")

    -- 1. 检查状态
    local success, status_data = send_request("GET", "/api/status")
    if not success then
        print("❌ 无法获取状态: " .. status_data)
        return false
    end

    if status_data.isRecording then
        print("⚠️  检测到正在录音，先停止当前录音...")
        local stop_success = test_stop_recording()
        if not stop_success then
            return false
        end
        -- 等待一会儿
        os.execute("sleep 1")
    end

    -- 2. 开始录音
    local start_success = test_start_recording()
    if not start_success then
        return false
    end

    -- 3. 等待用户说话（模拟）
    print("\n🎤 请对着麦克风说话（3秒后自动停止）...")
    os.execute("sleep 3")

    -- 4. 停止录音
    local stop_success = test_stop_recording()
    if not stop_success then
        return false
    end

    print("\n✅ 完整工作流测试完成！")
    return true
end

-- 主测试函数
local function run_all_tests()
    print("🚀 开始 ququ HTTP API 测试")
    print("=====================================")

    -- 检查依赖
    if not pcall(require, "socket.http") then
        print("❌ 缺少 socket.http 库，请先安装 LuaSocket")
        print("   Ubuntu/Debian: sudo apt-get install lua-socket")
        print("   macOS: brew install lua-socket")
        return
    end

    if not pcall(require, "dkjson") then
        print("⚠️  缺少 dkjson 库，将使用简单模式测试")
        print("   可以安装: luarocks install dkjson")
        -- 这里可以实现一个简单的测试模式
    end

    -- 运行测试
    local tests = {
        { name = "健康检查", func = test_health_check },
        { name = "状态检查", func = test_status_check },
        { name = "完整工作流", func = test_full_workflow }
    }

    local passed = 0
    local total = #tests

    for _, test in ipairs(tests) do
        print(string.format("\n📋 运行测试: %s", test.name))
        local success = test.func()
        if success then
            passed = passed + 1
        end
    end

    print(string.format("\n📊 测试结果: %d/%d 通过", passed, total))

    if passed == total then
        print("🎉 所有测试通过！ququ HTTP API 工作正常")
    else
        print("⚠️  部分测试失败，请检查 ququ 应用是否正在运行")
    end
end

-- 命令行参数处理
local function main()
    local args = {...}

    if #args == 0 then
        run_all_tests()
        return
    end

    local command = args[1]

    if command == "start" then
        test_start_recording()
    elseif command == "stop" then
        test_stop_recording()
    elseif command == "status" then
        test_status_check()
    elseif command == "health" then
        test_health_check()
    else
        print("用法: lua test_nvim.lua [command]")
        print("命令:")
        print("  start   - 开始录音")
        print("  stop    - 停止录音")
        print("  status  - 检查状态")
        print("  health  - 健康检查")
        print("  (无参数) - 运行所有测试")
    end
end

-- 运行测试
main()