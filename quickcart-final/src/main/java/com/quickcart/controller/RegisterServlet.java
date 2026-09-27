package com.quickcart.controller;

import com.quickcart.dao.UserDAO;
import com.quickcart.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller Servlet handling Customer Registration.
 * Validates inputs, prevents duplicate emails, and creates a user record in MySQL.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate required fields
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            mobile == null || mobile.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required.");
            preserveFormData(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        name = name.trim();
        email = email.trim();
        mobile = mobile.trim();
        password = password.trim();

        // Validate password confirmation match
        if (confirmPassword != null && !password.equals(confirmPassword.trim())) {
            request.setAttribute("errorMessage", "Passwords do not match. Please re-enter.");
            preserveFormData(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Prevent duplicate email registrations
        if (userDAO.checkEmailExists(email)) {
            request.setAttribute("errorMessage", "This email address is already registered. Please login.");
            preserveFormData(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create new Customer record (role: CUSTOMER)
        User newUser = new User(name, email, mobile, password, "CUSTOMER");
        boolean isRegistered = userDAO.registerUser(newUser);

        if (isRegistered) {
            User registeredUser = userDAO.loginUser(email, password);
            if (registeredUser != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", registeredUser);
                session.setAttribute("userId", registeredUser.getId());
                session.setAttribute("userName", registeredUser.getName());
                session.setAttribute("userEmail", registeredUser.getEmail());
                session.setAttribute("role", registeredUser.getRole());
                
                response.sendRedirect(request.getContextPath() + "/index.jsp?registered=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=success");
            }
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            preserveFormData(request, name, email, mobile);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormData(HttpServletRequest request, String name, String email, String mobile) {
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("mobile", mobile);
    }
}
