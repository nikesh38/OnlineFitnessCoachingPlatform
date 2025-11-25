package com.onlinefitness.servlet;

import com.onlinefitness.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;

/**
 * Admin CSV export for recent enrollments.
 * URL: /admin/export/enrollments?days=30
 * Admin only.
 */
@WebServlet("/admin/export/enrollments")
public class AdminExportEnrollmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        com.onlinefitness.model.User sessionUser = session == null ? null : (com.onlinefitness.model.User) session.getAttribute("user");
        if (sessionUser == null || !"ADMIN".equalsIgnoreCase(sessionUser.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "admin only");
            return;
        }

        String daysParam = req.getParameter("days");
        int days = 30;
        try {
            if (daysParam != null && !daysParam.isBlank()) days = Integer.parseInt(daysParam);
        } catch (NumberFormatException ignored) { days = 30; }

        LocalDate threshold = LocalDate.now().minusDays(days);

        String sql = "SELECT e.id AS enrollment_id, e.user_id, u.name AS user_name, u.email AS user_email, " +
                "e.program_id, p.title AS program_title, e.start_date, e.status " +
                "FROM enrollments e " +
                "LEFT JOIN users u ON e.user_id = u.id " +
                "LEFT JOIN programs p ON e.program_id = p.id " +
                "WHERE e.start_date >= ? " +
                "ORDER BY e.start_date DESC";

        resp.setContentType("text/csv; charset=UTF-8");
        String fname = "recent_enrollments_last_" + days + "d.csv";
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fname + "\"");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(threshold));

            try (ResultSet rs = ps.executeQuery();
                 PrintWriter pw = resp.getWriter()) {

                pw.println("enrollment_id,user_id,user_name,user_email,program_id,program_title,start_date,status");

                while (rs.next()) {
                    long enrollId = rs.getLong("enrollment_id");
                    long userId = rs.getLong("user_id");
                    String userName = rs.getString("user_name");
                    String userEmail = rs.getString("user_email");
                    long programId = rs.getLong("program_id");
                    String programTitle = rs.getString("program_title");
                    Date startDate = rs.getDate("start_date");
                    String status = rs.getString("status");

                    pw.print(quote(String.valueOf(enrollId))); pw.print(",");
                    pw.print(quote(String.valueOf(userId))); pw.print(",");
                    pw.print(quote(userName)); pw.print(",");
                    pw.print(quote(userEmail)); pw.print(",");
                    pw.print(quote(String.valueOf(programId))); pw.print(",");
                    pw.print(quote(programTitle)); pw.print(",");
                    pw.print(quote(startDate == null ? "" : startDate.toString())); pw.print(",");
                    pw.print(quote(status)); pw.println();
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "server error");
        }
    }

    private static String quote(String s) {
        if (s == null) s = "";
        s = s.replace("\"", "\"\"");
        return "\"" + s + "\"";
    }
}
