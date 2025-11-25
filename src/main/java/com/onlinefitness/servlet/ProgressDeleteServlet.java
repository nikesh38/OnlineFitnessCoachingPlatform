package com.onlinefitness.servlet;

import com.onlinefitness.dao.ProgressDAO;
import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/progress/delete")
public class ProgressDeleteServlet extends HttpServlet {
    private final ProgressDAO progressDAO = new ProgressDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.sendError(400, "id required");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            ProgressLog existing = progressDAO.findById(id);
            if (existing == null) {
                resp.sendError(404, "Progress log not found");
                return;
            }

            if (existing.getUserId() == null || !existing.getUserId().equals(user.getId())) {
                resp.sendError(403, "Not authorized to delete this log");
                return;
            }

            boolean ok = progressDAO.delete(id);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/progress?msg=deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/progress?msg=delete_failed");
            }
        } catch (NumberFormatException nfe) {
            resp.sendError(400, "Invalid id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Server error");
        }
    }
}
