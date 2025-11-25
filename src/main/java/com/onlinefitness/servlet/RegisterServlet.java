package com.onlinefitness.servlet;

import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name  = req.getParameter("name");
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        String roleParam = req.getParameter("role"); // TRAINEE or COACH

        if (name == null || email == null || pass == null ||
                name.isBlank() || email.isBlank() || pass.isBlank()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        String role = "TRAINEE";
        if (roleParam != null && !roleParam.isBlank()) {
            role = roleParam.trim().toUpperCase();
            if (!role.equals("TRAINEE") && !role.equals("COACH")) role = "TRAINEE";
        }

        String passHash = Integer.toString(pass.hashCode());

        User u = new User();
        u.setName(name.trim());
        u.setEmail(email.trim().toLowerCase());
        u.setPasswordHash(passHash);
        u.setRole(role);

        if ("COACH".equals(role)) {
            u.setApproved(false);
        } else {
            u.setApproved(true);
        }

        try {
            if (userDAO.findByEmail(u.getEmail()) != null) {
                req.setAttribute("error", "Email already registered.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            Long createdId = userDAO.save(u);
            if (createdId != null && createdId > 0) {
                if ("COACH".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=registered_coach");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=registered");
                }
            } else {
                req.setAttribute("error", "Registration failed. Try again.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
