package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.YearMonth;
import java.util.*;

/**
 * Returns monthly analytics for the last 12 months for a user.
 * JSON:
 * {
 *   "labels":["2025-01","2025-02",...],
 *   "avgWeights":[72.5, null, ...],
 *   "counts":[3,0, ...]
 * }
 *
 * If ?userId= is provided by an authorized coach/admin, target that user (controller should ensure authorization).
 */
@WebServlet("/progress/stats")
public class ProgressStatsServlet extends HttpServlet {
    private final ProgressDAO progressDAO = new ProgressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = session == null ? null : (User) session.getAttribute("user");
        if (sessionUser == null) {
            resp.sendError(403, "login required");
            return;
        }

        // determine target user: default = session user; allow ?userId= for coach/admin (ensure controller checks)
        String userIdParam = req.getParameter("userId");
        Long targetUserId;
        if (userIdParam != null && !userIdParam.isBlank()) {
            try { targetUserId = Long.parseLong(userIdParam); }
            catch (NumberFormatException ex) { resp.sendError(400, "bad userId"); return; }
        } else {
            targetUserId = sessionUser.getId();
        }

        try {
            List<ProgressLog> logs = progressDAO.findByUser(targetUserId); // newest-first
            // prepare empty months map (last 12 months)
            YearMonth now = YearMonth.now();
            YearMonth start = now.minusMonths(11);
            LinkedHashMap<String, List<Double>> map = new LinkedHashMap<>();
            for (int i = 0; i < 12; i++) {
                YearMonth ym = start.plusMonths(i);
                map.put(ym.toString(), new ArrayList<>());
            }

            for (ProgressLog l : logs) {
                if (l.getLogDate() == null || l.getWeightKg() == null) continue;
                YearMonth ym = YearMonth.from(l.getLogDate().toLocalDate());
                String key = ym.toString();
                List<Double> list = map.get(key);
                if (list != null) list.add(l.getWeightKg());
            }

            List<String> labels = new ArrayList<>();
            List<Double> avgWeights = new ArrayList<>();
            List<Integer> counts = new ArrayList<>();

            for (Map.Entry<String, List<Double>> e : map.entrySet()) {
                labels.add(e.getKey());
                List<Double> vals = e.getValue();
                if (vals.isEmpty()) {
                    avgWeights.add(null);
                    counts.add(0);
                } else {
                    double sum = 0;
                    for (double v : vals) sum += v;
                    avgWeights.add(sum / vals.size());
                    counts.add(vals.size());
                }
            }

            resp.setContentType("application/json");
            try (PrintWriter pw = resp.getWriter()) {
                StringBuilder sb = new StringBuilder();
                sb.append("{");
                sb.append("\"labels\":").append(toJsonStringArray(labels)).append(",");
                sb.append("\"avgWeights\":").append(toJsonNumericArray(avgWeights)).append(",");
                sb.append("\"counts\":").append(toJsonIntArray(counts));
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

    private String toJsonNumericArray(List<Double> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            Double d = list.get(i);
            if (d == null) sb.append("null");
            else sb.append(String.format(Locale.US, "%.2f", d));
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonIntArray(List<Integer> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(list.get(i));
        }
        sb.append("]");
        return sb.toString();
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
