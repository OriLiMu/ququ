-- ququ HTTP API 简单测试脚本
-- 不依赖外部库，使用基本的 socket 通信

-- 简单的 HTTP 客户端实现
local function http_request(method, endpoint, data)
    local socket = require("socket")
    local http = require("socket.http")
    local ltn12 = require("ltn12")

    local url = "http://127.0.0.1:38765" .. endpoint
    local response_body = {}

    local headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/json"
    }

    local request_body = nil
    if data then
        request_body = '{"test":"data"}' -- 简单的 JSON
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

    -- 简单解析JSON响应（不依赖外部库）
    local success_match = response_text:match('"success"%s*:%s*true')
    if success_match then
        -- 提取文本内容
        local text_match = response_text:match('"text"%s*:%s*"([^"]*)"')
        local message_match = response_text:match('"message"%s*:%s*"([^"]*)"')
        return true, { text = text_match or "", message = message_match or "" }
    else
        local error_match = response_text:match('"error"%s*:%s*"([^"]*)"')
        return false, error_match or "未知错误"
    end
end

-- 测试函数
local function test_health()
    print("🧪 测试健康检查...")
    local success, data = http_request("GET", "/api/health", nil)

    if success then
        print("✅ 健康检查通过")
    else
        print("❌ 健康检查失败: " .. data)
        return false
    end

    return true
end

local function test_status()
    print("\n🧪 测试状态检查...")
    local success, data = http_request("GET", "/api/status", nil)

    if success then
        print("✅ 状态检查通过")
        -- 简单解析状态响应
        local status_text = data.message or "状态正常"
        print("   状态: " .. status_text)
    else
        print("❌ 状态检查失败: " .. data)
        return false
    end

    return true
end

local function test_start_recording()
    print("\n🧪 测试开始录音...")
    local success, data = http_request("POST", "/api/recording/start", {})

    if success then
        print("✅ 开始录音成功")
        print("   消息: " .. (data.message or "录音已开始"))
    else
        print("❌ 开始录音失败: " .. data)
        return false
    end

    return true
end

local function test_stop_recording()
    print("\n🧪 测试停止录音...")
    local success, data = http_request("POST", "/api/recording/stop", {})

    if success then
        print("✅ 停止录音成功")
        print("   消息: " .. (data.message or "录音已停止"))
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

-- 手动测试模式
local function manual_test()
    print("🚀 ququ HTTP API 手动测试")
    print("=====================================")

    -- 检查依赖
    if not pcall(require, "socket.http") then
        print("❌ 缺少 socket.http 库，请先安装 LuaSocket")
        print("   Ubuntu/Debian: sudo apt-get install lua-socket")
        print("   macOS: brew install lua-socket")
        return
    end

    print("📋 可用命令:")
    print("  1. 健康检查")
    print("  2. 状态检查")
    print("  3. 开始录音")
    print("  4. 停止录音")
    print("  5. 完整测试")
    print("  6. 退出")

    while true do
        io.write("\n选择操作 (1-6): ")
        local choice = io.read()

        if choice == "1" then
            test_health()
        elseif choice == "2" then
            test_status()
        elseif choice == "3" then
            test_start_recording()
        elseif choice == "4" then
            test_stop_recording()
        elseif choice == "5" then
            print("\n🎤 请对着麦克风说话（按回车开始）...")
            io.read()
            test_start_recording()
            print("🎤 录音中...（按回车停止）...")
            io.read()
            test_stop_recording()
        elseif choice == "6" then
            print("👋 再见！")
            break
        else
            print("❌ 无效选择，请输入 1-6")
        end
    end
end

-- 快速测试模式
local function quick_test()
    print("🚀 ququ HTTP API 快速测试")
    print("=====================================")

    -- 检查依赖
    if not pcall(require, "socket.http") then
        print("❌ 缺少 socket.http 库，请先安装 LuaSocket")
        return
    end

    -- 运行基本测试
    local tests = {
        { name = "健康检查", func = test_health },
        { name = "状态检查", func = test_status },
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
        print("🎉 基本测试通过！可以开始录音测试了")
        print("\n💡 接下来可以:")
        print("   - 运行: lua test_nvim_simple.lua start")
        print("   - 说话后运行: lua test_nvim_simple.lua stop")
    else
        print("⚠️  部分测试失败，请检查 ququ 应用是否正在运行")
    end
end

-- 主函数
local function main()
    local args = {...}

    if #args == 0 then
        quick_test()
        return
    end

    local command = args[1]

    if command == "manual" then
        manual_test()
    elseif command == "start" then
        test_start_recording()
    elseif command == "stop" then
        test_stop_recording()
    elseif command == "status" then
        test_status()
    elseif command == "health" then
        test_health()
    else
        print("用法: lua test_nvim_simple.lua [command]")
        print("命令:")
        print("  manual  - 手动交互模式")
        print("  start   - 开始录音")
        print("  stop    - 停止录音")
        print("  status  - 检查状态")
        print("  health  - 健康检查")
        print("  (无参数) - 快速测试")
    end
end

-- 运行测试
main()