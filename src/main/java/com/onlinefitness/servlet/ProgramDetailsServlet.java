package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.dao.WorkoutDAO;
import com.onlinefitness.model.Program;
import com.onlinefitness.model.User;
import com.onlinefitness.model.Workout;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/program/details")
public class ProgramDetailsServlet extends HttpServlet {
    private final ProgramDAO programDAO = new ProgramDAO();
    private final WorkoutDAO workoutDAO = new WorkoutDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User logged = session == null ? null : (User) session.getAttribute("user");
        if (logged == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String pid = req.getParameter("id");
        if (pid == null || pid.isBlank()) {
            resp.sendError(400, "id parameter required");
            return;
        }

        try {
            Long id = Long.parseLong(pid);
            Program p = programDAO.findById(id);
            if (p == null) {
                resp.sendError(404, "Program not found");
                return;
            }
            List<Workout> workouts = workoutDAO.findByProgramId(id);
            req.setAttribute("program", p);
            req.setAttribute("workouts", workouts);
            req.getRequestDispatcher("/jsp/program-details.jsp").forward(req, resp);
        } catch (NumberFormatException nfe) {
            resp.sendError(400, "Invalid id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
