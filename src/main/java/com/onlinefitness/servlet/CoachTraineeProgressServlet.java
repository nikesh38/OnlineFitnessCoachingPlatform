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
import java.util.*;

/**
 * Prepare trainee list for a coach and forward to the analytics JSP.
 * URL: /coach/trainees
 */
@WebServlet("/coach/trainees")
public class CoachTraineeProgressServlet extends HttpServlet {

    private final ProgramDAO programDAO = new ProgramDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User coach = session == null ? null : (User) session.getAttribute("user");
        if (coach == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (!"COACH".equalsIgnoreCase(coach.getRole()) && !"ADMIN".equalsIgnoreCase(coach.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only coaches/admins can view trainee analytics");
            return;
        }

        try {
            // 1) get programs of this coach
            List<Program> programs = programDAO.findByCoachId(coach.getId());

            // 2) collect unique trainee ids from enrollments
            Set<Long> traineeIds = new LinkedHashSet<>();
            for (Program p : programs) {
                List<Enrollment> enrollments = enrollmentDAO.findByProgram(p.getId());
                for (Enrollment e : enrollments) {
                    if (e.getUserId() != null) traineeIds.add(e.getUserId());
                }
            }

            List<User> trainees = Collections.emptyList();
            if (!traineeIds.isEmpty()) {
                trainees = userDAO.findByIds(new ArrayList<>(traineeIds));
            }

            req.setAttribute("trainees", trainees);
            req.getRequestDispatcher("/jsp/coach-progress-stats.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "server error");
        }
    }
}
