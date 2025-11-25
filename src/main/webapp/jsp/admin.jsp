<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Admin Panel</title>
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
      min-height: 500px;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 40px;
      padding-bottom: 24px;
      border-bottom: 2px solid #f0f0f0;
    }

    .header h1 {
      margin: 0;
      font-size: 36px;
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

    .user-info a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.2s;
    }

    .user-info a:hover {
      color: #764ba2;
    }

    .welcome-text {
      font-size: 18px;
      color: #495057;
      margin-bottom: 40px;
      padding: 20px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 12px;
      border-left: 4px solid #667eea;
    }

    .action-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 24px;
      margin-top: 32px;
    }

    .action-card {
      padding: 32px;
      border-radius: 16px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-decoration: none;
      transition: all 0.3s;
      box-shadow: 0 8px 16px rgba(102,126,234,0.3);
      position: relative;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .action-card::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .action-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 32px rgba(102,126,234,0.4);
    }

    .action-card:nth-child(2) {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      box-shadow: 0 8px 16px rgba(245,87,108,0.3);
    }

    .action-card:nth-child(2):hover {
      box-shadow: 0 16px 32px rgba(245,87,108,0.4);
    }

    .action-card-title {
      font-size: 24px;
      font-weight: 700;
      margin: 0;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .action-card-desc {
      font-size: 15px;
      opacity: 0.95;
      margin: 0;
      line-height: 1.6;
    }

    .action-card-icon {
      font-size: 48px;
      opacity: 0.2;
      position: absolute;
      bottom: 16px;
      right: 16px;
      font-weight: bold;
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

      .action-cards {
        grid-template-columns: 1fr;
      }

      .header h1 {
        font-size: 28px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Admin Panel</h1>
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

    <div class="welcome-text">
      Manage users, programs, and reports here.
    </div>

    <div class="action-cards">
      <a href="${pageContext.request.contextPath}/programs" class="action-card">
        <h2 class="action-card-title">Programs</h2>
        <p class="action-card-desc">View and manage all training programs</p>
        <div class="action-card-icon">📚</div>
      </a>

      <a href="${pageContext.request.contextPath}/admin/approvals" class="action-card">
        <h2 class="action-card-title">Approve Coaches</h2>
        <p class="action-card-desc">Review and approve pending coach registrations</p>
        <div class="action-card-icon">✓</div>
      </a>
    </div>
  </div>
</body>
</html>