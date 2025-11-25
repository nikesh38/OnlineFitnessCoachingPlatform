package com.onlinefitness.filter;

import com.onlinefitness.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) { /* no-op */ }

    private boolean isPublicPath(String path) {
        if (path == null) return true;
        path = path.toLowerCase();

        // public endpoints / resources
        if (path.equals("/") || path.equals("/index.jsp")) return true;
        if (path.startsWith("/login") || path.startsWith("/register")) return true;
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/static/")) return true;
        if (path.startsWith("/webjars/")) return true;
        if (path.contains(".css") || path.contains(".js") || path.contains(".png") || path.contains(".jpg") || path.contains(".gif")) return true;

        // allow tomcat plugin management pages
        if (path.startsWith("/favicon.ico")) return true;

        return false;
    }

    @Override
    public void doFilter(ServletRequest sr, ServletResponse sr2, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) sr;
        HttpServletResponse resp = (HttpServletResponse) sr2;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        HttpSession session = req.getSession(false);
        User sessionUser = null;
        if (session != null) sessionUser = (User) session.getAttribute("user");
        req.setAttribute("sessionUser", sessionUser);
        if (isPublicPath(path)) {
            chain.doFilter(sr, sr2);
            return;
        }

        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(sr, sr2);
    }

    @Override
    public void destroy() {  }
}
