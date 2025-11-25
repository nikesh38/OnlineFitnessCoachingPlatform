package com.onlinefitness.servlet;

import com.onlinefitness.dao.UserDAO;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

@WebServlet("/admin/approvals")
public class AdminApprovalServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("user");
        if (o == null || !(o instanceof User)) return false;
        User u = (User) o;
        return u.getRole() != null && "ADMIN".equalsIgnoreCase(u.getRole());
    }

    private User getCurrentUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return null;
        Object o = s.getAttribute("user");
        if (o instanceof User) return (User) o;
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendError(403, "Admin access required");
            return;
        }

        try {
            List<User> pending = userDAO.findPendingCoaches();
            req.setAttribute("pendingCoaches", pending);
            req.getRequestDispatcher("/jsp/admin-approvals.jsp").forward(req, resp);
        } catch (Exception e) {
            log("Error loading pending coaches", e);
            resp.sendError(500, "Server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendError(403, "Admin access required");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isBlank()) idParam = req.getParameter("coachId");

        String action = req.getParameter("action");
        if (idParam == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=invalid");
            return;
        }

        Long coachId = parseLongParam(idParam);
        if (coachId == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=badid");
            return;
        }

        User admin = getCurrentUser(req);
        Long adminId = admin != null ? admin.getId() : null;

        try {
            if ("approve".equalsIgnoreCase(action)) {
                boolean ok = userDAO.approveCoach(coachId, adminId);
                if (ok) {
                    log("Coach approved: id=" + coachId + " by admin=" + adminId);
                    resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=approved");
                } else {
                    log("Failed to approve coach: id=" + coachId);
                    resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=approve_failed");
                }
                return;
            } else if ("reject".equalsIgnoreCase(action)) {

                com.onlinefitness.model.User u = userDAO.findById(coachId);
                if (u == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=notfound");
                    return;
                }
                u.setRole("TRAINEE");
                u.setApproved(false);
                boolean ok = userDAO.update(u);
                if (ok) {
                    log("Coach rejected/demoted: id=" + coachId + " by admin=" + adminId);
                    resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=rejected");
                } else {
                    log("Failed to reject/demote coach: id=" + coachId);
                    resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=reject_failed");
                }
                return;
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=unknown_action");
            }
        } catch (Exception e) {
            log("Exception in admin approval action (coachId=" + coachId + ", action=" + action + ")", e);
            resp.sendRedirect(req.getContextPath() + "/admin/approvals?msg=server_error");
        }
    }

    private Long parseLongParam(String s) {
        try {
            return s == null ? null : Long.parseLong(s.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
