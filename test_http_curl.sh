#!/bin/bash

# ququ HTTP API 测试脚本
# 使用 curl 进行测试

BASE_URL="http://127.0.0.1:38765"

# 检查 curl 是否可用
if ! command -v curl &> /dev/null; then
    echo "❌ curl 未安装，请先安装 curl"
    exit 1
fi

# 检查服务器是否运行
check_server() {
    if ! curl -s --max-time 2 "${BASE_URL}/api/health" > /dev/null; then
        echo "❌ ququ HTTP 服务器未运行"
        echo "   请确保 ququ 应用正在运行"
        exit 1
    fi
}

# 健康检查
test_health() {
    echo "🧪 测试健康检查..."
    local response=$(curl -s "${BASE_URL}/api/health")

    if [[ $? -eq 0 ]]; then
        echo "✅ 健康检查通过"
        echo "   响应: $response"
    else
        echo "❌ 健康检查失败"
        return 1
    fi
}

# 状态检查
test_status() {
    echo "\n🧪 测试状态检查..."
    local response=$(curl -s "${BASE_URL}/api/status")

    if [[ $? -eq 0 ]]; then
        echo "✅ 状态检查通过"
        echo "   响应: $response"
    else
        echo "❌ 状态检查失败"
        return 1
    fi
}

# 开始录音
test_start_recording() {
    echo "\n🧪 测试开始录音..."
    local response=$(curl -s -X POST "${BASE_URL}/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功"
        echo "   响应: $response"
    else
        echo "❌ 开始录音失败"
        return 1
    fi
}

# 停止录音
test_stop_recording() {
    echo "\n🧪 测试停止录音..."
    local response=$(curl -s -X POST "${BASE_URL}/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功"
        echo "   响应: $response"

        # 提取识别文本
        local text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "\n📝 识别结果:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi
}

# 完整工作流测试
test_full_workflow() {
    echo "\n🔄 测试完整工作流..."

    # 检查状态
    if ! test_status; then
        return 1
    fi

    # 开始录音
    if ! test_start_recording; then
        return 1
    fi

    echo "\n🎤 请对着麦克风说话（3秒后自动停止）..."
    sleep 3

    # 停止录音
    if ! test_stop_recording; then
        return 1
    fi

    echo "\n✅ 完整工作流测试完成！"
}

# 显示帮助
show_help() {
    echo "🚀 ququ HTTP API 测试脚本"
    echo "=========================="
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  health    - 健康检查"
    echo "  status    - 状态检查"
    echo "  start     - 开始录音"
    echo "  stop      - 停止录音"
    echo "  full      - 完整工作流测试"
    echo "  quick     - 快速测试（健康+状态）"
    echo "  help      - 显示帮助"
    echo "  (无参数)  - 运行所有测试"
}

# 快速测试
quick_test() {
    echo "🚀 ququ HTTP API 快速测试"
    echo "=========================="

    check_server

    local tests=("test_health" "test_status")
    local passed=0
    local total=${#tests[@]}

    for test_func in "${tests[@]}"; do
        if $test_func; then
            ((passed++))
        fi
    done

    echo ""
    echo "📊 测试结果: $passed/$total 通过"

    if [[ $passed -eq $total ]]; then
        echo "🎉 快速测试通过！可以开始录音测试了"
        echo ""
        echo "💡 接下来可以:"
        echo "   - 运行: $0 start"
        echo "   - 说话后运行: $0 stop"
    else
        echo "⚠️  部分测试失败"
    fi
}

# 运行所有测试
run_all_tests() {
    echo "🚀 ququ HTTP API 完整测试"
    echo "==========================="

    check_server

    local tests=("test_health" "test_status")
    local passed=0
    local total=${#tests[@]}

    for test_func in "${tests[@]}"; do
        echo ""
        if $test_func; then
            ((passed++))
        fi
    done

    echo ""
    echo "📊 测试结果: $passed/$total 通过"

    if [[ $passed -eq $total ]]; then
        echo "🎉 所有测试通过！ququ HTTP API 工作正常"
    else
        echo "⚠️  部分测试失败"
    fi
}

# 主函数
main() {
    local command="${1:-all}"

    case "$command" in
        "health")
            check_server
            test_health
            ;;
        "status")
            check_server
            test_status
            ;;
        "start")
            check_server
            test_start_recording
            ;;
        "stop")
            check_server
            test_stop_recording
            ;;
        "full")
            check_server
            test_full_workflow
            ;;
        "quick")
            quick_test
            ;;
        "help")
            show_help
            ;;
        "all")
            run_all_tests
            ;;
        *)
            echo "❌ 未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"

chmod +x test_http_curl.sh