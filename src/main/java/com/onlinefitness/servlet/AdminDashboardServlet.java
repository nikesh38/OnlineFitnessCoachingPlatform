package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;
import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ProgramDAO programDAO = new ProgramDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        User u = (User) s.getAttribute("user");
        return u != null && "ADMIN".equalsIgnoreCase(u.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ensure only admin reaches here
        if (!isAdmin(req)) {
            resp.sendError(403, "Admin access required");
            return;
        }

        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            Map<String,Object> stats = new HashMap<>();
            try { stats.put("totalUsers", userDAO.findAll().size()); } catch (Exception ex) { stats.put("totalUsers", "N/A"); ex.printStackTrace(); }
            try { stats.put("totalPrograms", programDAO.findAll().size()); } catch (Exception ex) { stats.put("totalPrograms", "N/A"); ex.printStackTrace(); }
            try { stats.put("totalEnrollments", enrollmentDAO.findAll().size()); } catch (Exception ex) { stats.put("totalEnrollments", "N/A"); ex.printStackTrace(); }

            try { req.setAttribute("pendingCoaches", userDAO.findPendingCoaches()); } catch (Exception ex) { req.setAttribute("pendingCoaches", null); ex.printStackTrace(); }

            req.setAttribute("stats", stats);
            // forward normally — wrap in try so we catch forward-time errors
            try {
                req.getRequestDispatcher("/jsp/admin-dashboard.jsp").forward(req, resp);
            } catch (Throwable forwardEx) {
                // If forward to JSP fails, print stacktrace (debug)
                out.println("<h2>Forward to JSP failed — stacktrace below (DEBUG)</h2><pre>");
                forwardEx.printStackTrace(out);
                out.println("</pre>");
            }
        } catch (Throwable ex) {
            // DEBUG: print full stacktrace to browser so you can paste it here
            out.println("<h2>Server exception (DEBUG)</h2>");
            out.println("<p>Paste the stacktrace you see below into our chat.</p>");
            out.println("<pre>");
            ex.printStackTrace(out);
            out.println("</pre>");
        } finally {
            out.close();
        }
    }
}
