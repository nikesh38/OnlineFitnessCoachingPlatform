<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Coach — Trainee Progress Analytics</title>
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
      background: white;
      color: #495057;
      border: 2px solid #e9ecef;
    }

    .btn:hover {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-color: transparent;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(102,126,234,0.3);
    }

    .selector-section {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 24px;
      border-radius: 12px;
      margin-bottom: 32px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    }

    .form-label {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: #495057;
      margin-bottom: 10px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .form-select {
      width: 100%;
      max-width: 500px;
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

    .summary-card {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 24px;
      border-radius: 12px;
      margin-bottom: 32px;
      box-shadow: 0 8px 16px rgba(102,126,234,0.3);
      position: relative;
      overflow: hidden;
    }

    .summary-card::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
      pointer-events: none;
    }

    .summary-content {
      position: relative;
      z-index: 1;
    }

    .summary-label {
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 1px;
      opacity: 0.9;
      margin-bottom: 8px;
    }

    .summary-text {
      font-size: 18px;
      font-weight: 600;
      line-height: 1.6;
      margin: 0;
    }

    .trend-positive {
      color: #43e97b;
    }

    .trend-negative {
      color: #f5576c;
    }

    .chart-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(600px, 1fr));
      gap: 24px;
    }

    .chart-card {
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      transition: all 0.3s;
    }

    .chart-card:hover {
      box-shadow: 0 8px 20px rgba(0,0,0,0.12);
      transform: translateY(-4px);
    }

    .chart-card h5 {
      margin: 0 0 20px 0;
      font-size: 18px;
      font-weight: 600;
      color: #212529;
      padding-bottom: 12px;
      border-bottom: 2px solid #f0f0f0;
    }

    .loading-state {
      text-align: center;
      padding: 60px 20px;
      color: #6c757d;
    }

    .loading-spinner {
      width: 48px;
      height: 48px;
      border: 4px solid #f0f0f0;
      border-top: 4px solid #667eea;
      border-radius: 50%;
      animation: spin 1s linear infinite;
      margin: 0 auto 20px;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 16px;
      border: 2px dashed #dee2e6;
    }

    .empty-state-icon {
      font-size: 72px;
      margin-bottom: 20px;
      opacity: 0.3;
    }

    .empty-state p {
      font-size: 16px;
      color: #6c757d;
      margin: 0;
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

      .form-select {
        max-width: 100%;
      }

      .chart-grid {
        grid-template-columns: 1fr;
      }

      .summary-text {
        font-size: 15px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h2>Trainee Progress Analytics</h2>
      <div>
        <a class="btn" href="${pageContext.request.contextPath}/coach/dashboard">Back to Dashboard</a>
      </div>
    </div>

    <c:choose>
      <c:when test="${empty trainees}">
        <div class="empty-state">
          <div class="empty-state-icon">📊</div>
          <p>No trainees found. Enroll trainees to view their progress analytics.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="selector-section">
          <label class="form-label">Select trainee</label>
          <select id="traineeSelect" class="form-select">
            <c:forEach var="t" items="${trainees}">
              <option value="${t.id}"><c:out value="${t.name}"/> &lt;<c:out value="${t.email}"/>&gt;</option>
            </c:forEach>
          </select>
        </div>

        <div id="summaryCard" class="summary-card" style="display:none;">
          <div class="summary-content">
            <div class="summary-label">Progress Summary</div>
            <p id="summary" class="summary-text"></p>
          </div>
        </div>

        <div class="chart-grid">
          <div class="chart-card">
            <h5>📈 Monthly Average Weight (last 12 months)</h5>
            <canvas id="avgWeightChart" height="250"></canvas>
          </div>

          <div class="chart-card">
            <h5>📊 Monthly Log Count (last 12 months)</h5>
            <canvas id="countChart" height="250"></canvas>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <script>
    const traineeSelect = document.getElementById('traineeSelect');
    const summaryDiv = document.getElementById('summary');
    const summaryCard = document.getElementById('summaryCard');
    let avgChart = null;
    let countChart = null;

    async function loadStatsFor(traineeId) {
      try {
        summaryCard.style.display = 'none';

        const resp = await fetch(`${window.location.origin}${'${pageContext.request.contextPath}'}/progress/stats?userId=` + traineeId);
        if (!resp.ok) {
          summaryDiv.textContent = '⚠️ Failed to load stats (HTTP ' + resp.status + ')';
          summaryCard.style.display = 'block';
          return;
        }
        const json = await resp.json();
        const labels = json.labels || [];
        const avgWeights = json.avgWeights || [];
        const counts = json.counts || [];

        // summary line
        const selectedTrainee = traineeSelect.options[traineeSelect.selectedIndex].text;
        const latestAvg = avgWeights.length ? avgWeights[avgWeights.length-1] : null;
        const earliestAvg = avgWeights.length ? avgWeights[0] : null;

        let trend = '';
        let trendClass = '';
        if (latestAvg != null && earliestAvg != null && labels.length > 0) {
          const diff = latestAvg - earliestAvg;
          const pct = earliestAvg ? (diff / earliestAvg * 100).toFixed(1) : '0';
          const sign = diff >= 0 ? '+' : '';
          trendClass = diff >= 0 ? 'trend-positive' : 'trend-negative';
          trend = `<span class="${trendClass}">Trend: ${sign}${diff.toFixed(2)} kg (${sign}${pct}%)</span> since ${labels[0]}`;
        } else {
          trend = 'No weight data available for trend analysis.';
        }

        summaryDiv.innerHTML = `Selected trainee: <strong>${selectedTrainee}</strong><br/>${trend}`;
        summaryCard.style.display = 'block';

        renderAvgChart(labels, avgWeights);
        renderCountChart(labels, counts);
      } catch (err) {
        console.error(err);
        summaryDiv.textContent = '❌ Error loading stats: ' + err.message;
        summaryCard.style.display = 'block';
      }
    }

    function renderAvgChart(labels, avgWeights) {
      const ctx = document.getElementById('avgWeightChart').getContext('2d');
      if (avgChart) avgChart.destroy();
      avgChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'Avg weight (kg)',
            data: avgWeights,
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
    }

    function renderCountChart(labels, counts) {
      const ctx = document.getElementById('countChart').getContext('2d');
      if (countChart) countChart.destroy();
      countChart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: 'Entries',
            data: counts,
            backgroundColor: 'rgba(67, 233, 123, 0.8)',
            borderColor: '#43e97b',
            borderWidth: 2,
            borderRadius: 8
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
              beginAtZero: true,
              precision: 0,
              grid: { color: '#f0f0f0' },
              ticks: {
                color: '#6c757d',
                font: { size: 12 },
                precision: 0,
                callback: function(value) {
                  return Number.isInteger(value) ? value : '';
                }
              }
            }
          }
        }
      });
    }

    // initial load (first trainee)
    if (traineeSelect && traineeSelect.options.length > 0) {
      loadStatsFor(traineeSelect.value);

      traineeSelect.addEventListener('change', function() {
        loadStatsFor(this.value);
      });
    }
  </script>
</body>
</html>