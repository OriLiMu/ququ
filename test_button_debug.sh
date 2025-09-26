#!/bin/bash

# ququ 按钮选择调试脚本

echo "🔍 ququ 按钮选择调试工具"
echo "======================="
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试开始录音
test_start() {
    echo ""
    echo "🎤 测试开始录音..."
    echo "请观察应用界面，检查是否："
    echo "✅ 正确：主录音按钮被点击（开始录音动画）"
    echo "❌ 错误：历史记录窗口弹出"
    echo ""

    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ HTTP 请求成功"
        echo "响应: $response"
        echo ""
        echo "💡 查看应用控制台输出以获取按钮选择详情"
    else
        echo "❌ HTTP 请求失败"
    fi
}

# 测试停止录音
test_stop() {
    echo ""
    echo "⏹️  测试停止录音..."

    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功"
        echo "响应: $response"

        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo ""
            echo "📝 识别结果:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
    fi
}

# 快速测试
quick_test() {
    check_app
    test_start

    echo ""
    echo "等待3秒后自动停止录音..."
    sleep 3

    test_stop

    echo ""
    echo "测试完成！根据观察结果："
    echo "- 如果开始录音时弹出历史记录窗口：按钮选择逻辑有问题"
    echo "- 如果开始录音时有录音动画：按钮选择正确"
}

# 主函数
if [[ "${1:-quick}" == "quick" ]]; then
    quick_test
else
    check_app
    case "$1" in
        "start")
            test_start
            ;;
        "stop")
            test_stop
            ;;
        *)
            echo "用法: $0 [start|stop|quick]"
            echo "默认: quick（完整测试）"
            ;;
    esac
fi