<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Create Program</title>
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
      max-width: 800px;
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

    .alert {
      padding: 20px 24px;
      border-radius: 12px;
      margin-bottom: 24px;
      font-size: 15px;
      line-height: 1.6;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    .alert-info {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      color: white;
      border-left: 4px solid #3a9cef;
    }

    .alert-warning {
      background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
      color: #2d3436;
      border-left: 4px solid #e1b12c;
    }

    .alert a {
      color: inherit;
      font-weight: 700;
      text-decoration: underline;
    }

    .form-card {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 32px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .form-group {
      margin-bottom: 24px;
    }

    .form-label {
      display: block;
      font-size: 14px;
      font-weight: 600;
      color: #495057;
      margin-bottom: 8px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .form-control {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e9ecef;
      border-radius: 8px;
      font-size: 15px;
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

    .form-select {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e9ecef;
      border-radius: 8px;
      font-size: 15px;
      transition: all 0.3s;
      background: white;
      color: #495057;
      cursor: pointer;
    }

    .form-select:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .form-hint {
      font-size: 13px;
      color: #6c757d;
      margin-top: 6px;
      font-style: italic;
    }

    .btn-submit {
      width: 100%;
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
      margin-top: 8px;
    }

    .btn-submit:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
      transform: translateY(-3px);
      box-shadow: 0 8px 16px rgba(102,126,234,0.5);
    }

    .btn-submit:active {
      transform: translateY(-1px);
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
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

      .form-card {
        padding: 24px;
      }

      .form-row {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>✨ Create Program</h2>
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

    <a href="${pageContext.request.contextPath}/jsp/program-list.jsp" class="nav-link">← Back to Programs</a>

    <c:choose>
      <c:when test="${empty sessionScope.user}">
        <div class="alert alert-info">
          <strong>ℹ️ Authentication Required</strong><br/>
          Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> as a coach to create programs.
        </div>
      </c:when>
      <c:when test="${sessionScope.user.role ne 'COACH'}">
        <div class="alert alert-warning">
          <strong>⚠️ Access Restricted</strong><br/>
          Only users with role <strong>COACH</strong> can create programs. Your current role: <strong><c:out value="${sessionScope.user.role}"/></strong>
        </div>
      </c:when>
      <c:otherwise>
        <div class="form-card">
          <form method="post" action="${pageContext.request.contextPath}/programs">
            <div class="form-group">
              <label class="form-label">Program Title *</label>
              <input type="text" name="title" class="form-control" placeholder="e.g., Advanced Weight Loss Program" required/>
              <div class="form-hint">Give your program a clear, descriptive title</div>
            </div>

            <div class="form-group">
              <label class="form-label">Description</label>
              <textarea name="description" class="form-control" placeholder="Describe what this program offers, who it's for, and what results participants can expect..."></textarea>
              <div class="form-hint">Provide detailed information about the program</div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Duration (days)</label>
                <input type="number" name="duration_days" class="form-control" placeholder="30" min="1"/>
                <div class="form-hint">Program length in days</div>
              </div>

              <div class="form-group">
                <label class="form-label">Difficulty Level</label>
                <select name="difficulty" class="form-select">
                  <option value="">Select difficulty</option>
                  <option value="Beginner">Beginner</option>
                  <option value="Intermediate">Intermediate</option>
                  <option value="Advanced">Advanced</option>
                </select>
                <div class="form-hint">Target experience level</div>
              </div>
            </div>

            <div class="form-group">
              <label class="form-label">Price (₹)</label>
              <input type="number" step="0.01" name="price" class="form-control" placeholder="2999.00" min="0"/>
              <div class="form-hint">Set your program price in Indian Rupees</div>
            </div>

            <button type="submit" class="btn-submit">🚀 Create Program</button>
          </form>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</body>
</html>