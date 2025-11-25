<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Trainee Dashboard</title>
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

    .welcome-section {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 32px;
      border-radius: 16px;
      margin-bottom: 40px;
      border-left: 4px solid #667eea;
    }

    .welcome-section h2 {
      margin: 0 0 12px 0;
      font-size: 24px;
      color: #212529;
      font-weight: 700;
    }

    .welcome-section p {
      margin: 0;
      color: #6c757d;
      font-size: 15px;
      line-height: 1.6;
    }

    .action-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 24px;
      margin-bottom: 40px;
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
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      box-shadow: 0 8px 16px rgba(67,233,123,0.3);
    }

    .action-card:nth-child(2):hover {
      box-shadow: 0 16px 32px rgba(67,233,123,0.4);
    }

    .action-card:nth-child(3) {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      box-shadow: 0 8px 16px rgba(79,172,254,0.3);
    }

    .action-card:nth-child(3):hover {
      box-shadow: 0 16px 32px rgba(79,172,254,0.4);
    }

    .action-card-icon {
      font-size: 48px;
      margin-bottom: 8px;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
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

    .info-banner {
      background: white;
      padding: 20px 24px;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      display: flex;
      align-items: center;
      gap: 16px;
      border-left: 4px solid #4facfe;
    }

    .info-banner-icon {
      font-size: 32px;
      opacity: 0.8;
    }

    .info-banner-text {
      color: #6c757d;
      font-size: 14px;
      margin: 0;
      line-height: 1.5;
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

      .header h1 {
        font-size: 28px;
      }

      .action-cards {
        grid-template-columns: 1fr;
      }

      .welcome-section {
        padding: 24px;
      }

      .welcome-section h2 {
        font-size: 20px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Trainee Dashboard</h1>
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

    <div class="welcome-section">
      <h2>Welcome to Your Fitness Journey! 💪</h2>
      <p>Track your progress, browse training programs, and manage your enrollments all in one place. Start achieving your fitness goals today!</p>
    </div>

    <div class="action-cards">
      <a href="${pageContext.request.contextPath}/programs/list" class="action-card">
        <div class="action-card-icon">🏋️</div>
        <h3 class="action-card-title">Browse Programs</h3>
        <p class="action-card-desc">Discover and enroll in training programs tailored to your fitness goals</p>
      </a>

      <a href="${pageContext.request.contextPath}/enrollments" class="action-card">
        <div class="action-card-icon">📚</div>
        <h3 class="action-card-title">My Enrollments</h3>
        <p class="action-card-desc">View and manage all your active training programs and schedules</p>
      </a>

      <a href="${pageContext.request.contextPath}/progress" class="action-card">
        <div class="action-card-icon">📈</div>
        <h3 class="action-card-title">My Progress</h3>
        <p class="action-card-desc">Track your fitness journey with detailed progress logs and analytics</p>
      </a>
    </div>

    <div class="info-banner">
      <div class="info-banner-icon">ℹ️</div>
      <p class="info-banner-text">
        <strong>Note:</strong> You must be logged in to access these features. All links use your session data to provide a personalized experience.
      </p>
    </div>
  </div>
</body>
</html>