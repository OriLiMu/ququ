const http = require('http');
const url = require('url');

class HttpServerManager {
  constructor(logger = null) {
    this.server = null;
    this.port = 38765; // 默认端口
    this.isRunning = false;
    this.logger = logger;
    this.windowManager = null;
    this.lastRecordingResult = null;
    this.isRecording = false;
    this.recordingStartTime = null;
  }

  /**
   * 设置窗口管理器
   */
  setWindowManager(windowManager) {
    this.windowManager = windowManager;
  }

  /**
   * 启动HTTP服务器
   */
  async start(port = 38765) {
    if (this.isRunning) {
      this.logger?.info(`HTTP服务器已在端口 ${this.port} 运行`);
      return { success: true, port: this.port };
    }

    this.port = port;

    return new Promise((resolve, reject) => {
      this.server = http.createServer((req, res) => {
        this.handleRequest(req, res);
      });

      this.server.listen(this.port, '127.0.0.1', () => {
        this.isRunning = true;
        this.logger?.info(`HTTP服务器启动成功，监听端口: ${this.port}`);
        resolve({ success: true, port: this.port });
      });

      this.server.on('error', (error) => {
        this.logger?.error(`HTTP服务器启动失败:`, error);
        reject({ success: false, error: error.message });
      });
    });
  }

  /**
   * 停止HTTP服务器
   */
  async stop() {
    if (!this.isRunning || !this.server) {
      return { success: true };
    }

    return new Promise((resolve) => {
      this.server.close(() => {
        this.isRunning = false;
        this.server = null;
        this.logger?.info('HTTP服务器已停止');
        resolve({ success: true });
      });
    });
  }

  /**
   * 处理HTTP请求
   */
  handleRequest(req, res) {
    // 设置CORS头
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Content-Type', 'application/json; charset=utf-8');

    // 处理OPTIONS预检请求
    if (req.method === 'OPTIONS') {
      res.writeHead(200);
      res.end();
      return;
    }

    const parsedUrl = url.parse(req.url, true);
    const path = parsedUrl.pathname;

    this.logger?.info(`收到HTTP请求: ${req.method} ${path}`);

    try {
      if (req.method === 'POST') {
        this.handlePostRequest(req, res, path);
      } else if (req.method === 'GET') {
        this.handleGetRequest(req, res, path);
      } else {
        this.sendError(res, 405, 'Method Not Allowed');
      }
    } catch (error) {
      this.logger?.error(`处理请求失败:`, error);
      this.sendError(res, 500, 'Internal Server Error');
    }
  }

  /**
   * 处理POST请求
   */
  handlePostRequest(req, res, path) {
    let body = '';

    req.on('data', chunk => {
      body += chunk.toString();
    });

    req.on('end', () => {
      try {
        const data = body ? JSON.parse(body) : {};

        switch (path) {
          case '/api/recording/start':
            this.handleRecordingStart(req, res, data);
            break;
          case '/api/recording/stop':
            this.handleRecordingStop(req, res, data);
            break;
          default:
            this.sendError(res, 404, 'Not Found');
        }
      } catch (error) {
        this.logger?.error(`解析请求体失败:`, error);
        this.sendError(res, 400, 'Bad Request');
      }
    });
  }

  /**
   * 处理GET请求
   */
  handleGetRequest(req, res, path) {
    switch (path) {
      case '/api/status':
        this.handleStatus(req, res);
        break;
      case '/api/health':
        this.handleHealth(req, res);
        break;
      default:
        this.sendError(res, 404, 'Not Found');
    }
  }

