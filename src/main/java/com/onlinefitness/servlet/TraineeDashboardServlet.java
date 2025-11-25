package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgramDAO;
import com.onlinefitness.model.Program;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/trainee/dashboard")
public class TraineeDashboardServlet extends HttpServlet {
    private final ProgramDAO programDAO = new ProgramDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // require login
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Program> programs = programDAO.findAll(); // show all programs
            req.setAttribute("programs", programs);
            req.getRequestDispatcher("/jsp/dashboard-trainee.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
