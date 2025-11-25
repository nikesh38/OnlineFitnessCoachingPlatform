<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Workouts</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      --warning-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      --card-hover-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }

    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container {
      max-width: 1200px;
    }

    /* Header Styles */
    .page-header {
      background: white;
      padding: 1.5rem;
      border-radius: 12px;
      box-shadow: var(--card-shadow);
      margin-bottom: 2rem;
      animation: slideDown 0.4s ease-out;
    }

    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .page-header h2 {
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      font-weight: 700;
      margin: 0;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 1rem;
      font-weight: 500;
      color: #4a5568;
    }

    .user-info a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .user-info a:hover {
      color: #764ba2;
      text-decoration: underline;
    }

    /* Navigation */
    .nav-breadcrumb {
      background: white;
      padding: 1rem 1.5rem;
      border-radius: 10px;
      box-shadow: var(--card-shadow);
      margin-bottom: 2rem;
      animation: fadeIn 0.5s ease-out;
    }

    .nav-breadcrumb a {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .nav-breadcrumb a:hover {
      color: #764ba2;
    }

    /* Card Styles */
    .card {
      background: white;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      border: none;
      margin-bottom: 2rem;
      transition: all 0.3s ease;
      overflow: hidden;
      position: relative;
      animation: fadeIn 0.5s ease-out;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: var(--primary-gradient);
    }

    .card:hover {
      box-shadow: var(--card-hover-shadow);
      transform: translateY(-2px);
    }

    .card-body {
      padding: 2rem;
    }

    .card-title {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1.5rem;
      font-size: 1.25rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    /* Table Styles */
    .table {
      margin-bottom: 0;
    }

    .table thead {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .table thead th {
      border: none;
      padding: 1rem;
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.85rem;
      letter-spacing: 0.5px;
    }

    .table tbody tr {
      transition: all 0.2s ease;
      border-bottom: 1px solid #e2e8f0;
    }

    .table tbody tr:hover {
      background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
      transform: scale(1.01);
    }

    .table tbody td {
      padding: 1rem;
      vertical-align: middle;
    }

    /* Day Badge */
    .day-badge {
      background: var(--primary-gradient);
      color: white;
      padding: 0.5rem 1rem;
      border-radius: 20px;
      font-weight: 700;
      display: inline-block;
      min-width: 80px;
      text-align: center;
    }

    /* Media Link */
    .media-link {
      color: #667eea;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
    }

    .media-link:hover {
      color: #764ba2;
      text-decoration: underline;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 3rem 1rem;
      color: #718096;
    }

    .empty-state::before {
      content: '💪';
      display: block;
      font-size: 4rem;
      margin-bottom: 1rem;
      opacity: 0.5;
    }

    /* Info Box */
    .info-box {
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      border-left: 4px solid #f59e0b;
      padding: 1rem 1.5rem;
      border-radius: 8px;
      margin-bottom: 2rem;
      animation: fadeIn 0.5s ease-out;
    }

    .info-box p {
      margin: 0;
      color: #92400e;
      font-weight: 500;
    }

    .info-box a {
      color: #b45309;
      font-weight: 600;
    }

    /* Form Styles */
    .form-label {
      font-weight: 600;
      color: #4a5568;
      margin-bottom: 0.5rem;
      font-size: 0.95rem;
      display: flex;
      align-items: center;
      gap: 0.4rem;
    }

    .form-control, .form-select {
      border-radius: 8px;
      border: 2px solid #e2e8f0;
      padding: 0.6rem 0.75rem;
      transition: all 0.3s ease;
    }

    .form-control:focus, .form-select:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    textarea.form-control {
      min-height: 100px;
    }

    /* Button Styles */
    .btn-primary {
      background: var(--primary-gradient);
      border: none;
      border-radius: 10px;
      padding: 0.75rem 2rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(102, 126, 234, 0.4);
    }

    .btn-outline-secondary {
      border-radius: 8px;
      font-weight: 500;
      transition: all 0.3s ease;
      border-width: 2px;
    }

    .btn-outline-secondary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
    }

    /* Form Card Header */
    .form-card-header {
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
      padding: 1rem 2rem;
      border-bottom: 2px solid #e2e8f0;
      margin: -2rem -2rem 2rem -2rem;
    }

    .form-card-header h5 {
      margin: 0;
      color: #2d3748;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    /* Role Badge */
    .role-badge {
      background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
      color: white;
      padding: 0.3rem 0.8rem;
      border-radius: 12px;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .page-header {
        flex-direction: column;
        align-items: flex-start !important;
        gap: 1rem;
      }

      .card-body {
        padding: 1.25rem;
      }

      .table {
        font-size: 0.875rem;
      }

      .day-badge {
        min-width: 60px;
        padding: 0.4rem 0.8rem;
        font-size: 0.875rem;
      }
    }
  </style>
</head>
<body>
  <div class="container my-4">

    <!-- Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
      <h2>💪 Workouts for Program</h2>
      <div class="user-info">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <span>👤 Hello, <strong><c:out value="${sessionScope.user.name}"/></strong></span>
            <c:if test="${sessionScope.user.role eq 'COACH'}">
              <span class="role-badge">Coach</span>
            </c:if>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp">🔐 Login</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <!-- Breadcrumb Navigation -->
    <div class="nav-breadcrumb">
      <a href="${pageContext.request.contextPath}/jsp/program-list.jsp">← Back to Programs</a>
    </div>

    <!-- Workouts List -->
    <div class="card">
      <div class="card-body">
        <h5 class="card-title">📋 Workout Sessions</h5>

        <c:if test="${empty workouts}">
          <div class="empty-state">
            <p class="mb-0">No workouts yet for this program. <c:if test="${sessionScope.user.role eq 'COACH'}">Add your first workout below!</c:if></p>
          </div>
        </c:if>

        <c:if test="${not empty workouts}">
          <div class="table-responsive">
            <table class="table table-sm align-middle">
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
                    <td><strong><c:out value="${w.title}"/></strong></td>
                    <td style="max-width:500px;"><c:out value="${w.instructions}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty w.mediaUrl}">
                          <a href="${w.mediaUrl}" target="_blank" class="media-link">
                            🎬 View Media
                          </a>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>
      </div>
    </div>

    <!-- Add Workout Form (Coach Only) -->
    <c:choose>
      <c:when test="${empty sessionScope.user}">
        <div class="info-box">
          <p>🔒 Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> as a coach to add workouts.</p>
        </div>
      </c:when>
      <c:when test="${sessionScope.user.role ne 'COACH'}">
        <div class="info-box">
          <p>⚠️ Only coaches can add workouts. Your role: <strong><c:out value="${sessionScope.user.role}"/></strong></p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="card">
          <div class="card-body">
            <div class="form-card-header">
              <h5>➕ Add New Workout</h5>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/workouts" id="workoutForm">
              <input type="hidden" name="programId" value="${param.programId}"/>

              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label">📅 Day Number</label>
                  <input type="number" name="dayNumber" class="form-control" required placeholder="1" min="1"/>
                </div>

                <div class="col-md-6">
                  <label class="form-label">🏷️ Title</label>
                  <input type="text" name="title" class="form-control" required placeholder="e.g., Upper Body Strength"/>
                </div>

                <div class="col-12">
                  <label class="form-label">📝 Instructions</label>
                  <textarea name="instructions" class="form-control" rows="4" placeholder="Detailed workout instructions, sets, reps, rest periods, etc."></textarea>
                </div>

                <div class="col-12">
                  <label class="form-label">🎬 Media URL (optional)</label>
                  <input type="text" name="mediaUrl" class="form-control" placeholder="https://youtube.com/watch?v=..."/>
                  <div class="form-text">Link to demonstration video or supporting materials</div>
                </div>

                <div class="col-12 mt-3">
                  <button type="submit" class="btn btn-primary">Add Workout</button>
                  <button type="reset" class="btn btn-outline-secondary ms-2">Clear Form</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </c:otherwise>
    </c:choose>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add loading animation on form submit
    const form = document.getElementById('workoutForm');
    if (form) {
      form.addEventListener('submit', function(e) {
        const submitBtn = this.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Adding...';
        submitBtn.disabled = true;
      });
    }

    // Animate table rows on load
    document.addEventListener('DOMContentLoaded', function() {
      const rows = document.querySelectorAll('tbody tr');
      rows.forEach((row, index) => {
        row.style.opacity = '0';
        row.style.transform = 'translateY(10px)';
        setTimeout(() => {
          row.style.transition = 'all 0.3s ease';
          row.style.opacity = '1';
          row.style.transform = 'translateY(0)';
        }, index * 50);
      });
    });
  </script>
</body>
</html>