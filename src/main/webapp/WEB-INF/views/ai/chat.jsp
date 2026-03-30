<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>AI 助手</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        #chat-box {
            height: 480px;
            overflow-y: auto;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 16px;
        }
        .msg-user { text-align: right; margin-bottom: 12px; }
        .msg-ai   { text-align: left;  margin-bottom: 12px; }
        .bubble {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 16px;
            max-width: 75%;
            word-break: break-word;
            white-space: pre-wrap;
        }
        .bubble-user { background: #0d6efd; color: #fff; }
        .bubble-ai   { background: #fff; border: 1px solid #dee2e6; color: #333; }
        .thinking { color: #aaa; font-style: italic; font-size: 0.9em; }
    </style>
</head>
<body>
<div class="container mt-4" style="max-width: 760px;">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4>AI 用户助手</h4>
        <div class="d-flex gap-2">
            <button class="btn btn-sm btn-outline-danger" onclick="clearChat()">清空对话</button>
            <a href="/users" class="btn btn-sm btn-outline-secondary">← 返回用户列表</a>
        </div>
    </div>
    <p class="text-muted small">每次对话都会自动加载全部用户数据作为上下文，你可以询问任何关于用户的问题。</p>

    <div id="chat-box"></div>

    <div class="input-group mt-3">
        <input type="text" id="input" class="form-control" placeholder="输入你的问题..." autocomplete="off">
        <button class="btn btn-primary" id="send-btn" onclick="sendMessage()">发送</button>
    </div>
</div>

<script>
    const chatBox = document.getElementById('chat-box');
    const input   = document.getElementById('input');
    const sendBtn = document.getElementById('send-btn');

    function clearChat() {
        fetch('/ai/clear', { method: 'POST' }).then(() => {
            chatBox.innerHTML = '';
        });
    }

    input.addEventListener('keydown', e => { if (e.key === 'Enter') sendMessage(); });

    function appendMsg(text, role) {
        const div = document.createElement('div');
        div.className = role === 'user' ? 'msg-user' : 'msg-ai';
        const bubble = document.createElement('span');
        bubble.className = 'bubble ' + (role === 'user' ? 'bubble-user' : 'bubble-ai');
        bubble.textContent = text;
        div.appendChild(bubble);
        chatBox.appendChild(div);
        chatBox.scrollTop = chatBox.scrollHeight;
        return bubble;
    }

    function sendMessage() {
        const msg = input.value.trim();
        if (!msg) return;

        appendMsg(msg, 'user');
        input.value = '';
        sendBtn.disabled = true;

        const thinkingBubble = appendMsg('思考中...', 'ai');
        thinkingBubble.classList.add('thinking');

        fetch('/ai/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'message=' + encodeURIComponent(msg)
        })
        .then(r => r.text())
        .then(reply => {
            thinkingBubble.classList.remove('thinking');
            thinkingBubble.textContent = reply;
        })
        .catch(() => {
            thinkingBubble.classList.remove('thinking');
            thinkingBubble.textContent = '请求失败，请稍后重试。';
        })
        .finally(() => { sendBtn.disabled = false; input.focus(); });
    }
</script>
</body>
</html>