  /**
   * 处理录音开始请求
   */
  async handleRecordingStart(req, res, data) {
    try {
      if (!this.windowManager || !this.windowManager.mainWindow) {
        this.sendError(res, 503, 'Main window not available');
        return;
      }

      if (this.isRecording) {
        this.sendError(res, 400, 'Already recording');
        return;
      }

      this.logger?.info('收到开始录音请求');

      // 直接调用窗口中的录音函数 - 专门查找主录音按钮
      const result = await this.windowManager.mainWindow.webContents.executeJavaScript(`
        (async () => {
          try {
            // 调试日志 - 开始查找按钮
            console.log('开始录音 - 开始查找录音按钮...');

            // 查找主要的录音按钮 - 排除历史记录和设置按钮
            const buttons = document.querySelectorAll('button');
            console.log('开始录音 - 找到按钮数量:', buttons.length);
            let recordingButton = null;

            for (let button of buttons) {
              // 跳过历史记录和设置按钮（这些有特定的图标类名）
              const innerHTML = button.innerHTML || '';
              const className = button.className || '';
              const ariaLabel = button.getAttribute('aria-label') || '';

              // 调试每个按钮的详细信息
              console.log('开始录音 - 检查按钮:', {
                innerHTML: innerHTML.substring(0, 50),
                className: className.substring(0, 50),
                ariaLabel: ariaLabel,
                offsetWidth: button.offsetWidth,
                offsetHeight: button.offsetHeight,
                offsetParent: !!button.offsetParent
              });

              // 跳过历史记录按钮（包含 History 图标）
              if (innerHTML.includes('History') || ariaLabel.includes('历史')) {
                continue;
              }

              // 跳过设置按钮（包含 Settings 图标）
              if (innerHTML.includes('Settings') || ariaLabel.includes('设置')) {
                continue;
              }

              // 跳过热键测试按钮
              if (innerHTML.includes('🧪') || ariaLabel.includes('热键')) {
                continue;
              }

              // 查找录音按钮：在录音控制区域、有非拖拽类名、有大阴影（主按钮特征）
              const parent = button.closest('.text-center'); // 录音控制区域的父级
              const isNonDraggable = className.includes('non-draggable');
              const isShadowLarge = className.includes('shadow-lg'); // 主按钮有大阴影
              const hasTooltip = !!button.closest('[data-tooltip]') || !!button.parentElement?.getAttribute('data-tooltip');
              const isVisible = button.offsetParent !== null && button.offsetWidth > 50 && button.offsetHeight > 50;

              // 更严格的选择条件 - 必须同时满足多个条件
              if (parent && isNonDraggable && isShadowLarge && isVisible) {
                recordingButton = button;
                console.log('开始录音 - 找到主录音按钮:', {
                  parent: !!parent,
                  isNonDraggable: isNonDraggable,
                  isShadowLarge: isShadowLarge,
                  isVisible: isVisible,
                  hasTooltip: hasTooltip,
                  className: className,
                  ariaLabel: ariaLabel
                });
                break;
              }
            }

            if (recordingButton) {
              console.log('开始录音 - 点击找到的录音按钮');
              recordingButton.click();
              return { success: true, message: 'Recording started via main button' };
            } else {
              // 备用方案：查找最可能的主按钮
              const mainAreaButtons = Array.from(buttons).filter(btn => {
                const parent = btn.closest('.text-center');
                const isNonDraggable = btn.className.includes('non-draggable');
                const isLarge = btn.offsetWidth > 50 && btn.offsetHeight > 50;
                const isVisible = btn.offsetParent !== null;
                return parent && isNonDraggable && isLarge && isVisible;
              });

              if (mainAreaButtons.length > 0) {
                mainAreaButtons[0].click();
                return { success: true, message: 'Recording started via main area button' };
              } else {
                return { success: false, error: 'No suitable recording button found' };
              }
            }
          } catch (error) {
            return { success: false, error: error.message };
          }
        })()
      `);

      if (result && result.success) {
        this.isRecording = true;
        this.recordingStartTime = Date.now();
        this.sendSuccess(res, {
          message: 'Recording started',
          recordingId: Date.now().toString()
        });
      } else {
        this.sendError(res, 400, result?.error || 'Failed to start recording');
      }
    } catch (error) {
      this.logger?.error(`开始录音失败:`, error);
      this.sendError(res, 500, 'Internal Server Error');
    }
  }

