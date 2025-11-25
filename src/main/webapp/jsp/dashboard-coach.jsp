<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Coach Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      --warning-gradient: linear-gradient(135deg, #ffa726 0%, #fb8c00 100%);
      --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      --card-hover-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container {
      max-width: 1200px;
    }

    /* Header Section */
    .dashboard-header {
      background: white;
      padding: 2rem;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      margin-bottom: 2rem;
      animation: slideDown 0.4s ease-out;
      position: relative;
      overflow: hidden;
    }

    .dashboard-header::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: var(--primary-gradient);
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

    .header-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .header-title h1 {
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      font-weight: 800;
      margin: 0 0 0.5rem 0;
      font-size: 2.5rem;
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .header-subtitle {
      color: #718096;
      font-size: 1.1rem;
      margin: 0;
    }

    .user-nav {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .user-greeting {
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
      padding: 0.75rem 1.25rem;
      border-radius: 10px;
      font-weight: 600;
      color: #4a5568;
      border: 2px solid rgba(102, 126, 234, 0.2);
    }

    .btn-logout {
      background: var(--primary-gradient);
      color: white;
      padding: 0.75rem 1.5rem;
      border-radius: 10px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      border: none;
      box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
    }

    .btn-logout:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      color: white;
    }

    /* Info Banner */
    .info-banner {
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      border-left: 5px solid #f59e0b;
      padding: 1.25rem 1.5rem;
      border-radius: 12px;
      margin-bottom: 2rem;
      animation: fadeIn 0.5s ease-out;
      box-shadow: var(--card-shadow);
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .info-banner p {
      margin: 0;
      color: #92400e;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .info-icon {
      font-size: 1.5rem;
    }

    /* Quick Actions Grid */
    .quick-actions {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-bottom: 2rem;
    }

    .action-card {
      background: white;
      border-radius: 16px;
      padding: 2.5rem;
      box-shadow: var(--card-shadow);
      transition: all 0.3s ease;
      border: none;
      position: relative;
      overflow: hidden;
      animation: slideUp 0.6s ease-out;
      animation-fill-mode: both;
      text-decoration: none;
      color: inherit;
      display: block;
    }

    .action-card:nth-child(1) { animation-delay: 0.1s; }
    .action-card:nth-child(2) { animation-delay: 0.2s; }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .action-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: var(--primary-gradient);
    }

    .action-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--card-hover-shadow);
    }

    .action-icon {
      font-size: 3.5rem;
      margin-bottom: 1.5rem;
      display: block;
    }

    .action-card h3 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1rem;
      font-size: 1.75rem;
    }

    .action-card p {
      color: #718096;
      line-height: 1.6;
      margin-bottom: 1.5rem;
      font-size: 1.05rem;
    }

    .action-link {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      color: #667eea;
      text-decoration: none;
      font-weight: 700;
      font-size: 1.1rem;
      transition: all 0.3s ease;
      padding: 0.75rem 1.5rem;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
    }

    .action-link:hover {
      background: var(--primary-gradient);
      color: white;
      transform: translateX(5px);
    }

    /* Stats Section */
    .stats-section {
      background: white;
      border-radius: 16px;
      padding: 2rem;
      box-shadow: var(--card-shadow);
      margin-bottom: 2rem;
      position: relative;
      overflow: hidden;
    }

    .stats-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: var(--success-gradient);
    }

    .stats-section h3 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1.5rem;
      font-size: 1.5rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 2rem;
      text-align: center;
    }

    .stat-item {
      padding: 1.5rem;
      background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
      border-radius: 12px;
      transition: all 0.3s ease;
    }

    .stat-item:hover {
      transform: translateY(-5px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .stat-number {
      font-size: 2.5rem;
      font-weight: 800;
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 0.5rem;
    }

    .stat-label {
      color: #718096;
      font-weight: 600;
      font-size: 1rem;
    }

    /* Welcome Message */
    .welcome-message {
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
      border-radius: 12px;
      padding: 1.5rem;
      margin-bottom: 2rem;
      border: 2px solid rgba(102, 126, 234, 0.1);
    }

    .welcome-message h2 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 0.75rem;
      font-size: 1.5rem;
    }

    .welcome-message p {
      color: #4a5568;
      margin: 0;
      line-height: 1.6;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .header-content {
        flex-direction: column;
        align-items: flex-start;
        gap: 1.5rem;
      }

      .header-title h1 {
        font-size: 2rem;
      }

      .quick-actions {
        grid-template-columns: 1fr;
      }

      .stats-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .user-nav {
        width: 100%;
        justify-content: space-between;
      }
    }
  </style>
</head>
<body>
  <div class="container my-4">

    <!-- Dashboard Header -->
    <div class="dashboard-header">
      <div class="header-content">
        <div class="header-title">
          <h1>💪 Coach Dashboard</h1>
        </div>
        <div class="user-nav">
          <c:choose>
            <c:when test="${not empty sessionScope.user}">
              <span class="user-greeting">
                👤 Hello, <strong><c:out value="${sessionScope.user.name}"/></strong>
              </span>
              <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                🚪 Logout
              </a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/login.jsp" class="btn-logout">
                🔐 Login
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <p class="header-subtitle">Manage your programs and inspire your trainees</p>
    </div>

    <!-- Welcome Message -->
    <div class="welcome-message">
      <h2>Welcome to Your Coaching Hub! 🎯</h2>
      <p>Create personalized fitness programs, manage workouts, and help your trainees achieve their goals. Your expertise makes a difference!</p>
    </div>

    <!-- Info Banner -->
    <div class="info-banner">
      <p>
        <span class="info-icon">ℹ️</span>
        <span>Make sure your user role is <strong>COACH</strong> to create and manage programs.</span>
      </p>
    </div>

    <!-- Stats Section -->
    <div class="stats-section">
      <h3>📊 Your Impact</h3>
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-number">--</div>
          <div class="stat-label">Total Programs</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">--</div>
          <div class="stat-label">Active Trainees</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">--</div>
          <div class="stat-label">Workouts Created</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">--</div>
          <div class="stat-label">Success Stories</div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
      <!-- My Programs Card -->
      <a href="${pageContext.request.contextPath}/jsp/program-list.jsp" class="action-card">
        <span class="action-icon">📚</span>
        <h3>My Programs</h3>
        <p>View and manage all your fitness programs. Edit workouts, track progress, and see who's enrolled.</p>
        <span class="action-link">
          View Programs →
        </span>
      </a>

      <!-- Create Program Card -->
      <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="action-card">
        <span class="action-icon">✏️</span>
        <h3>Create Program</h3>
        <p>Design a new fitness program from scratch. Add workouts, set goals, and help trainees transform their lives.</p>
        <span class="action-link">
          Create New Program →
        </span>
      </a>
    </div>

    <!-- Additional Resources -->
    <div class="stats-section">
      <h3>🚀 Quick Links</h3>
      <div class="row g-3">
        <div class="col-md-6">
          <div class="stat-item" style="text-align: left;">
            <h4 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem;">📋 Program Management</h4>
            <p style="color: #718096; margin: 0;">Access all your programs, edit details, and add new workouts</p>
          </div>
        </div>
        <div class="col-md-6">
          <div class="stat-item" style="text-align: left;">
            <h4 style="color: #2d3748; font-weight: 600; margin-bottom: 0.5rem;">👥 Trainee Support</h4>
            <p style="color: #718096; margin: 0;">Monitor trainee progress and provide guidance</p>
          </div>
        </div>
      </div>
    </div>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Animate stats on scroll
    const observerOptions = {
      threshold: 0.5,
      rootMargin: '0px'
    };

    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const statItems = entry.target.querySelectorAll('.stat-item');
          statItems.forEach((item, index) => {
            setTimeout(() => {
              item.style.animation = 'slideUp 0.5s ease-out';
            }, index * 100);
          });
        }
      });
    }, observerOptions);

    const statsSection = document.querySelector('.stats-section');
    if (statsSection) {
      observer.observe(statsSection);
    }

    // Add click animation to action cards
    document.querySelectorAll('.action-card').forEach(card => {
      card.addEventListener('click', function(e) {
        this.style.transform = 'scale(0.98)';
        setTimeout(() => {
          this.style.transform = '';
        }, 100);
      });
    });
  </script>
</body>
</html>