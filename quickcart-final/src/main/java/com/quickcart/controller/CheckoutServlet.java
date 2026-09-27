package com.quickcart.controller;

import com.quickcart.dao.CartDAO;
import com.quickcart.model.CartItem;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller Servlet handling Checkout page presentation and initial calculations.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        List<CartItem> cartItems = cartDAO.getCartByUserId(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        double subtotal = cartDAO.calculateCartTotal(userId);
        double deliveryFee = (subtotal >= 499.0) ? 0.0 : 40.0;
        double handlingFee = 5.0;
        double grandTotal = subtotal + deliveryFee + handlingFee;

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("handlingFee", handlingFee);
        request.setAttribute("grandTotal", grandTotal);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to OrderServlet for processing the order
        request.getRequestDispatcher("/place-order").forward(request, response);
    }
}
