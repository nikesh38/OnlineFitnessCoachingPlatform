<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Programs</title>
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
      max-width: 1400px;
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

    .nav-links {
      display: flex;
      gap: 12px;
      margin-bottom: 32px;
      flex-wrap: wrap;
    }

    .nav-link {
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
    }

    .nav-link:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .nav-link.primary {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
      border-color: transparent;
    }

    .nav-link.primary:hover {
      background: linear-gradient(135deg, #38f9d7 0%, #43e97b 100%);
    }

    .empty-state {
      text-align: center;
      padding: 80px 20px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 16px;
      border: 2px dashed #dee2e6;
    }

    .empty-state-icon {
      font-size: 80px;
      margin-bottom: 24px;
      opacity: 0.3;
    }

    .empty-state p {
      font-size: 18px;
      color: #6c757d;
      margin: 0 0 24px 0;
    }

    .programs-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 24px;
    }

    .program-card {
      background: white;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: all 0.3s;
      overflow: hidden;
      display: flex;
      flex-direction: column;
    }

    .program-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 12px 24px rgba(0,0,0,0.15);
    }

    .program-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 24px;
      position: relative;
      overflow: hidden;
    }

    .program-header::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .program-title {
      margin: 0;
      font-size: 20px;
      font-weight: 700;
      position: relative;
      z-index: 1;
    }

    .program-body {
      padding: 24px;
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .program-info-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid #f0f0f0;
    }

    .program-info-row:last-of-type {
      border-bottom: none;
      padding-bottom: 16px;
    }

    .info-label {
      font-size: 13px;
      color: #6c757d;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-weight: 600;
    }

    .info-value {
      font-size: 15px;
      color: #212529;
      font-weight: 600;
    }

    .coach-badge {
      font-family: 'Courier New', monospace;
      background: #f8f9fa;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 13px;
    }

    .difficulty-badge {
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
    }

    .difficulty-beginner {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .difficulty-intermediate {
      background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
      color: #2d3436;
    }

    .difficulty-advanced {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
    }

    .price-display {
      font-size: 24px;
      font-weight: 700;
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .program-actions {
      display: flex;
      gap: 8px;
      margin-top: auto;
      padding-top: 16px;
      border-top: 2px solid #f0f0f0;
    }

    .btn {
      flex: 1;
      padding: 10px 16px;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      font-size: 14px;
      transition: all 0.3s;
      text-decoration: none;
      text-align: center;
      display: inline-block;
    }

    .btn-outline {
      background: white;
      color: #667eea;
      border: 2px solid #667eea;
    }

    .btn-outline:hover {
      background: #667eea;
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(102,126,234,0.4);
    }

    .stats-bar {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 32px;
    }

    .stat-card {
      padding: 20px;
      border-radius: 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .stat-label {
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      opacity: 0.9;
      margin-bottom: 8px;
    }

    .stat-value {
      font-size: 32px;
      font-weight: 700;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
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

      .programs-grid {
        grid-template-columns: 1fr;
      }

      .nav-links {
        flex-direction: column;
      }

      .nav-link {
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>🎯 Available Programs</h2>
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

    <div class="nav-links">
      <a href="${pageContext.request.contextPath}/" class="nav-link">🏠 Home</a>
      <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="nav-link primary">✨ Create Program (Coaches)</a>
    </div>

    <c:choose>
      <c:when test="${empty programs}">
        <div class="empty-state">
          <div class="empty-state-icon">📋</div>
          <p>No programs available yet.</p>
          <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="nav-link primary">Create the First Program</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="stats-bar">
          <div class="stat-card">
            <div class="stat-label">Total Programs</div>
            <div class="stat-value">${programs.size()}</div>
          </div>
        </div>

        <div class="programs-grid">
          <c:forEach var="p" items="${programs}">
            <div class="program-card">
              <div class="program-header">
                <h3 class="program-title"><c:out value="${p.title}"/></h3>
              </div>

              <div class="program-body">
                <div class="program-info-row">
                  <span class="info-label">Coach</span>
                  <span class="info-value coach-badge">#<c:out value="${p.coachId}"/></span>
                </div>

                <div class="program-info-row">
                  <span class="info-label">Duration</span>
                  <span class="info-value"><c:out value="${p.durationDays}"/> days</span>
                </div>

                <div class="program-info-row">
                  <span class="info-label">Difficulty</span>
                  <span class="difficulty-badge
                    <c:choose>
                      <c:when test="${p.difficulty == 'Beginner'}">difficulty-beginner</c:when>
                      <c:when test="${p.difficulty == 'Intermediate'}">difficulty-intermediate</c:when>
                      <c:when test="${p.difficulty == 'Advanced'}">difficulty-advanced</c:when>
                    </c:choose>">
                    <c:out value="${p.difficulty}"/>
                  </span>
                </div>

                <div class="program-info-row">
                  <span class="info-label">Price</span>
                  <span class="price-display">₹ <c:out value="${p.price}"/></span>
                </div>

                <div class="program-actions">
                  <a href="${pageContext.request.contextPath}/workouts?programId=${p.id}" class="btn btn-outline">
                    View Workouts
                  </a>
                  <form style="display:inline; flex: 1;" method="post" action="${pageContext.request.contextPath}/enrollments">
                    <input type="hidden" name="programId" value="${p.id}"/>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">Enroll</button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>