package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;
import com.onlinefitness.util.ImageUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * ProgressServlet
 * GET  /progress  -> shows progress list + add form (for logged-in user)
 * POST /progress  -> create new entry (multipart upload OR photoUrl)
 *
 * Compatible with Servlet 3.0 / Tomcat 7: don't call Part.getSubmittedFileName()
 */
@WebServlet("/progress")
@MultipartConfig(fileSizeThreshold = 1024 * 50, maxFileSize = 1024 * 1024 * 8, maxRequestSize = 1024 * 1024 * 16)
public class ProgressServlet extends HttpServlet {

    private final ProgressDAO progressDAO = new ProgressDAO();
    private static final int THUMB_MAX_W = 300;
    private static final int THUMB_MAX_H = 300;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<ProgressLog> logs = progressDAO.findByUser(user.getId());
            // set both attribute names for compatibility with different JSPs
            req.setAttribute("logs", logs);
            req.setAttribute("progressLogs", logs);

            // forward to the page that contains both list and add form
            req.getRequestDispatcher("/jsp/progress-list.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }

    // Create entry with optional file + thumbnail OR a provided photo URL
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String logDateStr = req.getParameter("logDate");
        String weightStr = req.getParameter("weightKg");
        String notes = req.getParameter("notes");
        String photoUrlParam = req.getParameter("photoUrl"); // optional direct URL

        ProgressLog log = new ProgressLog();
        log.setUserId(user.getId());
        try {
            if (logDateStr != null && !logDateStr.isBlank()) {
                log.setLogDate(Date.valueOf(LocalDate.parse(logDateStr)));
            } else {
                log.setLogDate(Date.valueOf(LocalDate.now()));
            }
        } catch (Exception ex) {
            log.setLogDate(Date.valueOf(LocalDate.now()));
        }
        try {
            if (weightStr != null && !weightStr.isBlank()) log.setWeightKg(Double.parseDouble(weightStr));
        } catch (Exception ignored) {}

        // handle multipart file upload safely (some containers throw if request isn't multipart)
        Part filePart = null;
        try {
            filePart = req.getPart("photoFile");
        } catch (IllegalStateException ise) {
            // file too large
            resp.sendRedirect(req.getContextPath() + "/progress?msg=file_too_large");
            return;
        } catch (Exception e) {
            // Not a multipart request or container can't handle getPart -> ignore and fallback to photoUrl
            filePart = null;
        }

        // If a file was uploaded, prefer it. Otherwise use photoUrlParam if provided.
        if (filePart != null && filePart.getSize() > 0) {
            String submitted = getFileNameFromPart(filePart);
            if (submitted == null) submitted = "upload_" + UUID.randomUUID();
            String ext = getExtension(submitted).toLowerCase();
            if (!isAllowed(ext)) {
                resp.sendRedirect(req.getContextPath() + "/progress?msg=bad_file_type");
                return;
            }

            // two directories under webapp/uploads/progress/
            String uploadsRelativeFull = "/uploads/progress/full";
            String uploadsRelativeThumb = "/uploads/progress/thumbs";

            String uploadsRealFull = req.getServletContext().getRealPath(uploadsRelativeFull);
            String uploadsRealThumb = req.getServletContext().getRealPath(uploadsRelativeThumb);

            // fallback if real path == null (running from IDE), place under user.dir/uploads/progress/...
            if (uploadsRealFull == null) uploadsRealFull = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "progress" + File.separator + "full";
            if (uploadsRealThumb == null) uploadsRealThumb = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "progress" + File.separator + "thumbs";

            Path fullDir = Paths.get(uploadsRealFull);
            Path thumbDir = Paths.get(uploadsRealThumb);
            if (!Files.exists(fullDir)) Files.createDirectories(fullDir);
            if (!Files.exists(thumbDir)) Files.createDirectories(thumbDir);

            String safe = UUID.randomUUID().toString() + "_" + sanitize(submitted);
            Path targetFull = fullDir.resolve(safe);

            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, targetFull, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException ioe) {
                ioe.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/progress?msg=upload_failed");
                return;
            }

            // create thumbnail file in thumbs dir
            Path targetThumb = thumbDir.resolve(safe);
            try {
                ImageUtil.createThumbnail(targetFull.toFile(), targetThumb.toFile(), THUMB_MAX_W, THUMB_MAX_H);
            } catch (Exception e) {
                e.printStackTrace(); // continue even if thumb creation fails
            }

            // store web URLs (contextPath + relative)
            String photoUrl = req.getContextPath() + uploadsRelativeFull + "/" + safe;
            log.setPhotoUrl(photoUrl);
        } else {
            // if no file uploaded, accept direct URL (if present)
            if (photoUrlParam != null && !photoUrlParam.isBlank()) {
                log.setPhotoUrl(photoUrlParam.trim());
            }
        }

        log.setNotes(notes);

        try {
            progressDAO.save(log);
            resp.sendRedirect(req.getContextPath() + "/progress?msg=added");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/progress?msg=server_error");
        }
    }

    // Helper: parses Content-Disposition header to extract filename — works on Servlet 3.0/Tomcat7
    private String getFileNameFromPart(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String[] kv = token.split("=", 2);
                if (kv.length == 2) {
                    String val = kv[1].trim();
                    if (val.startsWith("\"") && val.endsWith("\"") && val.length() >= 2) {
                        val = val.substring(1, val.length()-1);
                    }
                    return Paths.get(val).getFileName().toString();
                }
            }
        }
        return null;
    }

    private boolean isAllowed(String ext) {
        return ext.equals("jpg") || ext.equals("jpeg") || ext.equals("png") || ext.equals("gif");
    }
    private String getExtension(String f) {
        int i = f.lastIndexOf('.');
        if (i >= 0) return f.substring(i+1);
        return "";
    }
    private String sanitize(String s) {
        return s.replaceAll("[\\\\/\\s]+", "_").replaceAll("[^A-Za-z0-9._-]", "");
    }
}
