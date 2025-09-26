/**
 * 通知包装器 - 禁用所有通知
 * 用于静默运行模式，不显示任何UI通知
 */

// 创建一个空的no-op函数
const noop = () => {};

// 创建禁用所有通知的包装器
export const notification = {
  success: noop,
  error: noop,
  info: noop,
  warning: noop,
  promise: noop,
  loading: noop,
  custom: noop,
  dismiss: noop
};

// 导出原始的toast函数，但包装为no-op
export const toast = notification;

// 兼容性导出
export default notification;

/**
 * 通知控制函数（保留接口但禁用功能）
 */
export const notificationControls = {
  enable: noop,
  disable: noop,
  isEnabled: () => false,
  isDisabled: () => true
};