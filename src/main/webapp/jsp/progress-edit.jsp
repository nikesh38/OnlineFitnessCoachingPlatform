<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Edit Progress Entry</title>
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
      max-width: 800px;
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
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    /* Form Card */
    .form-card {
      background: white;
      border-radius: 16px;
      box-shadow: var(--card-shadow);
      border: none;
      transition: all 0.3s ease;
      overflow: hidden;
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

    .form-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: var(--primary-gradient);
    }

    .form-card .card-body {
      padding: 2.5rem;
      position: relative;
    }

    /* Form Elements */
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
      border-radius: 10px;
      border: 2px solid #e2e8f0;
      padding: 0.75rem 1rem;
      transition: all 0.3s ease;
      font-size: 1rem;
    }

    .form-control:focus, .form-select:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
      transform: translateY(-1px);
    }

    .form-text {
      color: #718096;
      font-size: 0.875rem;
      margin-top: 0.5rem;
      font-style: italic;
    }

    /* Photo Section */
    .photo-section {
      background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
      padding: 1.5rem;
      border-radius: 12px;
      border: 2px dashed #cbd5e0;
      transition: all 0.3s ease;
    }

    .photo-section:hover {
      border-color: #667eea;
      background: linear-gradient(135deg, #edf2f7 0%, #e2e8f0 100%);
    }

    .photo-thumb {
      max-width: 250px;
      max-height: 200px;
      object-fit: cover;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      transition: all 0.3s ease;
      border: 4px solid #fff;
      display: block;
      margin-bottom: 1rem;
    }

    .photo-thumb:hover {
      transform: scale(1.05);
      box-shadow: 0 8px 20px rgba(0,0,0,0.25);
    }

    .photo-placeholder {
      background: linear-gradient(135deg, #e2e8f0 0%, #cbd5e0 100%);
      border-radius: 12px;
      padding: 2rem;
      text-align: center;
      color: #718096;
      margin-bottom: 1rem;
      border: 2px dashed #a0aec0;
    }

    .photo-placeholder::before {
      content: '📷';
      display: block;
      font-size: 3rem;
      margin-bottom: 0.5rem;
      opacity: 0.5;
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
      font-size: 1rem;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(102, 126, 234, 0.4);
    }

    .btn-primary:active {
      transform: translateY(0);
    }

    .btn-outline-secondary {
      border-radius: 10px;
      font-weight: 500;
      transition: all 0.3s ease;
      border-width: 2px;
      padding: 0.75rem 1.5rem;
    }

    .btn-outline-secondary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
    }

    .btn-sm {
      padding: 0.5rem 1rem;
      font-size: 0.9rem;
      border-radius: 8px;
    }

    /* Section Headers */
    .section-header {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-weight: 700;
      color: #2d3748;
      margin-bottom: 1rem;
      font-size: 1.1rem;
    }

    /* Input Groups */
    .input-group-custom {
      background: white;
      padding: 1.5rem;
      border-radius: 10px;
      margin-bottom: 1.5rem;
      transition: all 0.3s ease;
    }

    .input-group-custom:hover {
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .page-header {
        flex-direction: column;
        align-items: flex-start !important;
        gap: 1rem;
      }

      .form-card .card-body {
        padding: 1.5rem;
      }

      .photo-thumb {
        max-width: 100%;
      }

      .btn-primary, .btn-outline-secondary {
        width: 100%;
      }

      .d-flex.gap-2 {
        flex-direction: column;
      }
    }

    /* Loading Animation */
    .form-card.loading {
      pointer-events: none;
      opacity: 0.6;
    }

    .form-card.loading::after {
      content: '';
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      border: 4px solid #f3f4f6;
      border-top: 4px solid #667eea;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: translate(-50%, -50%) rotate(0deg); }
      100% { transform: translate(-50%, -50%) rotate(360deg); }
    }
  </style>
</head>
<body>
  <div class="container my-4">
    <div class="page-header d-flex justify-content-between align-items-center">
      <h2>✏️ Edit Progress Entry</h2>
      <div>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/progress">
          ← Back to Progress
        </a>
      </div>
    </div>

    <div class="card form-card position-relative">
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/progress/edit" enctype="multipart/form-data">
          <input type="hidden" name="id" value="${log.id}"/>

          <div class="input-group-custom">
            <div class="mb-3">
              <label class="form-label">📅 Date</label>
              <input type="date" name="logDate" class="form-control" value="${log.logDate}" required/>
            </div>

            <div class="mb-0">
              <label class="form-label">⚖️ Weight (kg)</label>
              <input type="number" step="0.1" name="weightKg" class="form-control" value="${log.weightKg}" placeholder="e.g., 72.5"/>
            </div>
          </div>

          <div class="photo-section mb-4">
            <div class="section-header">📸 Photo Management</div>

            <c:choose>
              <c:when test="${not empty log.photoUrl}">
                <label class="form-label">Current Photo</label>
                <!-- expected photoUrl: /{ctx}/uploads/progress/full/<file> -->
                <c:set var="thumbUrl" value="${fn:replace(log.photoUrl, '/uploads/progress/full/', '/uploads/progress/thumbs/')}" />
                <a href="${log.photoUrl}" target="_blank">
                  <img src="${thumbUrl}" alt="Progress photo" class="photo-thumb" onerror="this.onerror=null; this.src='${log.photoUrl}';"/>
                </a>
              </c:when>
              <c:otherwise>
                <div class="photo-placeholder">
                  <strong>No photo uploaded</strong>
                  <p class="mb-0 mt-2 small">Add a photo to track your visual progress</p>
                </div>
              </c:otherwise>
            </c:choose>

            <label class="form-label mt-3">🔄 Replace Photo (optional)</label>
            <input type="file" name="photoFile" accept="image/*" class="form-control"/>
            <div class="form-text">
              <c:choose>
                <c:when test="${not empty log.photoUrl}">
                  ⚠️ Uploading a new file will replace your current photo
                </c:when>
                <c:otherwise>
                  Upload a photo to document your progress visually
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="input-group-custom">
            <label class="form-label">📝 Notes</label>
            <textarea name="notes" rows="5" class="form-control" placeholder="How you felt, workout summary, diet notes, achievements, etc.">${log.notes}</textarea>
            <div class="form-text">Add any relevant details about this progress entry</div>
          </div>

          <div class="d-flex gap-2 mt-4">
            <button type="submit" class="btn btn-primary">💾 Save Changes</button>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/progress">✕ Cancel</a>
          </div>
        </form>
      </div>
    </div>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
  <script>
    // Add loading animation on form submit
    document.querySelector('form').addEventListener('submit', function() {
      document.querySelector('.form-card').classList.add('loading');
    });

    // Preview image before upload
    document.querySelector('input[type="file"]').addEventListener('change', function(e) {
      const file = e.target.files[0];
      if (file && file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function(event) {
          const existingImg = document.querySelector('.photo-thumb');
          const placeholder = document.querySelector('.photo-placeholder');

          if (existingImg) {
            // Flash effect to show change
            existingImg.style.opacity = '0.5';
            setTimeout(() => {
              existingImg.src = event.target.result;
              existingImg.style.opacity = '1';
            }, 200);
          } else if (placeholder) {
            // Replace placeholder with preview
            const img = document.createElement('img');
            img.src = event.target.result;
            img.className = 'photo-thumb';
            img.alt = 'New photo preview';
            placeholder.replaceWith(img);
          }
        };
        reader.readAsDataURL(file);
      }
    });
  </script>
</body>
</html>