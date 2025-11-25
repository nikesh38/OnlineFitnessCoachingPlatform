package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/stats")
public class AdminStatsServlet extends HttpServlet {
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // admin only
        HttpSession session = req.getSession(false);
        Object userObj = session == null ? null : session.getAttribute("user");
        if (userObj == null) {
            resp.sendError(403, "Admin required");
            return;
        }
        // We do a string role check here to be safe
        try {
            // If user is not admin (we assume User has getRole() method), reject
            com.onlinefitness.model.User u = (com.onlinefitness.model.User) userObj;
            if (!"ADMIN".equalsIgnoreCase(u.getRole())) {
                resp.sendError(403, "Admin required");
                return;
            }
        } catch (Exception ignored) {}

        try {
            // monthly enrollments
            LinkedHashMap<String,Integer> monthly = enrollmentDAO.getMonthlyEnrollmentsLast12Months();
            List<Map.Entry<String,Integer>> popularity = enrollmentDAO.getProgramPopularityTop(10);

            resp.setContentType("application/json");
            try (PrintWriter pw = resp.getWriter()) {
                StringBuilder sb = new StringBuilder();
                sb.append("{");
                // monthly array
                sb.append("\"monthly\":{\"labels\":[");
                boolean first = true;
                for (String k : monthly.keySet()) {
                    if (!first) sb.append(",");
                    sb.append("\"").append(k).append("\"");
                    first = false;
                }
                sb.append("],\"data\":[");
                first = true;
                for (Integer v : monthly.values()) {
                    if (!first) sb.append(",");
                    sb.append(v);
                    first = false;
                }
                sb.append("]},");

                // popularity
                sb.append("\"popularity\":{\"labels\":[");
                first = true;
                for (Map.Entry<String,Integer> e : popularity) {
                    if (!first) sb.append(",");
                    sb.append("\"").append(escapeJson(e.getKey())).append("\"");
                    first = false;
                }
                sb.append("],\"data\":[");
                first = true;
                for (Map.Entry<String,Integer> e : popularity) {
                    if (!first) sb.append(",");
                    sb.append(e.getValue());
                    first = false;
                }
                sb.append("]}");

                sb.append("}");
                pw.print(sb.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
