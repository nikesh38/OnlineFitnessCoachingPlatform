<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Progress Tracker</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
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

    .btn-group-custom .btn {
      border-radius: 8px;
      font-weight: 500;
      transition: all 0.3s ease;
    }

    .btn-group-custom .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    /* Alert Styles */
    .alert {
      border: none;
      border-radius: 10px;
      box-shadow: var(--card-shadow);
      animation: slideIn 0.4s ease-out;
      font-weight: 500;
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
      background: linear-gradient(135deg, #d4fc79 0%, #96e6a1 100%);
      color: #155724;
    }

    .alert-danger {
      background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      color: #721c24;
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
    }

    /* Form Styles */
    .form-label {
      font-weight: 600;
      color: #4a5568;
      margin-bottom: 0.5rem;
      font-size: 0.9rem;
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

    /* Photo Thumbnail */
    .photo-thumb {
      max-width: 120px;
      max-height: 90px;
      object-fit: cover;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
      transition: all 0.3s ease;
      border: 3px solid #fff;
    }

    .photo-thumb:hover {
      transform: scale(1.15);
      box-shadow: 0 4px 12px rgba(0,0,0,0.25);
      z-index: 10;
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

    /* Button Styles */
    .btn-primary {
      background: var(--primary-gradient);
      border: none;
      border-radius: 8px;
      padding: 0.6rem 1.5rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 2px 4px rgba(102, 126, 234, 0.3);
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102, 126, 234, 0.4);
    }

    .btn-outline-primary, .btn-outline-secondary, .btn-outline-danger {
      border-radius: 8px;
      font-weight: 500;
      transition: all 0.3s ease;
      border-width: 2px;
    }

    .btn-outline-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
    }

    .btn-outline-secondary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
    }

    .btn-outline-danger:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
    }

    .btn-sm {
      padding: 0.4rem 0.8rem;
      font-size: 0.875rem;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 3rem 1rem;
      color: #718096;
    }

    .empty-state::before {
      content: '📊';
      display: block;
      font-size: 4rem;
      margin-bottom: 1rem;
      opacity: 0.5;
    }

    .small-muted {
      color: #718096;
      font-size: 0.9rem;
    }

    /* Form Card Special Styling */
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

    /* Responsive */
    @media (max-width: 768px) {
      .page-header {
        flex-direction: column;
        gap: 1rem;
      }

      .btn-group-custom {
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
      }

      .card-body {
        padding: 1.25rem;
      }

      .table {
        font-size: 0.875rem;
      }

      .photo-thumb {
        max-width: 80px;
        max-height: 60px;
      }
    }

    /* Loading State */
    .btn-primary.loading {
      pointer-events: none;
      position: relative;
      color: transparent;
    }

    .btn-primary.loading::after {
      content: '';
      position: absolute;
      width: 16px;
      height: 16px;
      top: 50%;
      left: 50%;
      margin-left: -8px;
      margin-top: -8px;
      border: 2px solid #ffffff;
      border-radius: 50%;
      border-top-color: transparent;
      animation: spin 0.6s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <div class="container my-4">

    <div class="page-header d-flex justify-content-between align-items-center">
      <h2>📈 Progress Tracker</h2>
      <div class="btn-group-custom d-flex gap-2">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm">🏠 Home</a>
        <a href="${pageContext.request.contextPath}/progress/export" class="btn btn-outline-secondary btn-sm">📥 Export CSV</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary btn-sm">🚪 Logout</a>
      </div>
    </div>

    <!-- Flash messages -->
    <c:if test="${param.msg == 'added'}"><div class="alert alert-success">✓ Progress entry added successfully!</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">✓ Progress entry updated successfully!</div></c:if>
    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-success">✓ Progress entry deleted successfully!</div></c:if>
    <c:if test="${param.msg == 'bad_file_type'}"><div class="alert alert-danger">✗ Only JPG, PNG, GIF allowed.</div></c:if>
    <c:if test="${param.msg == 'file_too_large'}"><div class="alert alert-danger">✗ File too large. Max 5-8MB.</div></c:if>
    <c:if test="${param.msg == 'upload_failed'}"><div class="alert alert-danger">✗ Upload failed. Please try again.</div></c:if>

    <!-- Add Progress Form -->
    <div class="card">
      <div class="card-body">
        <div class="form-card-header">
          <h5>➕ Add New Progress Entry</h5>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/progress" class="row g-3" enctype="multipart/form-data" id="progressForm">
          <div class="col-md-3">
            <label class="form-label">📅 Date</label>
            <input type="date" name="logDate" class="form-control" required/>
          </div>
          <div class="col-md-3">
            <label class="form-label">⚖️ Weight (kg)</label>
            <input type="number" step="0.1" name="weightKg" class="form-control" placeholder="72.5"/>
          </div>
          <div class="col-md-6">
            <label class="form-label">📷 Upload Photo (optional)</label>
            <input type="file" name="photoFile" accept="image/*" class="form-control" id="photoInput"/>
          </div>
          <div class="col-12">
            <label class="form-label">📝 Notes</label>
            <textarea name="notes" rows="3" class="form-control" placeholder="How you felt, workout summary, diet notes, achievements, etc."></textarea>
          </div>
          <div class="col-12 mt-3">
            <button type="submit" class="btn btn-primary">Add Progress Entry</button>
            <a href="${pageContext.request.contextPath}/trainee/dashboard" class="btn btn-outline-secondary ms-2">← Back to Dashboard</a>
          </div>
        </form>
      </div>
    </div>

    <!-- Progress List -->
    <div class="card">
      <div class="card-body">
        <h5 class="card-title">📋 Your Progress Entries</h5>

        <c:if test="${empty logs}">
          <div class="empty-state">
            <p class="mb-0">No progress entries yet. Start tracking your journey by adding your first entry above!</p>
          </div>
        </c:if>

        <c:if test="${not empty logs}">
          <div class="table-responsive">
            <table class="table table-sm align-middle">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Weight</th>
                  <th>Notes</th>
                  <th>Photo</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="pl" items="${logs}">
                  <tr>
                    <td><strong><c:out value="${pl.logDate}"/></strong></td>
                    <td><strong><c:out value="${pl.weightKg}"/> kg</strong></td>
                    <td style="max-width:400px;"><c:out value="${pl.notes}"/></td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty pl.photoUrl}">
                          <a href="${pl.photoUrl}" target="_blank">
                            <img src="${pl.photoUrl}" class="photo-thumb" onerror="this.onerror=null; this.src='${pl.photoUrl}';"/>
                          </a>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <a href="${pageContext.request.contextPath}/progress/edit?id=${pl.id}" class="btn btn-sm btn-outline-primary">✏️ Edit</a>
                      <form method="post" action="${pageContext.request.contextPath}/progress/delete" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this entry?');">
                        <input type="hidden" name="id" value="${pl.id}"/>
                        <button class="btn btn-sm btn-outline-danger">🗑️ Delete</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:if>

      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add loading animation on form submit
    document.getElementById('progressForm').addEventListener('submit', function(e) {
      const submitBtn = this.querySelector('button[type="submit"]');
      submitBtn.classList.add('loading');
      submitBtn.disabled = true;
    });

    // File input enhancement - show selected filename
    document.getElementById('photoInput').addEventListener('change', function(e) {
      const fileName = e.target.files[0]?.name;
      if (fileName) {
        const label = this.previousElementSibling;
        label.innerHTML = '📷 Photo Selected: <span style="color: #667eea;">' + fileName + '</span>';
      }
    });

    // Auto-dismiss alerts after 5 seconds
    document.querySelectorAll('.alert').forEach(function(alert) {
      setTimeout(function() {
        alert.style.transition = 'opacity 0.5s ease';
        alert.style.opacity = '0';
        setTimeout(function() {
          alert.remove();
        }, 500);
      }, 5000);
    });

    // Set today's date as default
    const dateInput = document.querySelector('input[type="date"]');
    if (dateInput && !dateInput.value) {
      const today = new Date().toISOString().split('T')[0];
      dateInput.value = today;
    }
  </script>
</body>
</html>