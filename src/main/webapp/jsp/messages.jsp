<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Messages</title>
  <style>
    * { box-sizing: border-box; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      margin: 0;
      padding: 20px;
      min-height: 100vh;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      padding: 40px;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      padding-bottom: 20px;
      border-bottom: 2px solid #f0f0f0;
    }

    .header h2 {
      margin: 0;
      font-size: 32px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      font-weight: 700;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 18px;
      background: #f8f9fa;
      border-radius: 24px;
      font-size: 14px;
      color: #495057;
    }

    .user-info strong {
      color: #212529;
    }

    .user-info a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.2s;
    }

    .user-info a:hover {
      color: #764ba2;
    }

    .nav-link {
      display: inline-block;
      padding: 10px 18px;
      background: white;
      color: #667eea;
      text-decoration: none;
      border-radius: 8px;
      border: 2px solid #e9ecef;
      font-weight: 500;
      font-size: 14px;
      transition: all 0.3s;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      margin-bottom: 32px;
    }

    .nav-link:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .content-grid {
      display: grid;
      grid-template-columns: 1fr 400px;
      gap: 24px;
    }

    .messages-section {
      background: #f8f9fa;
      border-radius: 16px;
      padding: 24px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .messages-header {
      margin-bottom: 20px;
    }

    .messages-header h3 {
      margin: 0;
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 12px;
      border: 2px dashed #dee2e6;
    }

    .empty-state-icon {
      font-size: 64px;
      margin-bottom: 16px;
      opacity: 0.3;
    }

    .empty-state p {
      font-size: 16px;
      color: #6c757d;
      margin: 0;
    }

    .messages-container {
      background: white;
      border-radius: 12px;
      padding: 20px;
      max-height: 600px;
      overflow-y: auto;
      box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
    }

    .message-bubble {
      margin-bottom: 16px;
      padding: 16px;
      border-radius: 12px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateY(10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .message-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
    }

    .message-sender {
      font-weight: 700;
      color: #212529;
      font-size: 14px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .message-time {
      font-size: 12px;
      color: #6c757d;
    }

    .message-text {
      color: #495057;
      font-size: 15px;
      line-height: 1.6;
      margin: 0;
    }

    .message-divider {
      border: none;
      height: 1px;
      background: #e9ecef;
      margin: 12px 0;
    }

    .send-section {
      background: white;
      border-radius: 16px;
      padding: 24px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      height: fit-content;
      position: sticky;
      top: 20px;
    }

    .send-section h3 {
      margin: 0 0 20px 0;
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: #495057;
      margin-bottom: 8px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .form-control {
      width: 100%;
      padding: 12px 14px;
      border: 2px solid #e9ecef;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s;
      background: white;
      color: #495057;
      font-family: inherit;
    }

    .form-control:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    textarea.form-control {
      resize: vertical;
      min-height: 120px;
    }

    .btn-send {
      width: 100%;
      padding: 12px 24px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-size: 15px;
      cursor: pointer;
      transition: all 0.3s;
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .btn-send:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(102,126,234,0.4);
    }

    .btn-send:active {
      transform: translateY(0);
    }

    /* Custom scrollbar */
    .messages-container::-webkit-scrollbar {
      width: 8px;
    }

    .messages-container::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 4px;
    }

    .messages-container::-webkit-scrollbar-thumb {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 4px;
    }

    .messages-container::-webkit-scrollbar-thumb:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
    }

    @media (max-width: 1024px) {
      .content-grid {
        grid-template-columns: 1fr;
      }

      .send-section {
        position: static;
      }
    }

    @media (max-width: 768px) {
      .container {
        padding: 24px;
      }

      .header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
      }

      .header h2 {
        font-size: 24px;
      }

      .messages-container {
        max-height: 400px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>💬 Messages</h2>
      <div>
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <div class="user-info">
              <span>Hello, <strong><c:out value="${sessionScope.user.name}"/></strong></span>
              <span>|</span>
              <a href="${pageContext.request.contextPath}/logout">Logout</a>
            </div>
          </c:when>
          <c:otherwise>
            <div class="user-info">
              <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/" class="nav-link">← Back to Home</a>

    <div class="content-grid">
      <div class="messages-section">
        <div class="messages-header">
          <h3>📬 Conversation</h3>
        </div>

        <c:choose>
          <c:when test="${empty messages}">
            <div class="empty-state">
              <div class="empty-state-icon">💭</div>
              <p>No messages yet. Start a conversation!</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="messages-container">
              <c:forEach var="m" items="${messages}">
                <div class="message-bubble">
                  <div class="message-header">
                    <span class="message-sender">User ID: <c:out value="${m.senderId}"/></span>
                    <span class="message-time"><c:out value="${m.sentAt}"/></span>
                  </div>
                  <p class="message-text"><c:out value="${m.message}"/></p>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="send-section">
        <h3>✉️ Send Message</h3>
        <form method="post" action="${pageContext.request.contextPath}/messages">
          <div class="form-group">
            <label class="form-label">Receiver ID</label>
            <input type="text"
                   name="receiverId"
                   class="form-control"
                   placeholder="Enter user ID to message"
                   required/>
          </div>

          <div class="form-group">
            <label class="form-label">Message</label>
            <textarea name="message"
                      class="form-control"
                      placeholder="Type your message here..."
                      required></textarea>
          </div>

          <button type="submit" class="btn-send">Send Message</button>
        </form>
      </div>
    </div>
  </div>
</body>
</html>