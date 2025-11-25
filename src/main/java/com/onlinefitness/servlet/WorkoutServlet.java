package com.onlinefitness.servlet;

import com.onlinefitness.dao.WorkoutDAO;
import com.onlinefitness.model.User;
import com.onlinefitness.model.Workout;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/workouts")
public class WorkoutServlet extends HttpServlet {
    private final WorkoutDAO workoutDAO = new WorkoutDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pid = req.getParameter("programId");
        if (pid == null) { resp.sendError(400, "programId required"); return; }
        try {
            Long programId = Long.parseLong(pid);
            List<Workout> list = workoutDAO.findByProgramId(programId);
            req.setAttribute("workouts", list);
            req.getRequestDispatcher("/jsp/workout-list.jsp").forward(req, resp);
        } catch (NumberFormatException nfe) {
            resp.sendError(400, "invalid programId");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }

    // create workout (only coach allowed)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        if (!"COACH".equalsIgnoreCase(u.getRole())) {
            resp.sendError(403, "Only coaches can add workouts");
            return;
        }

        try {
            Workout w = new Workout();
            w.setProgramId(Long.parseLong(req.getParameter("programId")));
            w.setDayNumber(Integer.parseInt(req.getParameter("dayNumber")));
            w.setTitle(req.getParameter("title"));
            w.setInstructions(req.getParameter("instructions"));
            w.setMediaUrl(req.getParameter("mediaUrl"));
            workoutDAO.create(w);
            resp.sendRedirect(req.getContextPath() + "/workouts?programId=" + w.getProgramId());
        } catch (NumberFormatException nfe) {
            resp.sendError(400, "invalid numeric param");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
