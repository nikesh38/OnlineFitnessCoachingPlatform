package com.onlinefitness.servlet;

import com.onlinefitness.dao.MessageDAO;
import com.onlinefitness.model.Message;
import com.onlinefitness.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {
    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // conversation with another user; ensure logged in
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        String b = req.getParameter("b"); // other party
        if (b == null) { resp.sendError(400, "b required"); return; }

        try {
            Long other = parseLongParam(b);
            if (other == null) { resp.sendError(400, "bad id"); return; }
            List<Message> conv = messageDAO.conversation(u.getId(), other);
            req.setAttribute("messages", conv);
            req.getRequestDispatcher("/jsp/messages.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500,"Server error");
        }
    }

    // send - uses session user as sender
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User u = session == null ? null : (User) session.getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }

        try {
            Message m = new Message();
            m.setSenderId(u.getId());
            Long receiver = parseLongParam(req.getParameter("receiverId"));
            if (receiver == null) { resp.sendError(400, "receiverId required"); return; }
            m.setReceiverId(receiver);
            m.setMessage(req.getParameter("message"));
            messageDAO.sendMessage(m);
            resp.sendRedirect(req.getContextPath() + "/messages?b=" + receiver);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500,"Server error");
        }
    }

    private Long parseLongParam(String s) {
        try { return s == null ? null : Long.parseLong(s.trim()); } catch (NumberFormatException ex) { return null; }
    }
}
