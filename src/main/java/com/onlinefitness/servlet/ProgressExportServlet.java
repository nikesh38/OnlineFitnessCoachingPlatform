package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Extended export servlet:
 * - single CSV (default)
 * - if multiple userIds provided -> zip with per-user CSV
 * - all=true -> zip with all users (ADMIN only)
 *
 * URL: /progress/export
 */
@WebServlet("/progress/export")
public class ProgressExportServlet extends HttpServlet {

    private final ProgressDAO progressDAO = new ProgressDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("user");
        if (sessionUser == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "login required");
            return;
        }

        String allParam = req.getParameter("all");
        String userIdsParam = req.getParameter("userIds");
        String userIdParam = req.getParameter("userId");

        try {
            if (Boolean.parseBoolean(allParam)) {
                // export ALL users => ADMIN only
                if (!"ADMIN".equalsIgnoreCase(sessionUser.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "admin only");
                    return;
                }
                exportAllUsersAsZip(resp);
                return;
            }

            if (userIdsParam != null && !userIdsParam.isBlank()) {
                // export multiple specified users => ADMIN only
                if (!"ADMIN".equalsIgnoreCase(sessionUser.getRole())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "admin only");
                    return;
                }

                String[] parts = userIdsParam.split(",");
                List<Long> ids = new ArrayList<>();
                for (String p : parts) {
                    try { ids.add(Long.parseLong(p.trim())); } catch (NumberFormatException ignored) {}
                }
                if (ids.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "no valid userIds");
                    return;
                }
                exportMultipleUsersAsZip(resp, ids);
                return;
            }

            // single user export
            Long targetUserId = sessionUser.getId();
            if (userIdParam != null && !userIdParam.isBlank()) {
                try {
                    targetUserId = Long.parseLong(userIdParam);
                } catch (NumberFormatException ex) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid userId");
                    return;
                }
                // allow only coaches/admins to export other users' data
                if (!Objects.equals(targetUserId, sessionUser.getId())) {
                    String role = sessionUser.getRole();
                    if (!"COACH".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "not allowed");
                        return;
                    }
                }
            }

            // single CSV response
            List<ProgressLog> logs = safeFindByUser(targetUserId);
            resp.setContentType("text/csv; charset=UTF-8");
            String fileName = "progress_user_" + targetUserId + ".csv";
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            try (PrintWriter pw = resp.getWriter()) {
                pw.println("log_date,weight_kg,notes,photo_url,thumb_url");
                for (ProgressLog l : logs) {
                    String date = l.getLogDate() == null ? "" : l.getLogDate().toString();
                    String weight = l.getWeightKg() == null ? "" : String.valueOf(l.getWeightKg());
                    String notes = safeCsv(l.getNotes());
                    String photoUrl = l.getPhotoUrl() == null ? "" : l.getPhotoUrl();
                    String thumbUrl = deriveThumb(photoUrl);
                    pw.print(quote(date)); pw.print(",");
                    pw.print(quote(weight)); pw.print(",");
                    pw.print(notes); pw.print(",");
                    pw.print(quote(photoUrl)); pw.print(",");
                    pw.print(quote(thumbUrl)); pw.println();
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "server error");
        }
    }

    // Export multiple users into a ZIP (each entry is CSV)
    private void exportMultipleUsersAsZip(HttpServletResponse resp, List<Long> ids) throws IOException {
        resp.setContentType("application/zip");
        resp.setHeader("Content-Disposition", "attachment; filename=\"progress_multiple_users.zip\"");

        try (ZipOutputStream zos = new ZipOutputStream(resp.getOutputStream())) {
            for (Long id : ids) {
                List<ProgressLog> logs;
                try {
                    logs = safeFindByUser(id);
                } catch (IOException ioe) {
                    // log and continue with empty list for this user
                    ioe.printStackTrace();
                    logs = Collections.emptyList();
                }

                String entryName = "progress_user_" + id + ".csv";
                zos.putNextEntry(new ZipEntry(entryName));
                try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
                     PrintWriter pw = new PrintWriter(new OutputStreamWriter(baos, "UTF-8"))) {

                    pw.println("log_date,weight_kg,notes,photo_url,thumb_url");
                    for (ProgressLog l : logs) {
                        String date = l.getLogDate() == null ? "" : l.getLogDate().toString();
                        String weight = l.getWeightKg() == null ? "" : String.valueOf(l.getWeightKg());
                        String notes = safeCsv(l.getNotes());
                        String photoUrl = l.getPhotoUrl() == null ? "" : l.getPhotoUrl();
                        String thumbUrl = deriveThumb(photoUrl);
                        pw.print(quote(date)); pw.print(",");
                        pw.print(quote(weight)); pw.print(",");
                        pw.print(notes); pw.print(",");
                        pw.print(quote(photoUrl)); pw.print(",");
                        pw.print(quote(thumbUrl)); pw.println();
                    }
                    pw.flush();
                    byte[] data = baos.toByteArray();
                    zos.write(data);
                } finally {
                    zos.closeEntry();
                }
            }
            zos.finish();
        }
    }

    // Export ALL users into a ZIP (ADMIN only). Fetches all users via UserDAO.
    private void exportAllUsersAsZip(HttpServletResponse resp) throws IOException {
        resp.setContentType("application/zip");
        resp.setHeader("Content-Disposition", "attachment; filename=\"progress_all_users.zip\"");

        List<User> allUsers;
        try {
            allUsers = userDAO.findAll();
        } catch (Exception e) {
            throw new IOException(e);
        }

        try (ZipOutputStream zos = new ZipOutputStream(resp.getOutputStream())) {
            for (User u : allUsers) {
                Long id = u.getId();
                List<ProgressLog> logs;
                try {
                    logs = safeFindByUser(id);
                } catch (IOException ioe) {
                    ioe.printStackTrace();
                    logs = Collections.emptyList();
                }

                String entryName = "progress_user_" + id + ".csv";
                zos.putNextEntry(new ZipEntry(entryName));
                try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
                     PrintWriter pw = new PrintWriter(new OutputStreamWriter(baos, "UTF-8"))) {

                    pw.println("log_date,weight_kg,notes,photo_url,thumb_url");
                    for (ProgressLog l : logs) {
                        String date = l.getLogDate() == null ? "" : l.getLogDate().toString();
                        String weight = l.getWeightKg() == null ? "" : String.valueOf(l.getWeightKg());
                        String notes = safeCsv(l.getNotes());
                        String photoUrl = l.getPhotoUrl() == null ? "" : l.getPhotoUrl();
                        String thumbUrl = deriveThumb(photoUrl);
                        pw.print(quote(date)); pw.print(",");
                        pw.print(quote(weight)); pw.print(",");
                        pw.print(notes); pw.print(",");
                        pw.print(quote(photoUrl)); pw.print(",");
                        pw.print(quote(thumbUrl)); pw.println();
                    }
                    pw.flush();
                    byte[] data = baos.toByteArray();
                    zos.write(data);
                } finally {
                    zos.closeEntry();
                }
            }
            zos.finish();
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    // Helper that wraps the DAO call and converts SQLException into IOException for callers
    private List<ProgressLog> safeFindByUser(Long userId) throws IOException {
        try {
            return progressDAO.findByUser(userId);
        } catch (SQLException e) {
            // wrap and rethrow as IOException so callers that stream content can handle it
            throw new IOException("Failed to fetch progress for userId=" + userId, e);
        }
    }

    // Derive thumbnail URL assuming photoUrl uses "/uploads/progress/full/<file>"
    private String deriveThumb(String photoUrl) {
        if (photoUrl == null || photoUrl.isBlank()) return "";
        if (photoUrl.contains("/uploads/progress/full/")) {
            return photoUrl.replace("/uploads/progress/full/", "/uploads/progress/thumbs/");
        }
        if (photoUrl.contains("/uploads/progress/")) {
            // best-effort
            String base = photoUrl.substring(0, photoUrl.lastIndexOf('/') + 1);
            String fname = photoUrl.substring(photoUrl.lastIndexOf('/') + 1);
            return base + "thumbs/" + fname;
        }
        return "";
    }

    // CSV helpers
    private static String quote(String s) {
        if (s == null) s = "";
        s = s.replace("\"", "\"\"");
        return "\"" + s + "\"";
    }
    private static String safeCsv(String s) {
        if (s == null) s = "";
        s = s.replace("\r", " ").replace("\n", " ");
        return quote(s);
    }
}
