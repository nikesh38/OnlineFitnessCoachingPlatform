<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Admin Dashboard</title>
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
      padding: 32px;
    }

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32px;
      padding-bottom: 20px;
      border-bottom: 2px solid #f0f0f0;
    }

    .header h1 {
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
      font-weight: 600;
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

    .top-links {
      margin-bottom: 24px;
      padding: 16px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 12px;
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    .top-links a {
      color: #495057;
      text-decoration: none;
      padding: 8px 16px;
      border-radius: 8px;
      background: white;
      transition: all 0.3s;
      font-weight: 500;
      font-size: 14px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    .top-links a:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .stats {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 20px;
      margin-bottom: 32px;
    }

    .stat {
      padding: 24px;
      border-radius: 16px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      box-shadow: 0 8px 16px rgba(102,126,234,0.3);
      transition: transform 0.3s, box-shadow 0.3s;
      position: relative;
      overflow: hidden;
    }

    .stat::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .stat:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(102,126,234,0.4);
    }

    .stat:nth-child(2) {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      box-shadow: 0 8px 16px rgba(245,87,108,0.3);
    }

    .stat:nth-child(2):hover {
      box-shadow: 0 12px 24px rgba(245,87,108,0.4);
    }

    .stat:nth-child(3) {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      box-shadow: 0 8px 16px rgba(79,172,254,0.3);
    }

    .stat:nth-child(3):hover {
      box-shadow: 0 12px 24px rgba(79,172,254,0.4);
    }

    .stat:nth-child(4) {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      box-shadow: 0 8px 16px rgba(67,233,123,0.3);
    }

    .stat:nth-child(4):hover {
      box-shadow: 0 12px 24px rgba(67,233,123,0.4);
    }

    .stat h3 {
      margin: 0 0 12px 0;
      font-size: 14px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      opacity: 0.95;
    }

    .stat p {
      font-size: 36px;
      margin: 0;
      font-weight: 700;
      text-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .small-muted {
      color: rgba(255,255,255,0.85);
      font-size: 13px;
      margin-top: 8px;
      font-weight: 400;
    }

    .chart-row {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
      gap: 24px;
      margin: 32px 0;
    }

    .chart-card {
      padding: 24px;
      border-radius: 16px;
      background: white;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: box-shadow 0.3s;
    }

    .chart-card:hover {
      box-shadow: 0 8px 24px rgba(0,0,0,0.12);
    }

    .chart-card h4 {
      margin: 0 0 20px 0;
      font-size: 18px;
      font-weight: 600;
      color: #212529;
    }

    .chart-card .small-muted {
      color: #6c757d;
      font-size: 13px;
      margin-top: 12px;
    }

    hr {
      border: none;
      height: 2px;
      background: linear-gradient(90deg, transparent, #e9ecef, transparent);
      margin: 40px 0;
    }

    h3 {
      font-size: 24px;
      font-weight: 600;
      color: #212529;
      margin: 32px 0 20px 0;
    }

    table {
      border-collapse: collapse;
      width: 100%;
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    th {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-align: left;
      padding: 16px;
      font-weight: 600;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    td {
      padding: 14px 16px;
      border-bottom: 1px solid #f0f0f0;
      color: #495057;
      font-size: 14px;
    }

    tr:last-child td {
      border-bottom: none;
    }

    tr:hover td {
      background: #f8f9fa;
    }

    .btn {
      padding: 8px 16px;
      border-radius: 8px;
      border: none;
      cursor: pointer;
      font-weight: 500;
      font-size: 13px;
      transition: all 0.3s;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }

    .btn-success {
      background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      color: white;
    }

    .btn-success:hover {
      background: linear-gradient(135deg, #38f9d7 0%, #43e97b 100%);
    }

    .btn-danger {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
    }

    .btn-danger:hover {
      background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
    }

    @media (max-width: 768px) {
      .container {
        padding: 20px;
      }

      .header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
      }

      .stats {
        grid-template-columns: 1fr;
      }

      .chart-row {
        grid-template-columns: 1fr;
      }

      table {
        font-size: 12px;
      }

      th, td {
        padding: 10px;
      }
    }
  </style>

  <!-- Chart.js CDN -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Admin Dashboard</h1>
      <div>
        <c:if test="${not empty sessionScope.user}">
          <div class="user-info">
            <span>Admin: <strong><c:out value="${sessionScope.user.name}"/></strong></span>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
          </div>
        </c:if>
      </div>
    </div>

    <div class="top-links">
      <a href="${pageContext.request.contextPath}/">Home</a>
      <a href="${pageContext.request.contextPath}/admin/approvals">Pending Approvals</a>
      <a href="${pageContext.request.contextPath}/admin/export?type=users">Export Users CSV</a>
      <a href="${pageContext.request.contextPath}/admin/export?type=enrollments">Export Enrollments CSV</a>
    </div>

    <!-- normalize totals: accept either direct attributes or stats map -->
    <c:choose>
      <c:when test="${not empty totalUsers}">
        <c:set var="totalUsersVal" value="${totalUsers}"/>
      </c:when>
      <c:otherwise>
        <c:set var="totalUsersVal" value="${stats.totalUsers}"/>
      </c:otherwise>
    </c:choose>

    <c:choose>
      <c:when test="${not empty totalPrograms}">
        <c:set var="totalProgramsVal" value="${totalPrograms}"/>
      </c:when>
      <c:otherwise>
        <c:set var="totalProgramsVal" value="${stats.totalPrograms}"/>
      </c:otherwise>
    </c:choose>

    <c:choose>
      <c:when test="${not empty totalEnrollments}">
        <c:set var="totalEnrollmentsVal" value="${totalEnrollments}"/>
      </c:when>
      <c:otherwise>
        <c:set var="totalEnrollmentsVal" value="${stats.totalEnrollments}"/>
      </c:otherwise>
    </c:choose>

    <div class="stats" role="region" aria-label="admin-stats">
      <div class="stat">
        <h3>Total Users</h3>
        <p><strong><c:out value="${totalUsersVal != null ? totalUsersVal : 0}"/></strong></p>
      </div>

      <div class="stat">
        <h3>Total Programs</h3>
        <p><strong><c:out value="${totalProgramsVal != null ? totalProgramsVal : 0}"/></strong></p>
      </div>

      <div class="stat">
        <h3>Total Enrollments</h3>
        <p><strong><c:out value="${totalEnrollmentsVal != null ? totalEnrollmentsVal : 0}"/></strong></p>
      </div>

      <div class="stat">
        <h3>Pending Coaches</h3>
        <p>
          <strong>
            <c:choose>
              <c:when test="${not empty pendingCoaches}"><c:out value="${fn:length(pendingCoaches)}"/></c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </strong>
        </p>
        <div class="small-muted">Pending coach registrations awaiting approval</div>
      </div>
    </div>

    <!-- charts -->
    <div class="chart-row" role="region" aria-label="charts">
      <div class="chart-card">
        <h4>Monthly Enrollments (last 12 months)</h4>
        <canvas id="monthlyChart" width="600" height="250" aria-label="monthly enrollments chart"></canvas>
        <div class="small-muted">Data from recent enrollments.</div>
      </div>

      <div class="chart-card">
        <h4>Program Popularity (top 10)</h4>
        <canvas id="popularityChart" width="600" height="250" aria-label="program popularity chart"></canvas>
        <div class="small-muted">Programs ordered by enrollment count.</div>
      </div>
    </div>

    <hr/>

    <h3>Pending Coach Requests</h3>
    <c:if test="${empty pendingCoaches}">
      <p>No pending coach registrations.</p>
    </c:if>
    <c:if test="${not empty pendingCoaches}">
      <table aria-label="pending-coaches-table">
        <tr><th>ID</th><th>Name</th><th>Email</th><th>Registered At</th><th>Action</th></tr>
        <c:forEach var="u" items="${pendingCoaches}">
          <tr>
            <td><c:out value="${u.id}"/></td>
            <td><c:out value="${u.name}"/></td>
            <td><c:out value="${u.email}"/></td>
            <td><c:out value="${u.createdAt}"/></td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline;">
                <input type="hidden" name="action" value="approve"/>
                <input type="hidden" name="id" value="${u.id}"/>
                <button type="submit" class="btn btn-success">Approve</button>
              </form>

              <form method="post" action="${pageContext.request.contextPath}/admin/approvals" style="display:inline; margin-left:6px;">
                <input type="hidden" name="action" value="reject"/>
                <input type="hidden" name="id" value="${u.id}"/>
                <button type="submit" class="btn btn-danger" onclick="return confirm('Reject and downgrade to TRAINEE?');">Reject</button>
              </form>
            </td>
          </tr>
        </c:forEach>
      </table>
    </c:if>

    <hr/>
    <h3>Recent Users (all)</h3>
    <table>
      <tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Approved</th><th>Created At</th></tr>
      <c:if test="${not empty recentUsers}">
        <c:forEach var="u" items="${recentUsers}" varStatus="s">
          <c:if test="${s.index lt 10}">
            <tr>
              <td><c:out value="${u.id}"/></td>
              <td><c:out value="${u.name}"/></td>
              <td><c:out value="${u.email}"/></td>
              <td><c:out value="${u.role}"/></td>
              <td><c:out value="${u.approved}"/></td>
              <td><c:out value="${u.createdAt}"/></td>
            </tr>
          </c:if>
        </c:forEach>
      </c:if>
    </table>

    <hr/>
    <h3>Recent Programs</h3>
    <table>
      <tr><th>ID</th><th>Title</th><th>Coach ID</th><th>Duration</th><th>Price</th></tr>
      <c:if test="${not empty recentPrograms}">
        <c:forEach var="p" items="${recentPrograms}" varStatus="s">
          <c:if test="${s.index lt 10}">
            <tr>
              <td><c:out value="${p.id}"/></td>
              <td><c:out value="${p.title}"/></td>
              <td><c:out value="${p.coachId}"/></td>
              <td><c:out value="${p.durationDays}"/></td>
              <td><c:out value="${p.price}"/></td>
            </tr>
          </c:if>
        </c:forEach>
      </c:if>
    </table>
  </div>

  <script>
    // fetch stats and render charts using Chart.js
    async function loadStats() {
      try {
        const resp = await fetch('${pageContext.request.contextPath}/admin/stats');
        if (!resp.ok) { console.error('Failed to load stats', resp.status); return; }
        const data = await resp.json();

        // monthly chart
        const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
        new Chart(monthlyCtx, {
          type: 'line',
          data: {
            labels: data.monthly?.labels || [],
            datasets: [{
              label: 'Enrollments',
              data: data.monthly?.data || [],
              fill: true,
              tension: 0.4,
              borderColor: '#667eea',
              backgroundColor: 'rgba(102, 126, 234, 0.1)',
              borderWidth: 3,
              pointBackgroundColor: '#667eea',
              pointBorderColor: '#fff',
              pointBorderWidth: 2,
              pointRadius: 4,
              pointHoverRadius: 6
            }]
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                display: true,
                labels: {
                  font: { size: 13, weight: '500' },
                  color: '#495057'
                }
              }
            },
            scales: {
              x: {
                display: true,
                grid: { display: false },
                ticks: { color: '#6c757d', font: { size: 12 } }
              },
              y: {
                display: true,
                beginAtZero: true,
                grid: { color: '#f0f0f0' },
                ticks: { color: '#6c757d', font: { size: 12 } }
              }
            }
          }
        });

        // popularity chart
        const popCtx = document.getElementById('popularityChart').getContext('2d');
        new Chart(popCtx, {
          type: 'bar',
          data: {
            labels: data.popularity?.labels || [],
            datasets: [{
              label: 'Enrollments',
              data: data.popularity?.data || [],
              backgroundColor: 'rgba(102, 126, 234, 0.8)',
              borderColor: '#667eea',
              borderWidth: 2,
              borderRadius: 8
            }]
          },
          options: {
            responsive: true,
            indexAxis: 'y',
            plugins: {
              legend: {
                display: true,
                labels: {
                  font: { size: 13, weight: '500' },
                  color: '#495057'
                }
              }
            },
            scales: {
              x: {
                beginAtZero: true,
                grid: { color: '#f0f0f0' },
                ticks: { color: '#6c757d', font: { size: 12 } }
              },
              y: {
                grid: { display: false },
                ticks: { color: '#6c757d', font: { size: 12 } }
              }
            }
          }
        });
      } catch (err) {
        console.error('Error loading admin stats', err);
      }
    }

    document.addEventListener('DOMContentLoaded', loadStats);
  </script>
</body>
</html>