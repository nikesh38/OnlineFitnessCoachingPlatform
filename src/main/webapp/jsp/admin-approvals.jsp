<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Coach Approvals - Admin</title>
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
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
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

    .btn-success {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .btn-success:hover {
      background: linear-gradient(135deg, #38f9d7 0%, #43e97b 100%);
    }

    .btn-outline-danger {
      background: white;
      color: #f5576c;
      border: 2px solid #f5576c;
    }

    .btn-outline-danger:hover {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      border-color: transparent;
    }

    .btn-sm {
      padding: 6px 14px;
      font-size: 13px;
    }

    .alert {
      padding: 16px 20px;
      border-radius: 12px;
      margin-top: 20px;
      margin-bottom: 20px;
      font-size: 14px;
      font-weight: 500;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .alert-success {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
      border-left: 4px solid #2cc76a;
    }

    .alert-info {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      color: white;
      border-left: 4px solid #3a9cef;
    }

    .alert-danger {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      border-left: 4px solid #e4465d;
    }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #6c757d;
    }

    .empty-state-icon {
      font-size: 72px;
      margin-bottom: 20px;
      opacity: 0.3;
    }

    .empty-state-text {
      font-size: 18px;
      color: #495057;
    }

    .table-container {
      margin-top: 24px;
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
      padding: 16px;
      text-align: left;
      color: white;
      font-weight: 600;
      font-size: 14px;
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
      transition: background 0.2s;
    }

    tbody tr:hover {
      background: #f8f9fa;
    }

    tbody tr:last-child td {
      border-bottom: none;
    }

    .actions-cell {
      display: flex;
      gap: 8px;
      align-items: center;
    }

    .small {
      font-size: 13px;
      color: #6c757d;
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

      .header-buttons {
        width: 100%;
        flex-direction: column;
      }

      .btn {
        width: 100%;
        text-align: center;
      }

      .table-container {
        overflow-x: auto;
      }

      table {
        min-width: 600px;
      }

      .header h2 {
        font-size: 24px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <h2>Pending Coach Approvals</h2>
    <div class="header-buttons">
      <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/dashboard">Admin Home</a>
      <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
  </div>

  <c:if test="${param.msg == 'approved'}">
    <div class="alert alert-success">✓ Coach approved successfully.</div>
  </c:if>
  <c:if test="${param.msg == 'rejected'}">
    <div class="alert alert-info">ℹ Coach rejected/demoted to TRAINEE.</div>
  </c:if>
  <c:if test="${param.msg == 'approve_failed' || param.msg == 'reject_failed' || param.msg == 'server_error'}">
    <div class="alert alert-danger">✗ Operation failed (see server log).</div>
  </c:if>

  <c:if test="${empty pendingCoaches}">
    <div class="empty-state">
      <div class="empty-state-icon">✓</div>
      <p class="empty-state-text">No pending coach registrations.</p>
    </div>
  </c:if>

  <c:if test="${not empty pendingCoaches}">
    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Registered At</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${pendingCoaches}" varStatus="st">
            <tr>
              <td>${st.index + 1}</td>
              <td><c:out value="${c.name}"/></td>
              <td><c:out value="${c.email}"/></td>
              <td><c:out value="${c.createdAt}"/></td>
              <td>
                <div class="actions-cell">
                  <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline">
                    <input type="hidden" name="id" value="${c.id}" />
                    <input type="hidden" name="action" value="approve" />
                    <button type="submit" class="btn btn-sm btn-success" onclick="return confirm('Approve this coach?');">Approve</button>
                  </form>

                  <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}" />
                    <input type="hidden" name="action" value="reject" />
                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Reject and downgrade to TRAINEE?');">Reject</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>
</div>
</body>
</html>