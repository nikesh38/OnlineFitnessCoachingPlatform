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
import java.util.UUID;

@WebServlet("/progress/edit")
@MultipartConfig(fileSizeThreshold = 1024 * 50, maxFileSize = 1024 * 1024 * 8, maxRequestSize = 1024 * 1024 * 16)
public class ProgressEditServlet extends HttpServlet {

    private final ProgressDAO progressDAO = new ProgressDAO();
    private static final int THUMB_MAX_W = 300;
    private static final int THUMB_MAX_H = 300;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendError(400, "id required"); return; }
        try {
            Long id = Long.parseLong(idParam);
            ProgressLog log = progressDAO.findById(id);
            if (log == null) { resp.sendError(404); return; }
            if (log.getUserId() == null || !log.getUserId().equals(user.getId())) { resp.sendError(403); return; }
            req.setAttribute("log", log);
            req.getRequestDispatcher("/jsp/progress-edit.jsp").forward(req, resp);
        } catch (NumberFormatException nfe) { resp.sendError(400); }
        catch (Exception e) { e.printStackTrace(); resp.sendError(500); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendError(400); return; }
        try {
            Long id = Long.parseLong(idParam);
            ProgressLog existing = progressDAO.findById(id);
            if (existing == null) { resp.sendError(404); return; }
            if (existing.getUserId() == null || !existing.getUserId().equals(user.getId())) { resp.sendError(403); return; }

            String logDateStr = req.getParameter("logDate");
            String weightStr = req.getParameter("weightKg");
            String notes = req.getParameter("notes");

            ProgressLog updated = new ProgressLog();
            updated.setId(id);
            updated.setUserId(existing.getUserId());
            try { if (logDateStr != null && !logDateStr.isBlank()) updated.setLogDate(Date.valueOf(LocalDate.parse(logDateStr))); else updated.setLogDate(existing.getLogDate()); } catch(Exception ex) { updated.setLogDate(existing.getLogDate()); }
            try { if (weightStr != null && !weightStr.isBlank()) updated.setWeightKg(Double.parseDouble(weightStr)); else updated.setWeightKg(existing.getWeightKg()); } catch (Exception ignored) { updated.setWeightKg(existing.getWeightKg()); }
            updated.setNotes(notes == null ? "" : notes);
            updated.setPhotoUrl(existing.getPhotoUrl());

            // handle new file
            Part filePart = null;
            try { filePart = req.getPart("photoFile"); } catch (IllegalStateException ise) { resp.sendRedirect(req.getContextPath() + "/progress?msg=file_too_large"); return; }

            if (filePart != null && filePart.getSize() > 0) {
                String submitted = getFileNameFromPart(filePart);
                if (submitted == null || submitted.isBlank()) submitted = "upload_" + UUID.randomUUID();
                String ext = getExt(submitted).toLowerCase();
                if (!isAllowed(ext)) { resp.sendRedirect(req.getContextPath() + "/progress?msg=bad_file_type"); return; }

                String uploadsRelative = "/uploads/progress";
                String uploadsRealPath = req.getServletContext().getRealPath(uploadsRelative);
                if (uploadsRealPath == null) uploadsRealPath = System.getProperty("user.dir") + File.separator + "uploads" + File.separator + "progress";
                Path uploadsDir = Paths.get(uploadsRealPath);
                if (!Files.exists(uploadsDir)) Files.createDirectories(uploadsDir);

                String safe = UUID.randomUUID().toString() + "_" + sanitize(submitted);
                Path target = uploadsDir.resolve(safe);
                try (InputStream in = filePart.getInputStream()) { Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING); } catch (IOException ioe) { ioe.printStackTrace(); resp.sendRedirect(req.getContextPath() + "/progress?msg=upload_failed"); return; }

                // create thumbnail
                String thumbName = "thumb_" + safe;
                Path thumbPath = uploadsDir.resolve(thumbName);
                try { ImageUtil.createThumbnail(target.toFile(), thumbPath.toFile(), THUMB_MAX_W, THUMB_MAX_H); } catch (Exception e) { e.printStackTrace(); }

                // delete previously uploaded files (if inside uploads dir)
                safeDeleteExisting(req, existing.getPhotoUrl());

                String photoUrl = req.getContextPath() + uploadsRelative + "/" + safe;
                updated.setPhotoUrl(photoUrl);
            }

            boolean ok = progressDAO.update(updated);
            if (ok) resp.sendRedirect(req.getContextPath() + "/progress?msg=updated");
            else resp.sendRedirect(req.getContextPath() + "/progress?msg=update_failed");

        } catch (NumberFormatException nfe) { resp.sendError(400); } catch (Exception e) { e.printStackTrace(); resp.sendError(500); }
    }

    private String getExt(String f) { int i=f.lastIndexOf('.'); return i>=0?f.substring(i+1):""; }
    private boolean isAllowed(String ext) { return ext.equals("jpg")||ext.equals("jpeg")||ext.equals("png")||ext.equals("gif"); }
    private String sanitize(String s) { return s.replaceAll("[\\\\/\\s]+","_").replaceAll("[^A-Za-z0-9._-]",""); }

    private void safeDeleteExisting(HttpServletRequest req, String oldUrl) {
        if (oldUrl == null || oldUrl.isBlank()) return;
        try {
            String contextPath = req.getContextPath();
            if (oldUrl.startsWith(contextPath)) {
                String rel = oldUrl.substring(contextPath.length()); // /uploads/progress/...
                String real = req.getServletContext().getRealPath(rel);
                if (real != null) {
                    Path p = Paths.get(real);
                    Files.deleteIfExists(p);
                    // delete thumb if exists (thumb_ prefix)
                    Path thumb = p.getParent().resolve("thumb_" + p.getFileName().toString());
                    Files.deleteIfExists(thumb);
                }
            }
        } catch (Exception ignored) {}
    }

    /**
     * Parse filename from part header "content-disposition"
     */
    private String getFileNameFromPart(Part part) {
        if (part == null) return null;
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                try { return Paths.get(name).getFileName().toString(); } catch (Exception ex) { return name; }
            }
        }
        return null;
    }
}
