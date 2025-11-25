<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login - OnlineFitnessCoaching</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      --warning-gradient: linear-gradient(135deg, #ffa726 0%, #fb8c00 100%);
      --card-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
      --input-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
    }

    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem 1rem;
      position: relative;
      overflow: hidden;
    }

    /* Animated background elements */
    body::before,
    body::after {
      content: '';
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.1);
      animation: float 20s infinite ease-in-out;
    }

    body::before {
      width: 300px;
      height: 300px;
      top: -150px;
      left: -150px;
      animation-delay: 0s;
    }

    body::after {
      width: 400px;
      height: 400px;
      bottom: -200px;
      right: -200px;
      animation-delay: 10s;
    }

    @keyframes float {
      0%, 100% { transform: translate(0, 0) scale(1); }
      25% { transform: translate(50px, 50px) scale(1.1); }
      50% { transform: translate(0, 100px) scale(0.9); }
      75% { transform: translate(-50px, 50px) scale(1.05); }
    }

    /* Login Container */
    .login-container {
      width: 100%;
      max-width: 480px;
      position: relative;
      z-index: 10;
      animation: slideUp 0.6s ease-out;
    }

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

    /* Top Navigation */
    .top-nav {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(10px);
      border-radius: 12px;
      padding: 1rem 1.5rem;
      margin-bottom: 2rem;
      box-shadow: var(--card-shadow);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .top-nav a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .top-nav a:hover {
      color: #764ba2;
    }

    .user-greeting {
      color: #4a5568;
      font-weight: 500;
    }

    /* Login Card */
    .login-card {
      background: white;
      border-radius: 20px;
      box-shadow: var(--card-shadow);
      overflow: hidden;
    }

    .login-header {
      background: var(--primary-gradient);
      color: white;
      padding: 2.5rem 2rem 2rem 2rem;
      text-align: center;
    }

    .login-header h2 {
      font-size: 2rem;
      font-weight: 800;
      margin: 0 0 0.5rem 0;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }

    .login-header p {
      margin: 0;
      opacity: 0.95;
      font-size: 1rem;
    }

    .login-body {
      padding: 2.5rem 2rem;
    }

    /* Alert Messages */
    .alert-message {
      border-radius: 10px;
      padding: 1rem 1.25rem;
      margin-bottom: 1.5rem;
      font-weight: 500;
      border: none;
      animation: slideIn 0.4s ease-out;
      display: flex;
      align-items: center;
      gap: 0.75rem;
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

    .alert-warning {
      background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
      color: #856404;
    }

    .alert-error {
      background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      color: #721c24;
    }

    .alert-icon {
      font-size: 1.5rem;
      line-height: 1;
    }

    /* Form Styles */
    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-label {
      font-weight: 600;
      color: #4a5568;
      margin-bottom: 0.5rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-size: 0.95rem;
    }

    .form-control {
      border-radius: 10px;
      border: 2px solid #e2e8f0;
      padding: 0.85rem 1rem;
      transition: all 0.3s ease;
      font-size: 1rem;
    }

    .form-control:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
      outline: none;
    }

    /* Submit Button */
    .btn-login {
      background: var(--primary-gradient);
      color: white;
      border: none;
      border-radius: 10px;
      padding: 0.9rem;
      font-weight: 700;
      font-size: 1.05rem;
      width: 100%;
      transition: all 0.3s ease;
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      cursor: pointer;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
    }

    .btn-login:active {
      transform: translateY(0);
    }

    .btn-login.loading {
      pointer-events: none;
      position: relative;
      color: transparent;
    }

    .btn-login.loading::after {
      content: '';
      position: absolute;
      width: 20px;
      height: 20px;
      top: 50%;
      left: 50%;
      margin-left: -10px;
      margin-top: -10px;
      border: 3px solid rgba(255, 255, 255, 0.3);
      border-top-color: white;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    /* Footer Links */
    .login-footer {
      text-align: center;
      padding: 1.5rem 2rem 2rem 2rem;
      background: #f7fafc;
      border-top: 1px solid #e2e8f0;
    }

    .login-footer p {
      margin: 0 0 1rem 0;
      color: #718096;
      font-size: 0.95rem;
    }

    .login-footer a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .login-footer a:hover {
      color: #764ba2;
      text-decoration: underline;
    }

    .divider {
      display: flex;
      align-items: center;
      margin: 1.5rem 0;
      color: #cbd5e0;
      font-size: 0.9rem;
    }

    .divider::before,
    .divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: #e2e8f0;
    }

    .divider span {
      padding: 0 1rem;
      color: #a0aec0;
    }

    /* Back to Home Link */
    .back-home {
      text-align: center;
      margin-top: 1.5rem;
    }

    .back-home a {
      color: white;
      text-decoration: none;
      font-weight: 600;
      padding: 0.75rem 1.5rem;
      border-radius: 10px;
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(10px);
      border: 2px solid rgba(255, 255, 255, 0.3);
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      transition: all 0.3s ease;
    }

    .back-home a:hover {
      background: rgba(255, 255, 255, 0.25);
      transform: translateY(-2px);
    }

    /* Responsive */
    @media (max-width: 576px) {
      .login-container {
        padding: 0 0.5rem;
      }

      .login-header h2 {
        font-size: 1.6rem;
      }

      .login-body {
        padding: 2rem 1.5rem;
      }

      .top-nav {
        flex-direction: column;
        gap: 0.75rem;
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <div class="login-container">
    <!-- Top Navigation -->
    <div class="top-nav">
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <span class="user-greeting">
            👤 Hello, <strong><c:out value="${sessionScope.user.name}"/></strong>
            (<c:out value="${sessionScope.user.role}"/>)
          </span>
          <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
        </c:when>
        <c:otherwise>
          <span style="color: #718096; font-size: 0.9rem;">New here?</span>
          <a href="${pageContext.request.contextPath}/register.jsp">✨ Create Account</a>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Login Card -->
    <div class="login-card">
      <div class="login-header">
        <h2>🔐 Welcome Back</h2>
        <p>Login to continue your fitness journey</p>
      </div>

      <div class="login-body">
        <!-- Alert Messages -->
        <c:choose>
          <c:when test="${param.msg == 'registered'}">
            <div class="alert-message alert-success">
              <span class="alert-icon">✓</span>
              <div>Registration successful! Please login to continue.</div>
            </div>
          </c:when>

          <c:when test="${param.msg == 'registered_coach'}">
            <div class="alert-message alert-success">
              <span class="alert-icon">✓</span>
              <div>
                <strong>Registration successful!</strong><br/>
                Your coach account is pending admin approval.
              </div>
            </div>
          </c:when>

          <c:when test="${param.error == 'coach_pending'}">
            <div class="alert-message alert-warning">
              <span class="alert-icon">⏳</span>
              <div>
                Your coach account is pending admin approval. You cannot login until an admin approves it.
              </div>
            </div>
          </c:when>

          <c:when test="${param.error == 'invalid'}">
            <div class="alert-message alert-error">
              <span class="alert-icon">✗</span>
              <div>Invalid email or password. Please try again.</div>
            </div>
          </c:when>

          <c:when test="${param.error == 'empty'}">
            <div class="alert-message alert-error">
              <span class="alert-icon">⚠</span>
              <div>Please enter both email and password.</div>
            </div>
          </c:when>

          <c:when test="${param.error == 'server'}">
            <div class="alert-message alert-error">
              <span class="alert-icon">⚠</span>
              <div>Server error. Please try again later.</div>
            </div>
          </c:when>
        </c:choose>

        <!-- Login Form -->
        <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
          <div class="form-group">
            <label class="form-label">📧 Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="your@email.com" required autofocus/>
          </div>

          <div class="form-group">
            <label class="form-label">🔒 Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter your password" required/>
          </div>

          <button type="submit" class="btn-login">Login to Your Account</button>
        </form>
      </div>

      <div class="login-footer">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register now</a></p>
    </div>

    <!-- Back to Home -->
    <div class="back-home">
      <a href="${pageContext.request.contextPath}/">← Back to Home</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add loading animation on form submit (don't prevent default)
    document.getElementById('loginForm').addEventListener('submit', function(e) {
      const submitBtn = this.querySelector('button[type="submit"]');
      submitBtn.classList.add('loading');
      // Don't disable the button - let the form submit naturally
    });

    // Auto-dismiss success messages after 5 seconds
    const successAlerts = document.querySelectorAll('.alert-success');
    successAlerts.forEach(function(alert) {
      setTimeout(function() {
        alert.style.transition = 'opacity 0.5s ease';
        alert.style.opacity = '0';
        setTimeout(function() {
          alert.remove();
        }, 500);
      }, 5000);
    });
  </script>
</body>
</html>