  /**
   * 处理录音停止请求
   */
  async handleRecordingStop(req, res, data) {
    try {
      if (!this.windowManager || !this.windowManager.mainWindow) {
        this.sendError(res, 503, 'Main window not available');
        return;
      }

      if (!this.isRecording) {
        this.sendError(res, 400, 'Not currently recording');
        return;
      }

      this.logger?.info('收到停止录音请求');

      // 直接调用窗口中的录音函数 - 专门查找主录音按钮（与开始录音相同逻辑）
      const result = await this.windowManager.mainWindow.webContents.executeJavaScript(`
        (async () => {
          try {
            // 查找主要的录音按钮 - 排除历史记录和设置按钮
            const buttons = document.querySelectorAll('button');
            let recordingButton = null;

            for (let button of buttons) {
              // 跳过历史记录和设置按钮（这些有特定的图标类名）
              const innerHTML = button.innerHTML || '';
              const className = button.className || '';
              const ariaLabel = button.getAttribute('aria-label') || '';

              // 跳过历史记录按钮（包含 History 图标）
              if (innerHTML.includes('History') || ariaLabel.includes('历史')) {
                continue;
              }

              // 跳过设置按钮（包含 Settings 图标）
              if (innerHTML.includes('Settings') || ariaLabel.includes('设置')) {
                continue;
              }

              // 跳过热键测试按钮
              if (innerHTML.includes('🧪') || ariaLabel.includes('热键')) {
                continue;
              }

              // 查找录音按钮：在录音控制区域、有非拖拽类名、有大阴影（主按钮特征）
              const parent = button.closest('.text-center'); // 录音控制区域的父级
              const isNonDraggable = className.includes('non-draggable');
              const isShadowLarge = className.includes('shadow-lg'); // 主按钮有大阴影
              const hasTooltip = !!button.closest('[data-tooltip]') || !!button.parentElement?.getAttribute('data-tooltip');
              const isVisible = button.offsetParent !== null && button.offsetWidth > 50 && button.offsetHeight > 50;

              // 更严格的选择条件 - 必须同时满足多个条件
              if (parent && isNonDraggable && isShadowLarge && isVisible) {
                recordingButton = button;
                console.log('开始录音 - 找到主录音按钮:', {
                  parent: !!parent,
                  isNonDraggable: isNonDraggable,
                  isShadowLarge: isShadowLarge,
                  isVisible: isVisible,
                  hasTooltip: hasTooltip,
                  className: className,
                  ariaLabel: ariaLabel
                });
                break;
              }
            }

            if (recordingButton) {
              recordingButton.click();

              // 等待录音处理完成并获取文本结果
              await new Promise(resolve => setTimeout(resolve, 1000));

              // 尝试获取文本结果
              const textElement = document.querySelector('textarea, [contenteditable], .text-display, .result-text');
              const resultText = textElement ? textElement.value || textElement.textContent || textElement.innerText : '';

              return { success: true, text: resultText.trim() };
            } else {
              // 备用方案：查找最可能的主按钮
              const mainAreaButtons = Array.from(buttons).filter(btn => {
                const parent = btn.closest('.text-center');
                const isNonDraggable = btn.className.includes('non-draggable');
                const isLarge = btn.offsetWidth > 50 && btn.offsetHeight > 50;
                const isVisible = btn.offsetParent !== null;
                return parent && isNonDraggable && isLarge && isVisible;
              });

              if (mainAreaButtons.length > 0) {
                mainAreaButtons[0].click();

                // 等待录音处理完成
                await new Promise(resolve => setTimeout(resolve, 1000));

                // 尝试获取文本结果
                const textElement = document.querySelector('textarea, [contenteditable], .text-display, .result-text');
                const resultText = textElement ? textElement.value || textElement.textContent || textElement.innerText : '';

                return { success: true, text: resultText.trim() };
              } else {
                return { success: false, error: 'No suitable recording button found' };
              }
            }
          } catch (error) {
            return { success: false, error: error.message };
          }
        })()
      `);

      if (result && result.success) {
        this.isRecording = false;
        const duration = this.recordingStartTime ? Date.now() - this.recordingStartTime : 0;
        this.recordingStartTime = null;
        this.lastRecordingResult = result.text || '';

        this.sendSuccess(res, {
          message: 'Recording stopped',
          text: result.text || '',
          duration: duration
        });
      } else {
        this.sendError(res, 400, result?.error || 'Failed to stop recording');
      }
    } catch (error) {
      this.logger?.error(`停止录音失败:`, error);
      this.sendError(res, 500, 'Internal Server Error');
    }
  }

  /**
   * 处理状态查询请求
   */
  handleStatus(req, res) {
    const status = {
      server: 'running',
      port: this.port,
      isRecording: this.isRecording,
      lastRecordingResult: this.lastRecordingResult,
      recordingDuration: this.isRecording && this.recordingStartTime ?
        Date.now() - this.recordingStartTime : 0
    };

    this.sendSuccess(res, status);
  }

  /**
   * 处理健康检查请求
   */
  handleHealth(_req, res) {
    this.sendSuccess(res, {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    });
  }

  /**
   * 发送成功响应
   */
  sendSuccess(res, data) {
    res.writeHead(200);
    res.end(JSON.stringify({
      success: true,
      data: data,
      timestamp: new Date().toISOString()
    }));
  }

  /**
   * 发送错误响应
   */
  sendError(res, statusCode, message) {
    res.writeHead(statusCode);
    res.end(JSON.stringify({
      success: false,
      error: message,
      timestamp: new Date().toISOString()
    }));
  }

  /**
   * 获取服务器状态
   */
  getStatus() {
    return {
      isRunning: this.isRunning,
      port: this.port,
      hasRecordingManager: !!this.recordingManager
    };
  }

  /**
   * 获取最后录音结果
   */
  getLastRecordingResult() {
    return this.lastRecordingResult;
  }
}

module.exports = HttpServerManager;