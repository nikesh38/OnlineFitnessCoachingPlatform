package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.dao.WorkoutDAO;
import com.onlinefitness.model.Program;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

/**
 * ProgramServlet
 * routes:
 *  GET  /programs            -> list
 *  GET  /programs/new        -> show create form
 *  GET  /programs/view?id=.. -> view by query param
 *  GET  /programs/{id}       -> view by path segment
 *  POST /programs            -> create
 *
 * Notes:
 *  - ProgramDAO methods assumed to use Long ids (findById(Long), findAll(), create(Program) -> Long)
 *  - WorkoutDAO assumed to expose findByProgramId(Long)
 */
@WebServlet(name = "ProgramServlet", urlPatterns = {"/programs", "/programs/*"})
public class ProgramServlet extends HttpServlet {
    private ProgramDAO programDAO;
    private WorkoutDAO workoutDAO;

    @Override
    public void init() throws ServletException {
        programDAO = new ProgramDAO();
        workoutDAO = new WorkoutDAO(); // implement to fetch workouts by programId
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // may be null, "/new", "/view", "/{id}" depending on usage

        // Normalize path: treat null or "/" as listing
        if (path == null || "/".equals(path)) {
            listPrograms(req, resp);
            return;
        }

        switch (path) {
            case "/new":
                // show create form
                req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
                return;

            case "/view":
                String idParam = req.getParameter("id");
                if (idParam == null || idParam.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/programs");
                    return;
                }
                try {
                    Long id = Long.parseLong(idParam.trim());
                    viewProgram(req, resp, id);
                } catch (NumberFormatException ex) {
                    resp.sendRedirect(req.getContextPath() + "/programs");
                }
                return;

            default:
                // try path like "/123" -> view program with id
                if (path.startsWith("/")) {
                    String maybeId = path.substring(1);
                    // if path contains additional segments like "/123/edit", only take first segment
                    if (maybeId.contains("/")) maybeId = maybeId.substring(0, maybeId.indexOf('/'));
                    try {
                        Long id = Long.parseLong(maybeId);
                        viewProgram(req, resp, id);
                        return;
                    } catch (NumberFormatException ignored) { /* fall through to redirect */ }
                }
                resp.sendRedirect(req.getContextPath() + "/programs");
        }
    }

    private void listPrograms(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Program> programs = programDAO.findAll();
            req.setAttribute("programs", programs);
            req.getRequestDispatcher("/jsp/program-list.jsp").forward(req, resp);
        } catch (Exception e) {
            log("Failed to list programs", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    private void viewProgram(HttpServletRequest req, HttpServletResponse resp, Long id) throws ServletException, IOException {
        try {
            Program p = programDAO.findById(id);
            if (p == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Program not found");
                return;
            }
            req.setAttribute("program", p);
            // fetch workouts - WorkoutDAO should provide findByProgramId(Long)
            try {
                req.setAttribute("workouts", workoutDAO.findByProgramId(id));
            } catch (Exception ex) {
                // If workouts fail, just continue without them (avoid breaking view)
                log("Warning: failed to load workouts for program " + id, ex);
                req.setAttribute("workouts", null);
            }
            req.getRequestDispatcher("/jsp/program-details.jsp").forward(req, resp);
        } catch (Exception e) {
            log("Error viewing program id=" + id, e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // handle create program (form posts to /programs)
        req.setCharacterEncoding("UTF-8");

        String title = trim(req.getParameter("title"));
        String description = trim(req.getParameter("description"));
        String durationDaysStr = trim(req.getParameter("duration_days"));
        String difficulty = trim(req.getParameter("difficulty"));
        String priceStr = trim(req.getParameter("price"));

        // Basic validation
        if (title == null || title.isEmpty()) {
            req.setAttribute("error", "Title is required");
            req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
            return;
        }

        Integer durationDays = null;
        try {
            if (durationDaysStr != null && !durationDaysStr.isEmpty()) {
                durationDays = Integer.parseInt(durationDaysStr);
                if (durationDays < 0) durationDays = null;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid duration");
            req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
            return;
        }

        Double price = null;
        try {
            if (priceStr != null && !priceStr.isEmpty()) {
                price = Double.parseDouble(priceStr);
                if (price < 0) price = null;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid price");
            req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
            return;
        }

        Program p = new Program();
        p.setTitle(title);
        p.setDescription(description == null ? "" : description);
        p.setDurationDays(durationDays); // allow null in model if DAO supports it
        p.setDifficulty(difficulty == null ? "" : difficulty);
        p.setPrice(price == null ? 0.0 : price);

        // Try to set coachId from session user if available and user has getId()
        HttpSession session = req.getSession(false);
        Long coachId = 0L;
        if (session != null) {
            Object userObj = session.getAttribute("user");
            if (userObj != null) {
                try {
                    // Prefer known model class if present
                    if (userObj.getClass().getName().equals("com.onlinefitness.model.User")) {
                        // safe cast
                        com.onlinefitness.model.User su = (com.onlinefitness.model.User) userObj;
                        coachId = su.getId();
                    } else {
                        // fallback to reflection (keeps compatibility)
                        Object idVal = userObj.getClass().getMethod("getId").invoke(userObj);
                        if (idVal instanceof Number) coachId = ((Number) idVal).longValue();
                    }
                } catch (Exception ignored) {
                    // fallback remains 0
                }
            }
        }
        p.setCoachId(coachId);

        try {
            // assume ProgramDAO.create returns Long (new id) or null on failure
            Long createdId = programDAO.create(p);
            if (createdId != null && createdId > 0) {
                resp.sendRedirect(req.getContextPath() + "/programs");
            } else {
                req.setAttribute("error", "Failed to create program");
                req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            log("Failed to create program", e);
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/jsp/program-form.jsp").forward(req, resp);
        }
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
