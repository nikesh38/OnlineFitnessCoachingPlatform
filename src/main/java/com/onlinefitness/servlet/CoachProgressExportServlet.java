package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;
import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/coach/export-progress")
public class CoachProgressExportServlet extends HttpServlet {
    private final ProgressDAO progressDAO = new ProgressDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ProgramDAO programDAO = new ProgramDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User coach = session == null ? null : (User) session.getAttribute("user");
        if (coach == null || !"COACH".equalsIgnoreCase(coach.getRole())) { resp.sendError(403); return; }

        String traineeId = req.getParameter("userId");
        try {
            if (traineeId == null || traineeId.isBlank()) {
                // export all trainees of this coach (trainees enrolled in any of coach's programs)
                resp.setContentType("text/csv");
                resp.setHeader("Content-Disposition", "attachment; filename=\"coach_progress_all.csv\"");
                try (PrintWriter pw = resp.getWriter()) {
                    pw.println("user_id,user_name,log_id,log_date,weight_kg,notes,photo_url");
                    // iterate programs -> enrollments -> progress logs
                    for (var p : programDAO.findByCoach(coach.getId())) {
                        var enrolls = enrollmentDAO.findByProgram(p.getId());
                        for (var e : enrolls) {
                            User u = userDAO.findById(e.getUserId());
                            if (u == null) continue;
                            List<ProgressLog> logs = progressDAO.findByUser(u.getId());
                            for (ProgressLog l : logs) {
                                pw.printf("%s,%s,%s,%s,%s,%s,%s%n",
                                        u.getId() == null ? "" : u.getId().toString(),
                                        csvEscape(u.getName()),
                                        l.getId() == null ? "" : l.getId().toString(),
                                        l.getLogDate() == null ? "" : l.getLogDate().toString(),
                                        l.getWeightKg() == null ? "" : l.getWeightKg().toString(),
                                        csvEscape(l.getNotes()),
                                        csvEscape(l.getPhotoUrl()));
                            }
                        }
                    }
                }
            } else {
                Long uid = parseLongParam(traineeId);
                if (uid == null) { resp.sendError(400, "invalid userId"); return; }
                // check that trainee is enrolled in at least one coach's program (ownership check)
                boolean allowed = false;
                for (var p : programDAO.findByCoach(coach.getId())) {
                    var enrolls = enrollmentDAO.findByProgram(p.getId());
                    for (var e : enrolls) if (e.getUserId() != null && e.getUserId().equals(uid)) { allowed = true; break; }
                    if (allowed) break;
                }
                if (!allowed) { resp.sendError(403); return; }
                List<ProgressLog> logs = progressDAO.findByUser(uid);
                resp.setContentType("text/csv");
                resp.setHeader("Content-Disposition", "attachment; filename=\"progress_user_" + uid + ".csv\"");
                try (PrintWriter pw = resp.getWriter()) {
                    pw.println("id,log_date,weight_kg,notes,photo_url");
                    for (ProgressLog l : logs) {
                        pw.printf("%s,%s,%s,%s,%s%n",
                                l.getId() == null ? "" : l.getId().toString(),
                                l.getLogDate() == null ? "" : l.getLogDate().toString(),
                                l.getWeightKg() == null ? "" : l.getWeightKg().toString(),
                                csvEscape(l.getNotes()),
                                csvEscape(l.getPhotoUrl()));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); resp.sendError(500); }
    }

    private String csvEscape(String s) {
        if (s == null) return "";
        String out = s.replace("\"", "\"\"");
        if (out.contains(",") || out.contains("\"") || out.contains("\n")) out = "\"" + out + "\"";
        return out;
    }

    private Long parseLongParam(String s) {
        try { return s == null ? null : Long.parseLong(s.trim()); } catch (NumberFormatException ex) { return null; }
    }
}
