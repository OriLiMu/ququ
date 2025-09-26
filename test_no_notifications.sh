#!/bin/bash

# 测试通知禁用功能

echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"<tool_use_error>Expected `then` or `elif` or `else` or `fi` at '/bin/bash'.</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
  5. echo "🔇 测试通知禁用功能"
  6. echo "===================="
  7. echo ""
  8. echo "这个脚本将帮助你验证通知是否被完全禁用"
  9. echo ""
  10.
 11. # 检查应用是否运行
 12. check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"<tool_use_error>Expected `then` or `elif` or `else` or `fi` at '/bin/bash'.</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
  echo "🔇 测试通知禁用功能"
  echo "===================="
  echo ""
  echo "这个脚本将帮助你验证通知是否被完全禁用"
  echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"</tool_use_error>  1. #!/bin/bash
  2.
  3. # 测试通知禁用功能
  4.
echo "🔇 测试通知禁用功能"
echo "===================="
echo ""
echo "这个脚本将帮助你验证通知是否被完全禁用"
echo ""

# 检查应用是否运行
check_app() {
    if ! curl -s --max-time 2 "http://127.0.0.1:38765/api/health" > /dev/null; then
        echo "❌ ququ 应用未运行，请先启动应用"
        exit 1
    fi
    echo "✅ ququ 应用正在运行"
}

# 测试通知禁用
test_no_notifications() {
    echo ""
    echo "🧪 测试通知禁用..."
    echo ""
    echo "步骤："
    echo "1. 我将通过HTTP API触发一些操作"
    echo "2. 你应该不会看到任何通知弹窗"
    echo "3. 但功能应该仍然正常工作"
    echo ""

    # 开始录音
    echo "🎤 开始录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/start" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 开始录音成功（无通知）"
    else
        echo "❌ 开始录音失败"
        return 1
    fi

    echo ""
    echo "等待3秒让你说话..."
    sleep 3

    # 停止录音
    echo ""
    echo "⏹️  停止录音（不应显示通知）..."
    response=$(curl -s -X POST "http://127.0.0.1:38765/api/recording/stop" \
        -H "Content-Type: application/json" \
        -d '{}')

    if [[ $? -eq 0 ]]; then
        echo "✅ 停止录音成功（无通知）"

        # 提取识别文本
        text=$(echo "$response" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        if [[ -n "$text" ]]; then
            echo "📝 识别结果（无通知）:"
            echo "   $text"
        fi
    else
        echo "❌ 停止录音失败"
        return 1
    fi

    echo ""
    echo "✅ 测试完成！"
    echo ""
    echo "如果一切正常："
    echo "- 你不会看到任何通知弹窗"
    echo "- 但录音功能仍然工作"
    echo "- 识别结果仍然返回"
}

# 运行测试
check_app
test_no_notifications

echo ""
echo "🎉 通知禁用功能测试完成！"
echo "应用现在应该完全静默运行。"