<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    /* Form Card */
    .form-card {
      background: white;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      border: none;
      transition: all 0.3s ease;
      overflow: hidden;
    }

    .form-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: var(--primary-gradient);
    }

    .form-card:hover {
      box-shadow: var(--card-hover-shadow);
      transform: translateY(-2px);
    }

    .form-card .card-body {
      padding: 2rem;
    }

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

    /* Chart Card */
    .chart-card {
      background: white;
      padding: 2rem;
      border: none;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .chart-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: var(--success-gradient);
    }

    .chart-card:hover {
      box-shadow: var(--card-hover-shadow);
    }

    .chart-card h5 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1.5rem;
    }

    .small-muted {
      color: #718096;
      font-size: 0.875rem;
      font-style: italic;
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
      transform: scale(1.1);
      box-shadow: 0 4px 12px rgba(0,0,0,0.25);
    }

    /* Table Styles */
    .table-card {
      background: white;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      border: none;
      overflow: hidden;
    }

    .table-card .card-body {
      padding: 2rem;
    }

    .table-card h5 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1.5rem;
    }

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
      background: #f7fafc;
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

      .form-card .card-body {
        padding: 1.25rem;
      }

      .chart-card {
        padding: 1.25rem;
      }
    }
  </style>

  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

    <!-- Add Progress Form (multipart) -->
    <div class="card form-card mb-4 position-relative">
      <div class="card-body">
        <h5 class="mb-4">➕ Add New Progress Entry</h5>
        <form method="post" action="${pageContext.request.contextPath}/progress"
              class="row g-3" enctype="multipart/form-data">
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
            <input type="file" name="photoFile" accept="image/*" class="form-control"/>
          </div>

          <div class="col-12">
            <label class="form-label">📝 Notes</label>
            <textarea name="notes" rows="3" class="form-control"
                      placeholder="How you felt, workout summary, diet notes, etc."></textarea>
          </div>

          <div class="col-12 mt-3">
            <button class="btn btn-primary">Add Progress Entry</button>
            <a href="${pageContext.request.contextPath}/trainee/dashboard"
               class="btn btn-outline-secondary ms-2">← Back to Dashboard</a>
          </div>
        </form>
      </div>
    </div>

    <!-- Weight Chart -->
    <div class="chart-card mb-4">
      <h5>📊 Weight Progress Chart</h5>
      <canvas id="weightChart" width="800" height="250"></canvas>
      <div class="small-muted mt-3">Track your weight changes over time</div>
    </div>

    <!-- Progress List -->
    <div class="card table-card">
      <div class="card-body">
        <h5>📋 Your Progress Entries</h5>

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
                <c:forEach var="l" items="${logs}">
                  <tr>
                    <td><strong><c:out value="${l.logDate}"/></strong></td>
                    <td><strong><c:out value="${l.weightKg}"/> kg</strong></td>
                    <td style="max-width:400px;"><c:out value="${l.notes}"/></td>

                    <!-- thumbnail logic: derive thumb URL in thumbs folder -->
                    <td>
                      <c:choose>
                        <c:when test="${not empty l.photoUrl}">
                          <!-- expected photoUrl: /{ctx}/uploads/progress/full/<file> -->
                          <c:set var="thumbUrl" value="${fn:replace(l.photoUrl, '/uploads/progress/full/', '/uploads/progress/thumbs/')}" />
                          <a href="${l.photoUrl}" target="_blank">
                            <img src="${thumbUrl}" class="photo-thumb" onerror="this.onerror=null; this.src='${l.photoUrl}';"/>
                          </a>
                        </c:when>
                        <c:otherwise><span class="text-muted">-</span></c:otherwise>
                      </c:choose>
                    </td>

                    <td>
                      <a href="${pageContext.request.contextPath}/progress/edit?id=${l.id}"
                         class="btn btn-sm btn-outline-primary">✏️ Edit</a>

                      <form method="post" action="${pageContext.request.contextPath}/progress/delete"
                            style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this entry?');">
                        <input type="hidden" name="id" value="${l.id}"/>
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

  <script>
    // Chart.js: fetch data from /progress/data (servlet should return JSON {labels:[], data:[]})
    async function loadWeightChart() {
      try {
        const resp = await fetch('${pageContext.request.contextPath}/progress/data');
        if (!resp.ok) return;
        const json = await resp.json();
        const labels = json.labels || [];
        const data = json.data || [];

        if (!labels.length) {
          const ctx = document.getElementById('weightChart').getContext('2d');
          ctx.font = "16px 'Segoe UI'";
          ctx.fillStyle = "#718096";
          ctx.textAlign = "center";
          ctx.fillText("No progress data yet. Add entries to see your weight chart.", 400, 125);
          return;
        }

        new Chart(document.getElementById('weightChart').getContext('2d'), {
          type: 'line',
          data: {
            labels: labels,
            datasets: [{
              label: "Weight (kg)",
              data: data,
              borderColor: '#667eea',
              backgroundColor: 'rgba(102, 126, 234, 0.1)',
              borderWidth: 3,
              pointRadius: 5,
              pointBackgroundColor: '#667eea',
              pointBorderColor: '#fff',
              pointBorderWidth: 2,
              pointHoverRadius: 7,
              tension: 0.3,
              fill: true
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
              legend: {
                display: true,
                labels: {
                  font: {
                    size: 14,
                    family: "'Segoe UI', sans-serif"
                  }
                }
              }
            },
            scales: {
              y: {
                beginAtZero: false,
                grid: {
                  color: '#e2e8f0'
                },
                ticks: {
                  font: {
                    size: 12
                  }
                }
              },
              x: {
                grid: {
                  color: '#e2e8f0'
                },
                ticks: {
                  font: {
                    size: 12
                  }
                }
              }
            }
          }
        });

      } catch (err) { console.error(err); }
    }

    document.addEventListener("DOMContentLoaded", loadWeightChart);
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>