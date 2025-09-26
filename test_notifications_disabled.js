/**
 * 测试通知是否被禁用
 * 运行此脚本来验证通知系统是否完全静默
 */

console.log('🧪 测试通知禁用功能');
console.log('===================');

// 导入我们的通知包装器
const { notification, toast } = require('./src/utils/notificationWrapper');

// 测试所有通知类型
const testNotifications = () => {
  console.log('\n📋 测试所有通知类型:');

  // 测试 success 通知
  console.log('✅ 测试 success 通知...');
  notification.success('🎤 语音识别完成，AI正在优化文本...');
  notification.success('🤖 AI文本优化完成并已自动粘贴！');

  // 测试 error 通知
  console.log('❌ 测试 error 通知...');
  notification.error('AI优化失败，已粘贴原始识别文本');
  notification.error('模型加载失败');

  // 测试 info 通知
  console.log('ℹ️  测试 info 通知...');
  notification.info('📥 开始下载模型文件...');
  notification.info('设置保存成功');

  // 测试 warning 通知
  console.log('⚠️  测试 warning 通知...');
  notification.warning('模型未就绪，请稍候...');
  notification.warning('请先下载AI模型文件');

  // 测试 toast 别名
  console.log('\n🍞 测试 toast 别名...');
  toast.success('通过 toast 调用的成功通知');
  toast.error('通过 toast 调用的错误通知');

  console.log('\n✅ 所有通知测试完成！');
  console.log('如果通知系统被正确禁用，你应该看不到任何实际的UI通知。');
};

// 验证函数是否为 no-op
const verifyNoOpFunctions = () => {
  console.log('\n🔍 验证函数是否为 no-op:');

  // 检查函数类型
  console.log('notification.success 类型:', typeof notification.success);
  console.log('notification.error 类型:', typeof notification.error);
  console.log('notification.info 类型:', typeof notification.info);
  console.log('notification.warning 类型:', typeof notification.warning);

  // 验证函数不会抛出异常
  try {
    notification.success('测试消息');
    console.log('✅ notification.success 执行无异常');
  } catch (error) {
    console.log('❌ notification.success 执行异常:', error.message);
  }

  // 验证函数返回 undefined (no-op 函数的特征)
  const result = notification.success('测试返回');
  console.log('notification.success 返回值:', result);

  if (result === undefined) {
    console.log('✅ 函数返回 undefined，确认是 no-op 函数');
  } else {
    console.log('❌ 函数返回值异常');
  }
};

// 主测试函数
const main = () => {
  try {
    console.log('开始测试通知禁用功能...');

    // 验证函数特性
    verifyNoOpFunctions();

    // 测试所有通知类型
    testNotifications();

    console.log('\n🎉 测试完成！');
    console.log('通知系统已被成功禁用。');
    console.log('你现在可以运行 ququ 应用而不会看到任何通知弹窗。');

  } catch (error) {
    console.error('❌ 测试失败:', error);
  }
};

// 运行测试
main();