package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.model.Program;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/coach/dashboard")
public class CoachDashboardServlet extends HttpServlet {
    private final ProgramDAO programDAO = new ProgramDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (!"COACH".equalsIgnoreCase(u.getRole())) {
            resp.sendError(403, "Only coaches can access this page");
            return;
        }

        // read filter params (from query string)
        String q = req.getParameter("q");                       // search text
        String difficulty = req.getParameter("difficulty");     // difficulty (e.g., Beginner/Intermediate/Advanced)
        String minDurS = req.getParameter("minDuration");
        String maxDurS = req.getParameter("maxDuration");
        String maxPriceS = req.getParameter("maxPrice");

        Integer minDuration = null;
        Integer maxDuration = null;
        Double maxPrice = null;

        try {
            if (minDurS != null && !minDurS.isBlank()) minDuration = Integer.parseInt(minDurS);
        } catch (NumberFormatException ignored) {}

        try {
            if (maxDurS != null && !maxDurS.isBlank()) maxDuration = Integer.parseInt(maxDurS);
        } catch (NumberFormatException ignored) {}

        try {
            if (maxPriceS != null && !maxPriceS.isBlank()) maxPrice = Double.parseDouble(maxPriceS);
        } catch (NumberFormatException ignored) {}

        try {
            // use coachId to restrict results to this coach
            List<Program> programs = programDAO.findByFilters(u.getId(), q, difficulty, minDuration, maxDuration, maxPrice);

            // keep filter state so JSP can pre-fill inputs
            req.setAttribute("programs", programs);
            req.setAttribute("q", q == null ? "" : q);
            req.setAttribute("difficulty", difficulty == null ? "ALL" : difficulty);
            req.setAttribute("minDuration", minDuration == null ? "" : minDuration.toString());
            req.setAttribute("maxDuration", maxDuration == null ? "" : maxDuration.toString());
            req.setAttribute("maxPrice", maxPrice == null ? "" : maxPrice.toString());

            req.getRequestDispatcher("/jsp/coach-dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
