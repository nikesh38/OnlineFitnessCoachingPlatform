package com.onlinefitness.servlet;

import com.onlinefitness.dao.EnrollmentDAO;
import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.Enrollment;
import com.onlinefitness.model.Program;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/enrollments")
public class EnrollmentServlet extends HttpServlet {
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final ProgramDAO programDAO = new ProgramDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User logged = session == null ? null : (User) session.getAttribute("user");

        // If no session user, redirect to login
        if (logged == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String programIdParam = req.getParameter("programId");
        // COACH view of enrollments for a program
        if (programIdParam != null && !programIdParam.isBlank()) {
            if (!"COACH".equalsIgnoreCase(logged.getRole())) {
                resp.sendError(403, "Only coaches can view program enrollments");
                return;
            }
            try {
                Long pid = parseLongParam(programIdParam);
                if (pid == null) { resp.sendError(400, "Invalid programId"); return; }
                Program p = programDAO.findById(pid);
                if (p == null) {
                    resp.sendError(404, "Program not found");
                    return;
                }
                if (p.getCoachId() == null || !p.getCoachId().equals(logged.getId())) {
                    resp.sendError(403, "You are not authorized to view enrollments for this program");
                    return;
                }

                List<com.onlinefitness.model.Enrollment> enrollments = enrollmentDAO.findByProgram(pid);

                // load trainee details for each enrollment
                List<User> trainees = new ArrayList<>();
                for (com.onlinefitness.model.Enrollment e : enrollments) {
                    User trainee = userDAO.findById(e.getUserId());
                    trainees.add(trainee);
                }

                req.setAttribute("program", p);
                req.setAttribute("enrollments", enrollments);
                req.setAttribute("trainees", trainees);
                req.getRequestDispatcher("/jsp/coach-program-enrollments.jsp").forward(req, resp);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(500, "Server error");
                return;
            }
        }

        // Default: trainee view of *their* enrollments
        try {
            List<Enrollment> myEnrollments = enrollmentDAO.findByUser(logged.getId());
            req.setAttribute("enrollments", myEnrollments);
            req.getRequestDispatcher("/jsp/enrollment-list.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }

    // enroll action: trainees enroll themselves in a program
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User logged = session == null ? null : (User) session.getAttribute("user");

        if (logged == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Only trainees (or anyone) can enroll — you may enforce only TRAINEE if you want
        String programIdParam = req.getParameter("programId");
        if (programIdParam == null || programIdParam.isBlank()) {
            resp.sendError(400, "programId is required");
            return;
        }

        try {
            Long pid = parseLongParam(programIdParam);
            if (pid == null) { resp.sendError(400, "Invalid programId"); return; }
            // Optionally you can check if program exists
            Program p = programDAO.findById(pid);
            if (p == null) {
                resp.sendError(404, "Program not found");
                return;
            }

            Enrollment e = new Enrollment();
            e.setUserId(logged.getId());
            e.setProgramId(pid);
            // start_date left null -> DAO will set null or default; we set status active
            e.setStatus("ACTIVE");
            enrollmentDAO.enroll(e);

            // redirect trainee to their enrollments page
            resp.sendRedirect(req.getContextPath() + "/enrollments");
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }

    private Long parseLongParam(String s) {
        try { return s == null ? null : Long.parseLong(s.trim()); } catch (NumberFormatException ex) { return null; }
    }
}
