/**
 * 通知配置
 * 控制哪些通知消息显示给用户
 */

export const notificationConfig = {
  // 通知开关 - 设置为 true 禁用对应类型的通知
  disableNotifications: {
    aiOptimization: false,      // AI优化相关通知
    voiceRecognition: false,    // 语音识别通知
    modelStatus: false,         // 模型状态通知
    textOperations: false,      // 文本操作通知
    settings: false,            // 设置相关通知
    history: false,             // 历史记录通知
    errors: false,              // 错误通知
    all: false                  // 禁用所有通知
  },

  // 具体消息禁用列表 - 精确控制特定的通知消息
  disableSpecificMessages: [
    // 语音识别相关
    "🎤 语音识别完成，AI正在优化文本...",

    // AI优化相关
    "🤖 AI文本优化完成并已自动粘贴！",
    "AI优化失败，已粘贴原始识别文本",

    // 可以添加更多要禁用的具体消息...
  ],

  // 环境变量覆盖 - 允许通过环境变量快速控制
  get envOverride() {
    return {
      disableAll: process.env.DISABLE_NOTIFICATIONS === 'true',
      disableAI: process.env.DISABLE_AI_NOTIFICATIONS === 'true',
      disableVoice: process.env.DISABLE_VOICE_NOTIFICATIONS === 'true',
      disableErrors: process.env.DISABLE_ERROR_NOTIFICATIONS === 'true'
    };
  }
};

/**
 * 检查是否应该显示通知
 * @param {string} message - 通知消息内容
 * @param {string} type - 通知类型 (success, error, warning, info)
 * @returns {boolean} - 是否应该显示通知
 */
export function shouldShowNotification(message, type = 'info') {
  const { disableNotifications, disableSpecificMessages, envOverride } = notificationConfig;

  // 环境变量快速禁用
  if (envOverride.disableAll) return false;
  if (envOverride.disableAI && (message.includes('AI') || message.includes('优化'))) return false;
  if (envOverride.disableVoice && (message.includes('语音识别') || message.includes('🎤'))) return false;
  if (envOverride.disableErrors && type === 'error') return false;

  // 如果禁用所有通知
  if (disableNotifications.all) return false;

  // 如果消息在禁用列表中
  if (disableSpecificMessages.includes(message)) return false;

  // 根据类型检查
  if (message.includes('AI') && message.includes('优化') && disableNotifications.aiOptimization) return false;
  if (message.includes('语音识别') && disableNotifications.voiceRecognition) return false;
  if (message.includes('模型') && disableNotifications.modelStatus) return false;
  if ((message.includes('复制') || message.includes('粘贴') || message.includes('导出')) && disableNotifications.textOperations) return false;
  if (message.includes('设置') && disableNotifications.settings) return false;
  if (message.includes('历史') && disableNotifications.history) return false;
  if (type === 'error' && disableNotifications.errors) return false;

  return true;
}

/**
 * 快速禁用特定类型的通知
 * @param {Object} options - 禁用选项
 */
export function disableNotifications(options = {}) {
  const { ai, voice, errors, all } = options;

  if (all) {
    notificationConfig.disableNotifications.all = true;
    return;
  }

  if (ai) notificationConfig.disableNotifications.aiOptimization = true;
  if (voice) notificationConfig.disableNotifications.voiceRecognition = true;
  if (errors) notificationConfig.disableNotifications.errors = true;
}

/**
 * 重新启用通知
 */
export function enableNotifications() {
  notificationConfig.disableNotifications.all = false;
  notificationConfig.disableNotifications.aiOptimization = false;
  notificationConfig.disableNotifications.voiceRecognition = false;
  notificationConfig.disableNotifications.errors = false;
  notificationConfig.disableNotifications.modelStatus = false;
  notificationConfig.disableNotifications.textOperations = false;
  notificationConfig.disableNotifications.settings = false;
  notificationConfig.disableNotifications.history = false;
}