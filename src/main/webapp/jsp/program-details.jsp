<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Program - <c:out value="${program.title}"/></title>
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

    .header-buttons {
      display: flex;
      gap: 10px;
      align-items: center;
    }

    .header-buttons a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      font-size: 14px;
      padding: 10px 18px;
      border-radius: 8px;
      background: white;
      border: 2px solid #e9ecef;
      transition: all 0.3s;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .header-buttons a:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .header-buttons .separator {
      color: #dee2e6;
      font-weight: 300;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 32px;
    }

    .info-card {
      padding: 20px;
      border-radius: 12px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      transition: all 0.3s;
    }

    .info-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .info-label {
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: #6c757d;
      margin-bottom: 8px;
      font-weight: 600;
    }

    .info-value {
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    .price-card {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .price-card .info-label {
      color: rgba(255,255,255,0.9);
    }

    .price-card .info-value {
      color: white;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
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

    .difficulty-beginner .info-label,
    .difficulty-intermediate .info-label,
    .difficulty-advanced .info-label {
      color: rgba(255,255,255,0.9);
    }

    .difficulty-intermediate .info-label {
      color: rgba(45,52,54,0.7);
    }

    .difficulty-beginner .info-value,
    .difficulty-intermediate .info-value,
    .difficulty-advanced .info-value {
      color: white;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .difficulty-intermediate .info-value {
      color: #2d3436;
      text-shadow: none;
    }

    .section-divider {
      border: none;
      height: 2px;
      background: linear-gradient(90deg, transparent, #e9ecef, transparent);
      margin: 40px 0;
    }

    .section {
      margin-bottom: 40px;
    }

    .section-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
    }

    .section-header h3 {
      margin: 0;
      font-size: 24px;
      font-weight: 700;
      color: #212529;
    }

    .description-box {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 24px;
      border-radius: 12px;
      border-left: 4px solid #667eea;
      line-height: 1.8;
      color: #495057;
      font-size: 15px;
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

    .workouts-table-container {
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
    }

    thead {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    th {
      padding: 14px 16px;
      text-align: left;
      color: white;
      font-weight: 600;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    td {
      padding: 14px 16px;
      border-bottom: 1px solid #f0f0f0;
      color: #495057;
      font-size: 14px;
    }

    tbody tr {
      transition: background 0.2s;
    }

    tbody tr:hover {
      background: #f8f9fa;
    }

    tbody tr:last-child td {
      border-bottom: none;
    }

    .day-badge {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 20px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      font-weight: 600;
      font-size: 12px;
    }

    .workout-title {
      font-weight: 600;
      color: #212529;
    }

    .media-link {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.2s;
    }

    .media-link:hover {
      color: #764ba2;
      text-decoration: underline;
    }

    .enroll-section {
      background: white;
      padding: 32px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      text-align: center;
      margin-top: 40px;
    }

    .enroll-btn {
      width: 100%;
      max-width: 400px;
      padding: 16px 32px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 700;
      font-size: 16px;
      cursor: pointer;
      transition: all 0.3s;
      box-shadow: 0 6px 12px rgba(102,126,234,0.4);
    }

    .enroll-btn:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      transform: translateY(-3px);
      box-shadow: 0 8px 16px rgba(102,126,234,0.5);
    }

    .enroll-btn:active {
      transform: translateY(-1px);
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

      .header-buttons {
        width: 100%;
        flex-direction: column;
      }

      .header-buttons a {
        width: 100%;
        text-align: center;
      }

      .header-buttons .separator {
        display: none;
      }

      .info-grid {
        grid-template-columns: 1fr;
      }

      .workouts-table-container {
        overflow-x: auto;
      }

      table {
        min-width: 600px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>🏋️ <c:out value="${program.title}"/></h2>
      <div class="header-buttons">
        <a href="${pageContext.request.contextPath}/trainee/dashboard">Back to Dashboard</a>
        <span class="separator">|</span>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
      </div>
    </div>

    <div class="info-grid">
      <div class="info-card">
        <div class="info-label">Coach ID</div>
        <div class="info-value">#<c:out value="${program.coachId}"/></div>
      </div>

      <div class="info-card">
        <div class="info-label">Duration</div>
        <div class="info-value"><c:out value="${program.durationDays}"/> days</div>
      </div>

      <div class="info-card
        <c:choose>
          <c:when test="${program.difficulty == 'Beginner'}">difficulty-beginner</c:when>
          <c:when test="${program.difficulty == 'Intermediate'}">difficulty-intermediate</c:when>
          <c:when test="${program.difficulty == 'Advanced'}">difficulty-advanced</c:when>
        </c:choose>">
        <div class="info-label">Difficulty</div>
        <div class="info-value"><c:out value="${program.difficulty}"/></div>
      </div>

      <div class="info-card price-card">
        <div class="info-label">Price</div>
        <div class="info-value">₹ <c:out value="${program.price}"/></div>
      </div>
    </div>

    <hr class="section-divider"/>

    <div class="section">
      <div class="section-header">
        <h3>📝 Description</h3>
      </div>
      <div class="description-box">
        <c:out value="${program.description}"/>
      </div>
    </div>

    <hr class="section-divider"/>

    <div class="section">
      <div class="section-header">
        <h3>💪 Workouts</h3>
      </div>

      <c:choose>
        <c:when test="${empty workouts}">
          <div class="empty-state">
            <div class="empty-state-icon">🏃</div>
            <p>No workouts yet for this program.</p>
          </div>
        </c:when>
        <c:otherwise>
          <div class="workouts-table-container">
            <table>
              <thead>
                <tr>
                  <th>Day</th>
                  <th>Title</th>
                  <th>Instructions</th>
                  <th>Media</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="w" items="${workouts}">
                  <tr>
                    <td><span class="day-badge">Day <c:out value="${w.dayNumber}"/></span></td>
                    <td><span class="workout-title"><c:out value="${w.title}"/></span></td>
                    <td><c:out value="${w.instructions}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty w.mediaUrl}">
                          <a href="${w.mediaUrl}" target="_blank" class="media-link">View Media</a>
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <hr class="section-divider"/>

    <div class="enroll-section">
      <form method="post" action="${pageContext.request.contextPath}/enrollments">
        <input type="hidden" name="programId" value="${program.id}"/>
        <button type="submit" class="enroll-btn">🎯 Enroll in this program</button>
      </form>
    </div>
  </div>
</body>
</html>