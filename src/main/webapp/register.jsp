<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register - OnlineFitnessCoaching</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
      --card-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
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
      overflow-x: hidden;
      overflow-y: auto;
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
      width: 350px;
      height: 350px;
      top: -100px;
      right: -100px;
      animation-delay: 0s;
    }

    body::after {
      width: 450px;
      height: 450px;
      bottom: -150px;
      left: -150px;
      animation-delay: 10s;
    }

    @keyframes float {
      0%, 100% { transform: translate(0, 0) scale(1); }
      25% { transform: translate(-50px, 50px) scale(1.1); }
      50% { transform: translate(0, -100px) scale(0.9); }
      75% { transform: translate(50px, -50px) scale(1.05); }
    }

    /* Register Container */
    .register-container {
      width: 100%;
      max-width: 520px;
      position: relative;
      z-index: 10;
      animation: slideUp 0.6s ease-out;
      margin: auto;
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

    /* Register Card */
    .register-card {
      background: white;
      border-radius: 20px;
      box-shadow: var(--card-shadow);
      overflow: hidden;
    }

    .register-header {
      background: var(--primary-gradient);
      color: white;
      padding: 2.5rem 2rem 2rem 2rem;
      text-align: center;
    }

    .register-header h2 {
      font-size: 2rem;
      font-weight: 800;
      margin: 0 0 0.5rem 0;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }

    .register-header p {
      margin: 0;
      opacity: 0.95;
      font-size: 1rem;
    }

    .register-body {
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
      background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      color: #721c24;
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

    /* Role Selection */
    .role-selection {
      background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
      border-radius: 12px;
      padding: 1.5rem;
      margin-bottom: 1.5rem;
    }

    .role-selection-label {
      font-weight: 700;
      color: #2d3748;
      margin-bottom: 1rem;
      font-size: 1rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .role-option {
      position: relative;
      margin-bottom: 1rem;
    }

    .role-option:last-child {
      margin-bottom: 0;
    }

    .role-option input[type="radio"] {
      position: absolute;
      opacity: 0;
      cursor: pointer;
    }

    .role-card {
      background: white;
      border: 3px solid #e2e8f0;
      border-radius: 10px;
      padding: 1.25rem;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 1rem;
    }

    .role-option input[type="radio"]:checked + .role-card {
      border-color: #667eea;
      background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .role-card:hover {
      border-color: #667eea;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
    }

    .role-icon {
      font-size: 2rem;
      line-height: 1;
    }

    .role-info {
      flex: 1;
    }

    .role-title {
      font-weight: 700;
      color: #2d3748;
      margin: 0 0 0.25rem 0;
      font-size: 1.05rem;
    }

    .role-description {
      color: #718096;
      margin: 0;
      font-size: 0.875rem;
    }

    .role-badge {
      background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
      color: #856404;
      padding: 0.25rem 0.6rem;
      border-radius: 6px;
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .role-check {
      width: 24px;
      height: 24px;
      border: 2px solid #cbd5e0;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
    }

    .role-option input[type="radio"]:checked + .role-card .role-check {
      background: var(--primary-gradient);
      border-color: #667eea;
    }

    .role-check::after {
      content: '✓';
      color: white;
      font-weight: bold;
      opacity: 0;
      transition: opacity 0.3s ease;
    }

    .role-option input[type="radio"]:checked + .role-card .role-check::after {
      opacity: 1;
    }

    /* Submit Button */
    .btn-register {
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

    .btn-register:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(102, 126, 234, 0.5);
    }

    .btn-register:active {
      transform: translateY(0);
    }

    .btn-register.loading {
      pointer-events: none;
      position: relative;
      color: transparent;
    }

    .btn-register.loading::after {
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
    .register-footer {
      text-align: center;
      padding: 1.5rem 2rem 2rem 2rem;
      background: #f7fafc;
      border-top: 1px solid #e2e8f0;
    }

    .register-footer p {
      margin: 0;
      color: #718096;
      font-size: 0.95rem;
    }

    .register-footer a {
      color: #667eea;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .register-footer a:hover {
      color: #764ba2;
      text-decoration: underline;
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
      .register-container {
        padding: 0 0.5rem;
      }

      .register-header h2 {
        font-size: 1.6rem;
      }

      .register-body {
        padding: 2rem 1.5rem;
      }

      .top-nav {
        flex-direction: column;
        gap: 0.75rem;
        text-align: center;
      }

      .role-card {
        flex-direction: column;
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <div class="register-container">
    <!-- Top Navigation -->
    <div class="top-nav">
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <span class="user-greeting">
            👤 Hello, <strong><c:out value="${sessionScope.user.name}"/></strong>
          </span>
          <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
        </c:when>
        <c:otherwise>
          <span style="color: #718096; font-size: 0.9rem;">Already have an account?</span>
          <a href="${pageContext.request.contextPath}/login.jsp">🔐 Login</a>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Register Card -->
    <div class="register-card">
      <div class="register-header">
        <h2>✨ Join Our Community</h2>
        <p>Start your fitness journey today</p>
      </div>

      <div class="register-body">
        <!-- Error Message -->
        <c:if test="${not empty error}">
          <div class="alert-message">
            <span class="alert-icon">⚠</span>
            <div>${error}</div>
          </div>
        </c:if>

        <!-- Register Form -->
        <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
          <div class="form-group">
            <label class="form-label">👤 Full Name</label>
            <input type="text" name="name" class="form-control" placeholder="John Doe" required autofocus/>
          </div>

          <div class="form-group">
            <label class="form-label">📧 Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="your@email.com" required/>
          </div>

          <div class="form-group">
            <label class="form-label">🔒 Password</label>
            <input type="password" name="password" class="form-control" placeholder="Create a strong password" required minlength="6"/>
            <small style="color: #718096; font-size: 0.85rem; margin-top: 0.5rem; display: block;">Minimum 6 characters</small>
          </div>

          <!-- Role Selection -->
          <div class="role-selection">
            <div class="role-selection-label">
              🎯 Choose Your Role
            </div>

            <div class="role-option">
              <input type="radio" id="trainee" name="role" value="TRAINEE" checked/>
              <label for="trainee" class="role-card">
                <span class="role-icon">🏃</span>
                <div class="role-info">
                  <div class="role-title">Trainee</div>
                  <div class="role-description">Access programs and track your progress</div>
                </div>
                <div class="role-check"></div>
              </label>
            </div>

            <div class="role-option">
              <input type="radio" id="coach" name="role" value="COACH"/>
              <label for="coach" class="role-card">
                <span class="role-icon">💪</span>
                <div class="role-info">
                  <div class="role-title">Coach</div>
                  <div class="role-description">Create programs and guide trainees</div>
                  <span class="role-badge">Requires Approval</span>
                </div>
                <div class="role-check"></div>
              </label>
            </div>
          </div>

          <button type="submit" class="btn-register">Create Your Account</button>
        </form>
      </div>

      <div class="register-footer">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a></p>
      </div>
    </div>

    <!-- Back to Home -->
    <div class="back-home">
      <a href="${pageContext.request.contextPath}/">← Back to Home</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add loading animation on form submit (don't prevent default)
    document.getElementById('registerForm').addEventListener('submit', function(e) {
      const submitBtn = this.querySelector('button[type="submit"]');
      submitBtn.classList.add('loading');
      // Don't disable the button - let the form submit naturally
    });

    // Password strength indicator
    const passwordInput = document.querySelector('input[type="password"]');
    passwordInput.addEventListener('input', function() {
      const length = this.value.length;
      const parent = this.parentElement;
      let strengthText = parent.querySelector('.strength-text');

      if (!strengthText) {
        strengthText = document.createElement('small');
        strengthText.className = 'strength-text';
        strengthText.style.display = 'block';
        strengthText.style.marginTop = '0.5rem';
        strengthText.style.fontWeight = '600';
        parent.appendChild(strengthText);
      }

      if (length === 0) {
        strengthText.textContent = '';
      } else if (length < 6) {
        strengthText.textContent = '⚠️ Too short';
        strengthText.style.color = '#f59e0b';
      } else if (length < 10) {
        strengthText.textContent = '✓ Good';
        strengthText.style.color = '#10b981';
      } else {
        strengthText.textContent = '✓ Strong';
        strengthText.style.color = '#059669';
      }
    });

    // Add animation to role cards
    document.querySelectorAll('.role-card').forEach(card => {
      card.addEventListener('click', function() {
        this.style.transform = 'scale(0.98)';
        setTimeout(() => {
          this.style.transform = '';
        }, 100);
      });
    });
  </script>
</body>
</html>