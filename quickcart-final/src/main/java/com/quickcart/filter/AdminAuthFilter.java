package com.quickcart.filter;

import com.quickcart.model.User;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Security Filter for Admin Endpoints.
 * Intercepts all requests matching /admin/* and ensures only users
 * with ADMIN role are permitted to view or perform operations.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                chain.doFilter(req, res); // Authorized admin, proceed
                return;
            }
        }

        // Unauthorized access: redirect to login
        if (session != null) {
            session.setAttribute("redirectAfterLogin", request.getRequestURI());
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
    }

    @Override
    public void destroy() {
    }
}
