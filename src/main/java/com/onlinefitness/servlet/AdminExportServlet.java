package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;
import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.Enrollment;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/export")
public class AdminExportServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Only ADMIN allowed
        HttpSession session = req.getSession(false);
        User admin = session == null ? null : (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            resp.sendError(403, "Admin access required");
            return;
        }

        String type = req.getParameter("type");
        if (type == null) {
            resp.sendError(400, "type parameter required (users|enrollments)");
            return;
        }

        try {
            if ("users".equalsIgnoreCase(type)) {
                exportUsers(resp);
            } else if ("enrollments".equalsIgnoreCase(type)) {
                exportEnrollments(resp);
            } else {
                resp.sendError(400, "unknown type");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }

    private void exportUsers(HttpServletResponse resp) throws Exception {
        List<User> users = userDAO.findAll();
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"users.csv\"");
        try (PrintWriter pw = resp.getWriter()) {
            // header
            pw.println("id,name,email,role,is_approved,age,gender,height_cm,weight_kg,created_at");
            for (User u : users) {
                String line = String.format("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s",
                        u.getId() == null ? "" : u.getId().toString(),
                        csvEscape(u.getName()),
                        csvEscape(u.getEmail()),
                        u.getRole(),
                        u.isApproved() ? "1" : "0",
                        u.getAge() == null ? "" : u.getAge().toString(),
                        csvEscape(u.getGender()),
                        u.getHeightCm() == null ? "" : u.getHeightCm().toString(),
                        u.getWeightKg() == null ? "" : u.getWeightKg().toString(),
                        u.getCreatedAt() == null ? "" : u.getCreatedAt().toString()
                );
                pw.println(line);
            }
        }
    }

    private void exportEnrollments(HttpServletResponse resp) throws Exception {
        List<Enrollment> list = enrollmentDAO.findAll();
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"enrollments.csv\"");
        try (PrintWriter pw = resp.getWriter()) {
            pw.println("id,user_id,program_id,start_date,status");
            for (Enrollment e : list) {
                String line = String.format("%s,%s,%s,%s,%s",
                        e.getId() == null ? "" : e.getId().toString(),
                        e.getUserId() == null ? "" : e.getUserId().toString(),
                        e.getProgramId() == null ? "" : e.getProgramId().toString(),
                        e.getStartDate() == null ? "" : e.getStartDate().toString(),
                        csvEscape(e.getStatus()));
                pw.println(line);
            }
        }
    }

    private String csvEscape(String s) {
        if (s == null) return "";
        String out = s.replace("\"", "\"\"");
        if (out.contains(",") || out.contains("\"") || out.contains("\n")) {
            out = "\"" + out + "\"";
        }
        return out;
    }
}
