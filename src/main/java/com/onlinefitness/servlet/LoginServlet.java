package com.onlinefitness.servlet;

import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");

        if (email == null || pass == null || email.isBlank() || pass.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=empty");
            return;
        }

        String passHash = Integer.toString(pass.hashCode());

        try {
            User u = userDAO.findByEmail(email.trim().toLowerCase());
            // null-safe password comparison: call equals on passHash (never null)
            if (u != null && passHash.equals(u.getPasswordHash())) {

                // If user is a COACH, ensure they are approved before allowing login
                if ("COACH".equals(u.getRole()) && !u.isApproved()) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?error=coach_pending");
                    return;
                }

                HttpSession session = req.getSession(true);
                u.setPasswordHash(null); // don't store hash in session
                session.setAttribute("user", u);

                // redirect by role (use servlet endpoints rather than JSP direct where possible)
                if ("COACH".equalsIgnoreCase(u.getRole())) resp.sendRedirect(req.getContextPath() + "/coach/dashboard");
                else if ("ADMIN".equalsIgnoreCase(u.getRole())) resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                else resp.sendRedirect(req.getContextPath() + "/trainee/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=server");
        }
    }
}
