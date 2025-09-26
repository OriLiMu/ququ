import React, { useState, useEffect } from 'react';

const HotkeyTest = () => {
  const [lastHotkeyTrigger, setLastHotkeyTrigger] = useState('无');
  const [triggerCount, setTriggerCount] = useState(0);
  const [isListening, setIsListening] = useState(false);
  const [logs, setLogs] = useState([]);

  const addLog = (message) => {
    const timestamp = new Date().toLocaleTimeString();
    setLogs(prev => [...prev, `[${timestamp}] ${message}`].slice(-10));
  };

  useEffect(() => {
    // 检查热键注册状态
    const checkHotkeyStatus = async () => {
      try {
        if (window.electronAPI && window.electronAPI.getCurrentHotkey) {
          const currentHotkey = await window.electronAPI.getCurrentHotkey();
          addLog(`当前热键: ${currentHotkey}`);
        } else {
          addLog('electronAPI 不可用');
        }
      } catch (error) {
        addLog(`获取热键状态失败: ${error.message}`);
      }
    };

    checkHotkeyStatus();

    // 监听热键触发事件
    let removeHotkeyListener = null;
    if (window.electronAPI && window.electronAPI.onHotkeyTriggered) {
      removeHotkeyListener = window.electronAPI.onHotkeyTriggered((event, data) => {
        const timestamp = new Date().toLocaleTimeString();
        setLastHotkeyTrigger(`${data.hotkey} - ${timestamp}`);
        setTriggerCount(prev => prev + 1);
        addLog(`热键触发: ${data.hotkey}`);
      });
      setIsListening(true);
      addLog('开始监听热键事件');
    } else {
      addLog('无法监听热键事件: electronAPI 不可用');
    }

    return () => {
      if (removeHotkeyListener) {
        removeHotkeyListener();
        addLog('停止监听热键事件');
      }
    };
  }, []);

  const handleManualTest = () => {
    addLog('手动测试 - 如果热键工作正常，请按 Ctrl+Shift+Space');
  };

  const clearLogs = () => {
    setLogs([]);
    setTriggerCount(0);
    setLastHotkeyTrigger('无');
  };

  return (
    <div style={{
      padding: '20px',
      border: '2px solid #ccc',
      borderRadius: '8px',
      margin: '10px',
      backgroundColor: '#f5f5f5'
    }}>
      <h3>🧪 热键测试组件</h3>

      <div style={{ marginBottom: '15px' }}>
        <p><strong>状态:</strong> {isListening ? '✅ 监听中' : '❌ 未监听'}</p>
        <p><strong>最后触发:</strong> {lastHotkeyTrigger}</p>
        <p><strong>触发次数:</strong> {triggerCount}</p>
      </div>

      <div style={{ marginBottom: '15px' }}>
        <button
          onClick={handleManualTest}
          style={{
            padding: '8px 16px',
            marginRight: '10px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          手动测试提示
        </button>

        <button
          onClick={clearLogs}
          style={{
            padding: '8px 16px',
            backgroundColor: '#6c757d',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          清除日志
        </button>
      </div>

      <div style={{
        backgroundColor: 'white',
        padding: '10px',
        borderRadius: '4px',
        maxHeight: '200px',
        overflowY: 'auto'
      }}>
        <h4>📋 事件日志:</h4>
        {logs.length === 0 ? (
          <p style={{ color: '#666' }}>暂无日志...</p>
        ) : (
          logs.map((log, index) => (
            <div key={index} style={{
              fontSize: '12px',
              marginBottom: '2px',
              fontFamily: 'monospace'
            }}>
              {log}
            </div>
          ))
        )}
      </div>

      <div style={{
        marginTop: '15px',
        padding: '10px',
        backgroundColor: '#e9ecef',
        borderRadius: '4px',
        fontSize: '14px'
      }}>
        <strong>使用说明:</strong>
        <ul style={{ margin: '5px 0', paddingLeft: '20px' }}>
          <li>确保应用处于焦点状态</li>
          <li>按下 Ctrl+Shift+Space 测试热键</li>
          <li>查看日志确认是否捕获到热键事件</li>
          <li>如果未捕获，请检查控制台错误信息</li>
        </ul>
      </div>
    </div>
  );
};

export default HotkeyTest;