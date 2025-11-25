package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Returns JSON for Chart.js describing the user's weight timeline:
 * { "labels": ["2025-01-01", ...], "data": [72.5, 72.3, ...] }
 * Logs are reversed to provide oldest->newest order.
 */
@WebServlet("/progress/data")
public class ProgressDataServlet extends HttpServlet {
    private final ProgressDAO progressDAO = new ProgressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            resp.sendError(403, "login required");
            return;
        }

        try {
            List<ProgressLog> logs = progressDAO.findByUser(user.getId()); // newest-first by DAO
            Collections.reverse(logs); // oldest-first for chart

            List<String> labels = new ArrayList<>();
            List<String> values = new ArrayList<>();

            for (ProgressLog l : logs) {
                labels.add(l.getLogDate() == null ? "" : l.getLogDate().toString());
                if (l.getWeightKg() == null) values.add("null");
                else values.add(String.valueOf(l.getWeightKg()));
            }

            resp.setContentType("application/json");
            try (PrintWriter pw = resp.getWriter()) {
                StringBuilder sb = new StringBuilder();
                sb.append("{");
                sb.append("\"labels\":").append(toJsonStringArray(labels)).append(",");
                sb.append("\"data\":").append(toJsonNumericArray(values));
                sb.append("}");
                pw.print(sb.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "server error");
        }
    }

    private String toJsonStringArray(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(escape(list.get(i))).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonNumericArray(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            String v = list.get(i);
            if (v == null || v.equalsIgnoreCase("null") || v.isBlank()) sb.append("null");
            else sb.append(v);
        }
        sb.append("]");
        return sb.toString();
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
