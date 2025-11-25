<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>My Enrollments</title>
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
      margin-bottom: 24px;
    }

    .nav-link:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
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

    .btn-primary {
      display: inline-block;
      padding: 12px 24px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-decoration: none;
      border-radius: 8px;
      font-weight: 500;
      font-size: 14px;
      transition: all 0.3s;
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
      position: relative;
      overflow: hidden;
    }

    .stat-card::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .stat-card:nth-child(2) {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      box-shadow: 0 4px 8px rgba(67,233,123,0.3);
    }

    .stat-card:nth-child(3) {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      box-shadow: 0 4px 8px rgba(79,172,254,0.3);
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

    .table-container {
      border-radius: 16px;
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
      padding: 16px;
      text-align: left;
      color: white;
      font-weight: 600;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    td {
      padding: 16px;
      border-bottom: 1px solid #f0f0f0;
      color: #495057;
      font-size: 14px;
    }

    tbody tr {
      transition: all 0.2s;
    }

    tbody tr:hover {
      background: #f8f9fa;
      transform: scale(1.01);
    }

    tbody tr:last-child td {
      border-bottom: none;
    }

    .program-id {
      font-family: 'Courier New', monospace;
      background: #f8f9fa;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 13px;
      color: #495057;
      font-weight: 600;
    }

    .status-badge {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .status-active {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .status-completed {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      color: white;
    }

    .status-cancelled {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
    }

    .status-pending {
      background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
      color: #2d3436;
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

      .stats-bar {
        grid-template-columns: 1fr;
      }

      .table-container {
        overflow-x: auto;
      }

      table {
        min-width: 500px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>📚 My Enrollments</h2>
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

    <c:choose>
      <c:when test="${empty enrollments}">
        <div class="empty-state">
          <div class="empty-state-icon">📋</div>
          <p>You have no enrollments yet.</p>
          <a href="${pageContext.request.contextPath}/programs" class="btn-primary">Browse Programs</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="stats-bar">
          <div class="stat-card">
            <div class="stat-label">Total Enrollments</div>
            <div class="stat-value">${enrollments.size()}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Active Programs</div>
            <div class="stat-value">
              <c:set var="activeCount" value="0"/>
              <c:forEach var="e" items="${enrollments}">
                <c:if test="${e.status == 'ACTIVE'}">
                  <c:set var="activeCount" value="${activeCount + 1}"/>
                </c:if>
              </c:forEach>
              ${activeCount}
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Completed</div>
            <div class="stat-value">
              <c:set var="completedCount" value="0"/>
              <c:forEach var="e" items="${enrollments}">
                <c:if test="${e.status == 'COMPLETED'}">
                  <c:set var="completedCount" value="${completedCount + 1}"/>
                </c:if>
              </c:forEach>
              ${completedCount}
            </div>
          </div>
        </div>

        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Program ID</th>
                <th>Start Date</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="e" items="${enrollments}">
                <tr>
                  <td><span class="program-id">#<c:out value="${e.programId}"/></span></td>
                  <td><c:out value="${e.startDate}"/></td>
                  <td>
                    <span class="status-badge
                      <c:choose>
                        <c:when test="${e.status == 'ACTIVE'}">status-active</c:when>
                        <c:when test="${e.status == 'COMPLETED'}">status-completed</c:when>
                        <c:when test="${e.status == 'CANCELLED'}">status-cancelled</c:when>
                        <c:otherwise>status-pending</c:otherwise>
                      </c:choose>">
                      <c:out value="${e.status}"/>
                    </span>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>