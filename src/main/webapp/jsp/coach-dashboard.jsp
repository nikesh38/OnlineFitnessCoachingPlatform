<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Coach Dashboard</title>

  <style>
    * { box-sizing: border-box; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      margin: 0;
      padding: 0;
      min-height: 100vh;
    }

    .topbar {
      background: rgba(255, 255, 255, 0.98);
      backdrop-filter: blur(10px);
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
      padding: 20px 0;
      position: sticky;
      top: 0;
      z-index: 100;
    }

    .topbar-inner {
      max-width: 1400px;
      margin: 0 auto;
      padding: 0 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .topbar h3 {
      margin: 0;
      font-size: 24px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      font-weight: 700;
    }

    .topbar a {
      text-decoration: none;
    }

    .topbar-subtitle {
      color: #6c757d;
      font-size: 13px;
      margin-top: 4px;
    }

    .topbar-right {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .user-badge {
      background: #f8f9fa;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 14px;
      color: #495057;
    }

    .user-badge strong {
      color: #212529;
    }

    .btn {
      padding: 10px 18px;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      font-weight: 500;
      font-size: 14px;
      transition: all 0.3s;
      text-decoration: none;
      display: inline-block;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      text-align: center;
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
    }

    .btn-success {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .btn-success:hover {
      background: linear-gradient(135deg, #38f9d7 0%, #43e97b 100%);
    }

    .btn-outline-secondary {
      background: white;
      color: #495057;
      border: 2px solid #dee2e6;
    }

    .btn-outline-secondary:hover {
      background: #f8f9fa;
      border-color: #adb5bd;
    }

    .btn-outline-primary {
      background: white;
      color: #667eea;
      border: 2px solid #667eea;
    }

    .btn-outline-primary:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
    }

    .btn-outline-success {
      background: white;
      color: #43e97b;
      border: 2px solid #43e97b;
    }

    .btn-outline-success:hover {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
      border-color: transparent;
    }

    .btn-outline-info {
      background: white;
      color: #4facfe;
      border: 2px solid #4facfe;
    }

    .btn-outline-info:hover {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      color: white;
      border-color: transparent;
    }

    .btn-light {
      background: #f8f9fa;
      color: #495057;
      border: 1px solid #e9ecef;
    }

    .btn-light:hover {
      background: #e9ecef;
    }

    .btn-sm {
      padding: 6px 14px;
      font-size: 13px;
    }

    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 32px 20px;
    }

    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .page-header h2 {
      margin: 0;
      font-size: 28px;
      color: #212529;
      font-weight: 700;
    }

    .page-header-subtitle {
      color: #6c757d;
      font-size: 14px;
      margin-top: 4px;
    }

    .filter-card {
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      margin-bottom: 32px;
    }

    .filter-form {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 16px;
      align-items: end;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .form-label {
      font-size: 13px;
      color: #6c757d;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .form-control, .form-select {
      padding: 10px 14px;
      border: 2px solid #e9ecef;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s;
      background: white;
      color: #495057;
    }

    .form-control:focus, .form-select:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .filter-actions {
      display: flex;
      gap: 8px;
      align-items: end;
    }

    .empty-state {
      background: white;
      padding: 60px 20px;
      text-align: center;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .empty-state-icon {
      font-size: 72px;
      margin-bottom: 20px;
      opacity: 0.3;
    }

    .empty-state p {
      color: #6c757d;
      font-size: 16px;
      margin-bottom: 20px;
    }

    .programs-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 24px;
    }

    .program-card {
      background: white;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: all 0.3s;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .program-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 12px 24px rgba(0,0,0,0.15);
    }

    .program-card-body {
      padding: 24px;
      flex: 1;
      display: flex;
      flex-direction: column;
    }

    .program-card-title {
      font-size: 20px;
      font-weight: 700;
      color: #212529;
      margin: 0 0 12px 0;
    }

    .program-meta {
      display: flex;
      gap: 12px;
      font-size: 13px;
      color: #6c757d;
      margin-bottom: 12px;
      flex-wrap: wrap;
    }

    .program-meta strong {
      color: #495057;
    }

    .program-description {
      color: #6c757d;
      font-size: 14px;
      line-height: 1.6;
      margin-bottom: 20px;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }

    .program-actions {
      margin-top: auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 16px;
      border-top: 1px solid #f0f0f0;
      gap: 8px;
      flex-wrap: wrap;
    }

    .program-action-buttons {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }

    .program-price {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .program-price .price {
      font-size: 18px;
      font-weight: 700;
      color: #212529;
    }

    .program-card-footer {
      padding: 12px 24px;
      background: #f8f9fa;
      font-size: 12px;
      color: #6c757d;
    }

    hr {
      border: none;
      height: 2px;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
      margin: 40px 0;
    }

    .quick-links-section {
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      margin-bottom: 32px;
    }

    .quick-links-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .quick-links-header h5 {
      margin: 0;
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    .quick-links-header .subtitle {
      font-size: 13px;
      color: #6c757d;
    }

    .quick-links {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    @media (max-width: 768px) {
      .topbar-inner {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
      }

      .topbar-right {
        width: 100%;
        justify-content: space-between;
      }

      .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
      }

      .filter-form {
        grid-template-columns: 1fr;
      }

      .programs-grid {
        grid-template-columns: 1fr;
      }

      .program-actions {
        flex-direction: column;
        align-items: flex-start;
      }

      .program-action-buttons {
        width: 100%;
      }

      .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <nav class="topbar">
    <div class="topbar-inner">
      <div>
        <a href="${pageContext.request.contextPath}/">
          <h3>OnlineFitnessCoaching</h3>
        </a>
        <div class="topbar-subtitle">Coach Dashboard</div>
      </div>

      <div class="topbar-right">
        <c:if test="${not empty sessionScope.user}">
          <div class="user-badge">Hello, <strong><c:out value="${sessionScope.user.name}"/></strong></div>
          <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary btn-sm">Logout</a>
        </c:if>
      </div>
    </div>
  </nav>

  <div class="container">
    <div class="page-header">
      <div>
        <h2>My Programs</h2>
        <div class="page-header-subtitle">Manage your programs, workouts and trainees</div>
      </div>
      <div>
        <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="btn btn-primary">Create Program</a>
      </div>
    </div>

    <!-- FILTERS / SEARCH -->
    <div class="filter-card">
      <form method="get" action="${pageContext.request.contextPath}/coach/dashboard" class="filter-form">
        <div class="form-group" style="grid-column: span 2;">
          <label class="form-label">Search</label>
          <input type="text" name="q" class="form-control" placeholder="Search title or description" value="${fn:escapeXml(q)}"/>
        </div>

        <div class="form-group">
          <label class="form-label">Difficulty</label>
          <select name="difficulty" class="form-select">
            <option value="ALL" ${"ALL".equals(difficulty) ? "selected" : ""}>All</option>
            <option value="Beginner" ${"Beginner".equals(difficulty) ? "selected" : ""}>Beginner</option>
            <option value="Intermediate" ${"Intermediate".equals(difficulty) ? "selected" : ""}>Intermediate</option>
            <option value="Advanced" ${"Advanced".equals(difficulty) ? "selected" : ""}>Advanced</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label">Min Days</label>
          <input type="number" name="minDuration" class="form-control" min="1" placeholder="Min" value="${minDuration}"/>
        </div>

        <div class="form-group">
          <label class="form-label">Max Days</label>
          <input type="number" name="maxDuration" class="form-control" min="1" placeholder="Max" value="${maxDuration}"/>
        </div>

        <div class="form-group">
          <label class="form-label">Max Price (₹)</label>
          <input type="number" step="0.01" min="0" name="maxPrice" class="form-control" placeholder="Max price" value="${maxPrice}"/>
        </div>

        <div class="form-group filter-actions">
          <button type="submit" class="btn btn-success btn-sm">Apply</button>
          <a href="${pageContext.request.contextPath}/coach/dashboard" class="btn btn-outline-secondary btn-sm">Reset</a>
        </div>
      </form>
    </div>

    <!-- PROGRAM CARDS -->
    <c:if test="${empty programs}">
      <div class="empty-state">
        <div class="empty-state-icon">📋</div>
        <p>No programs found matching your filters.</p>
        <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="btn btn-success">Create a program</a>
      </div>
    </c:if>

    <c:if test="${not empty programs}">
      <div class="programs-grid">
        <c:forEach var="p" items="${programs}">
          <div class="program-card">
            <div class="program-card-body">
              <h3 class="program-card-title"><c:out value="${p.title}"/></h3>
              <div class="program-meta">
                <span>Duration: <strong><c:out value="${p.durationDays}"/> days</strong></span>
                <span>•</span>
                <span>Difficulty: <strong><c:out value="${p.difficulty}"/></strong></span>
              </div>
              <p class="program-description"><c:out value="${p.description}"/></p>

              <div class="program-actions">
                <div class="program-action-buttons">
                  <a href="${pageContext.request.contextPath}/workouts?programId=${p.id}" class="btn btn-sm btn-outline-primary">Workouts</a>
                  <a href="${pageContext.request.contextPath}/enrollments?programId=${p.id}" class="btn btn-sm btn-outline-secondary">Enrollments</a>
                </div>
                <div class="program-price">
                  <a href="${pageContext.request.contextPath}/jsp/program-form.jsp?editId=${p.id}" class="btn btn-sm btn-light">Edit</a>
                  <span class="price">₹<c:out value="${p.price}"/></span>
                </div>
              </div>
            </div>
            <div class="program-card-footer">
              Created: <c:out value="${p.createdAt}"/>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <hr/>

    <div class="quick-links-section">
      <div class="quick-links-header">
        <h5>Quick links</h5>
        <div class="subtitle">Shortcuts for common tasks</div>
      </div>

      <div class="quick-links">
        <a class="btn btn-outline-success btn-sm" href="${pageContext.request.contextPath}/jsp/program-form.jsp">Create Program</a>
        <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/workouts">All Workouts</a>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/enrollments">My Enrollments</a>
        <a class="btn btn-outline-info btn-sm" href="${pageContext.request.contextPath}/messages">Messages</a>
      </div>
    </div>
  </div>
</body>
</html>