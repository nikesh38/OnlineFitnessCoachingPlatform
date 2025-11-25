package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;
import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.model.Enrollment;
import com.onlinefitness.model.Program;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/coach/program-enrollments")
public class ProgramEnrollmentServlet extends HttpServlet {
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
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

        String pid = req.getParameter("programId");
        if (pid == null || pid.isBlank()) {
            resp.sendError(400, "programId is required");
            return;
        }

        try {
            Long programId = Long.parseLong(pid);
            Program p = programDAO.findById(programId);
            if (p == null || p.getCoachId() == null || !p.getCoachId().equals(u.getId())) {
                resp.sendError(403, "You are not authorized to view enrollments for this program");
                return;
            }

            List<Enrollment> enrollments = enrollmentDAO.findByProgram(programId);
            req.setAttribute("program", p);
            req.setAttribute("enrollments", enrollments);
            req.getRequestDispatcher("/jsp/coach-program-enrollments.jsp").forward(req, resp);
        } catch (NumberFormatException nfe) {
            resp.sendError(400, "Invalid programId");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
