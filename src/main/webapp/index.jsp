<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>OnlineFitnessCoaching - Home</title>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      --accent-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      --card-hover-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }

    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 0;
    }

    /* Hero Section */
    .hero-section {
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.95) 0%, rgba(118, 75, 162, 0.95) 100%),
                  url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 600"><rect fill="%23667eea" width="1200" height="600"/><g fill-opacity="0.1"><circle fill="%23fff" cx="100" cy="100" r="80"/><circle fill="%23fff" cx="300" cy="300" r="120"/><circle fill="%23fff" cx="800" cy="200" r="100"/><circle fill="%23fff" cx="1000" cy="400" r="90"/></g></svg>');
      background-size: cover;
      background-position: center;
      padding: 4rem 0;
      color: white;
      box-shadow: var(--card-shadow);
      animation: fadeIn 0.6s ease-out;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(-20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .hero-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 2rem;
      margin-bottom: 2rem;
    }

    .logo-section h1 {
      font-size: 2.5rem;
      font-weight: 800;
      margin: 0;
      text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .logo-subtitle {
      font-size: 0.9rem;
      opacity: 0.9;
      font-weight: 400;
      margin-top: 0.3rem;
    }

    .user-nav {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .user-nav a {
      color: white;
      text-decoration: none;
      font-weight: 600;
      padding: 0.5rem 1rem;
      border-radius: 8px;
      transition: all 0.3s ease;
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      border: 2px solid rgba(255, 255, 255, 0.2);
    }

    .user-nav a:hover {
      background: rgba(255, 255, 255, 0.2);
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    .user-greeting {
      background: rgba(255, 255, 255, 0.15);
      padding: 0.5rem 1rem;
      border-radius: 8px;
      backdrop-filter: blur(10px);
      border: 2px solid rgba(255, 255, 255, 0.2);
    }

    /* Welcome Section */
    .welcome-section {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 2rem 3rem 2rem;
      text-align: center;
    }

    .welcome-section h2 {
      font-size: 3rem;
      font-weight: 800;
      margin-bottom: 1rem;
      text-shadow: 2px 2px 8px rgba(0,0,0,0.1);
    }

    .welcome-section p {
      font-size: 1.3rem;
      opacity: 0.95;
      max-width: 700px;
      margin: 0 auto 2rem auto;
    }

    .cta-buttons {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
    }

    .cta-btn {
      padding: 1rem 2.5rem;
      border-radius: 12px;
      font-weight: 700;
      font-size: 1.1rem;
      text-decoration: none;
      transition: all 0.3s ease;
      border: 3px solid white;
      background: white;
      color: #667eea;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }

    .cta-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(0,0,0,0.3);
      background: rgba(255, 255, 255, 0.95);
    }

    .cta-btn.secondary {
      background: transparent;
      color: white;
    }

    .cta-btn.secondary:hover {
      background: rgba(255, 255, 255, 0.15);
    }

    /* Main Content */
    .main-content {
      max-width: 1200px;
      margin: -3rem auto 2rem auto;
      padding: 0 2rem;
      position: relative;
      z-index: 10;
    }

    /* Feature Cards */
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }

    .feature-card {
      background: white;
      border-radius: 16px;
      padding: 2rem;
      box-shadow: var(--card-shadow);
      transition: all 0.3s ease;
      border: none;
      position: relative;
      overflow: hidden;
      animation: slideUp 0.6s ease-out;
      animation-fill-mode: both;
    }

    .feature-card:nth-child(1) { animation-delay: 0.1s; }
    .feature-card:nth-child(2) { animation-delay: 0.2s; }
    .feature-card:nth-child(3) { animation-delay: 0.3s; }

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

    .feature-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 5px;
      background: var(--primary-gradient);
    }

    .feature-card:hover {
      transform: translateY(-8px);
      box-shadow: var(--card-hover-shadow);
    }

    .feature-icon {
      font-size: 3rem;
      margin-bottom: 1rem;
      display: block;
    }

    .feature-card h3 {
      color: #2d3748;
      font-weight: 700;
      margin-bottom: 1rem;
      font-size: 1.5rem;
    }

    .feature-card p {
      color: #718096;
      line-height: 1.6;
      margin-bottom: 1.5rem;
    }

    .feature-link {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      padding: 0.75rem 1.5rem;
      border-radius: 10px;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
    }

    .feature-link:hover {
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

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 2rem;
      text-align: center;
    }

    .stat-item {
      padding: 1rem;
    }

    .stat-number {
      font-size: 2.5rem;
      font-weight: 800;
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .stat-label {
      color: #718096;
      font-weight: 600;
      margin-top: 0.5rem;
    }

    /* Footer Note */
    .footer-note {
      text-align: center;
      padding: 2rem;
      color: #718096;
    }

    .footer-note a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
    }

    .footer-note a:hover {
      text-decoration: underline;
    }

    /* Responsive */
    @media (max-width: 768px) {
      .hero-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 1rem;
      }

      .logo-section h1 {
        font-size: 1.8rem;
      }

      .welcome-section h2 {
        font-size: 2rem;
      }

      .welcome-section p {
        font-size: 1.1rem;
      }

      .feature-grid {
        grid-template-columns: 1fr;
      }

      .user-nav {
        width: 100%;
      }

      .cta-buttons {
        flex-direction: column;
      }

      .cta-btn {
        width: 100%;
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <!-- Hero Section -->
  <div class="hero-section">
    <div class="hero-header">
      <div class="logo-section">
        <h1>💪 OnlineFitnessCoaching</h1>
        <div class="logo-subtitle">Transform Your Body, Transform Your Life</div>
      </div>
      <div class="user-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <span class="user-greeting">👤 Hello, <strong><c:out value="${sessionScope.user.name}"/></strong></span>
            <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
            <a href="${pageContext.request.contextPath}/jsp/dashboard-trainee.jsp">📊 Dashboard</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login.jsp">🔐 Login</a>
            <a href="${pageContext.request.contextPath}/register.jsp">✨ Register</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="welcome-section">
      <h2>Welcome to Your Fitness Journey</h2>
      <p>Connect with expert coaches, access personalized workout programs, and track your progress every step of the way.</p>
      <div class="cta-buttons">
        <c:choose>
          <c:when test="${empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/register.jsp" class="cta-btn">Get Started Now</a>
            <a href="${pageContext.request.contextPath}/jsp/program-list.jsp" class="cta-btn secondary">Browse Programs</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/jsp/dashboard-trainee.jsp" class="cta-btn">Go to Dashboard</a>
            <a href="${pageContext.request.contextPath}/jsp/program-list.jsp" class="cta-btn secondary">View Programs</a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <!-- Main Content -->
  <div class="main-content">

    <!-- Stats Section -->
    <div class="stats-section">
      <div class="stats-grid">
        <div class="stat-item">
          <div class="stat-number">1000+</div>
          <div class="stat-label">Active Members</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">50+</div>
          <div class="stat-label">Expert Coaches</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">200+</div>
          <div class="stat-label">Programs</div>
        </div>
        <div class="stat-item">
          <div class="stat-number">24/7</div>
          <div class="stat-label">Support</div>
        </div>
      </div>
    </div>

    <!-- Feature Cards -->
    <div class="feature-grid">
      <!-- Browse Programs Card -->
      <div class="feature-card">
        <span class="feature-icon">🏋️</span>
        <h3>Browse Programs</h3>
        <p>Explore a wide variety of fitness programs designed by certified coaches to meet your specific goals and fitness level.</p>
        <a href="${pageContext.request.contextPath}/jsp/program-list.jsp" class="feature-link">
          View All Programs →
        </a>
      </div>

      <!-- Create Program Card -->
      <div class="feature-card">
        <span class="feature-icon">✏️</span>
        <h3>Create Program</h3>
        <p>Are you a coach? Design and publish your own fitness programs to help others achieve their health and fitness goals.</p>
        <a href="${pageContext.request.contextPath}/jsp/program-form.jsp" class="feature-link">
          Create New Program →
        </a>
      </div>

      <!-- Dashboard Card -->
      <div class="feature-card">
        <span class="feature-icon">📊</span>
        <h3>Your Dashboard</h3>
        <p>Track your progress, manage your enrolled programs, monitor your workouts, and stay connected with your coach.</p>
        <a href="${pageContext.request.contextPath}/jsp/dashboard-trainee.jsp" class="feature-link">
          Open Dashboard →
        </a>
      </div>
    </div>

    <!-- Footer Note -->
    <div class="footer-note">
      <p>Ready to transform your fitness journey? <c:choose>
        <c:when test="${empty sessionScope.user}">
          <a href="${pageContext.request.contextPath}/register.jsp">Sign up today</a> and get started!
        </c:when>
        <c:otherwise>
          Let's continue building your success story!
        </c:otherwise>
      </c:choose></p>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add parallax effect to hero section
    window.addEventListener('scroll', function() {
      const hero = document.querySelector('.hero-section');
      const scrolled = window.pageYOffset;
      hero.style.transform = `translateY(${scrolled * 0.5}px)`;
      hero.style.opacity = 1 - (scrolled / 600);
    });

    // Animate stats on scroll
    const observerOptions = {
      threshold: 0.5,
      rootMargin: '0px'
    };

    const observer = new IntersectionObserver(function(entries) {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const statNumbers = entry.target.querySelectorAll('.stat-number');
          statNumbers.forEach(stat => {
            stat.style.animation = 'pulse 0.6s ease-out';
          });
        }
      });
    }, observerOptions);

    const statsSection = document.querySelector('.stats-section');
    if (statsSection) {
      observer.observe(statsSection);
    }
  </script>
</body>
</html>