<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Coach — Trainee Progress</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    .btn-outline-secondary {
      background: white;
      color: #495057;
      border: 2px solid #e9ecef;
    }

    .btn-outline-secondary:hover {
      background: #f8f9fa;
      border-color: #adb5bd;
    }

    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
    }

    .btn-sm {
      padding: 6px 14px;
      font-size: 13px;
    }

    .content-grid {
      display: grid;
      grid-template-columns: 380px 1fr;
      gap: 24px;
      margin-top: 24px;
    }

    .sidebar {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 24px;
      border-radius: 16px;
      height: fit-content;
      position: sticky;
      top: 20px;
    }

    .sidebar h5 {
      margin: 0 0 20px 0;
      font-size: 20px;
      font-weight: 700;
      color: #212529;
    }

    .trainee-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .trainee-card {
      background: white;
      padding: 16px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      transition: all 0.3s;
    }

    .trainee-card:hover {
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transform: translateY(-2px);
    }

    .trainee-info {
      margin-bottom: 12px;
    }

    .trainee-name {
      font-size: 16px;
      font-weight: 600;
      color: #212529;
      margin: 0 0 4px 0;
    }

    .trainee-email {
      font-size: 13px;
      color: #6c757d;
      margin: 0;
    }

    .trainee-actions {
      display: flex;
      gap: 8px;
    }

    .empty-state {
      text-align: center;
      padding: 40px 20px;
      color: #6c757d;
      background: white;
      border-radius: 12px;
      border: 2px dashed #dee2e6;
    }

    .empty-state-icon {
      font-size: 48px;
      margin-bottom: 12px;
      opacity: 0.3;
    }

    .main-content {
      background: white;
      padding: 32px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .progress-header {
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid #f0f0f0;
    }

    .progress-header h5 {
      margin: 0;
      font-size: 22px;
      font-weight: 700;
      color: #212529;
    }

    .progress-header .trainee-name-highlight {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .chart-container {
      background: #f8f9fa;
      padding: 24px;
      border-radius: 12px;
      margin-bottom: 32px;
    }

    .chart-container canvas {
      background: white;
      border-radius: 8px;
      padding: 16px;
    }

    .section-divider {
      border: none;
      height: 2px;
      background: linear-gradient(90deg, transparent, #e9ecef, transparent);
      margin: 32px 0;
    }

    .section-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 20px;
    }

    .section-header h6 {
      margin: 0;
      font-size: 18px;
      font-weight: 700;
      color: #212529;
    }

    .entries-table-container {
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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

    .weight-value {
      font-weight: 600;
      color: #212529;
    }

    .notes-cell {
      max-width: 300px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .photo-thumbnail {
      max-width: 80px;
      height: 60px;
      object-fit: cover;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      transition: all 0.3s;
      cursor: pointer;
    }

    .photo-thumbnail:hover {
      transform: scale(1.1);
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    .photo-link {
      display: inline-block;
      text-decoration: none;
    }

    .no-data {
      text-align: center;
      padding: 40px;
      color: #6c757d;
      font-style: italic;
    }

    @media (max-width: 1024px) {
      .content-grid {
        grid-template-columns: 1fr;
      }

      .sidebar {
        position: static;
      }
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

      .btn {
        width: 100%;
        text-align: center;
      }

      .trainee-actions {
        flex-direction: column;
      }

      .main-content {
        padding: 20px;
      }

      .entries-table-container {
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
      <h2>Trainees & Progress</h2>
      <div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
      </div>
    </div>

    <div class="content-grid">
      <div class="sidebar">
        <h5>👥 Your Trainees</h5>
        <c:choose>
          <c:when test="${empty trainees}">
            <div class="empty-state">
              <div class="empty-state-icon">👤</div>
              <p>No trainees enrolled yet.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="trainee-list">
              <c:forEach var="t" items="${trainees}">
                <div class="trainee-card">
                  <div class="trainee-info">
                    <p class="trainee-name"><c:out value="${t.name}"/></p>
                    <p class="trainee-email"><c:out value="${t.email}"/></p>
                  </div>
                  <div class="trainee-actions">
                    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/coach/trainees?userId=${t.id}">View</a>
                    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/coach/export-progress?userId=${t.id}">Export</a>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="main-content">
        <c:choose>
          <c:when test="${not empty selectedTrainee}">
            <div class="progress-header">
              <h5>📊 Progress for: <span class="trainee-name-highlight"><c:out value="${selectedTrainee.name}"/></span></h5>
            </div>

            <div class="chart-container">
              <canvas id="coachWeightChart" width="600" height="250"></canvas>
            </div>

            <hr class="section-divider"/>

            <div class="section-header">
              <h6>📝 Progress Entries</h6>
            </div>

            <c:choose>
              <c:when test="${empty logs}">
                <div class="no-data">No progress entries recorded yet.</div>
              </c:when>
              <c:otherwise>
                <div class="entries-table-container">
                  <table>
                    <thead>
                      <tr>
                        <th>Date</th>
                        <th>Weight (kg)</th>
                        <th>Notes</th>
                        <th>Photo</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="l" items="${logs}">
                        <tr>
                          <td><c:out value="${l.logDate}"/></td>
                          <td><span class="weight-value"><c:out value="${l.weightKg}"/> kg</span></td>
                          <td>
                            <div class="notes-cell" title="${l.notes}">
                              <c:choose>
                                <c:when test="${not empty l.notes}">
                                  <c:out value="${l.notes}"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                              </c:choose>
                            </div>
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${not empty l.photoUrl}">
                                <a href="${l.photoUrl}" target="_blank" class="photo-link">
                                  <img src="${fn:replace(l.photoUrl, '/uploads/progress/', '/uploads/progress/thumb_')}"
                                       alt="Progress photo"
                                       class="photo-thumbnail"/>
                                </a>
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
          </c:when>
          <c:otherwise>
            <div class="empty-state" style="margin-top: 60px;">
              <div class="empty-state-icon">📈</div>
              <p style="font-size: 16px;">Select a trainee from the list to view their progress</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <script>
    (function loadChart() {
      const params = new URLSearchParams(window.location.search);
      const userId = params.get('userId');
      if (!userId) return;

      fetch('${pageContext.request.contextPath}/progress/stats?userId=' + userId)
        .then(r => r.ok ? r.json() : Promise.reject(r.status))
        .then(json => {
          const labels = json.labels || [];
          const data = json.avgWeights || [];
          const ctx = document.getElementById('coachWeightChart').getContext('2d');

          new Chart(ctx, {
            type: 'line',
            data: {
              labels: labels,
              datasets: [{
                label: 'Avg weight (kg)',
                data: data,
                borderColor: '#667eea',
                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                borderWidth: 3,
                tension: 0.4,
                fill: true,
                pointRadius: 5,
                pointBackgroundColor: '#667eea',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointHoverRadius: 7
              }]
            },
            options: {
              responsive: true,
              maintainAspectRatio: false,
              plugins: {
                legend: {
                  display: true,
                  labels: {
                    font: { size: 13, weight: '500' },
                    color: '#495057',
                    padding: 15
                  }
                }
              },
              scales: {
                x: {
                  grid: { display: false },
                  ticks: { color: '#6c757d', font: { size: 12 } }
                },
                y: {
                  beginAtZero: false,
                  grid: { color: '#f0f0f0' },
                  ticks: { color: '#6c757d', font: { size: 12 } }
                }
              }
            }
          });
        })
        .catch(err => console.error('stats err', err));
    })();
  </script>
</body>
</html>