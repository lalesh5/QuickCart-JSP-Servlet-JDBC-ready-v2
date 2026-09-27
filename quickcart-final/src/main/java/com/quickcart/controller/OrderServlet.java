package com.quickcart.controller;

import com.quickcart.dao.CartDAO;
import com.quickcart.dao.OrderDAO;
import com.quickcart.model.CartItem;
import com.quickcart.model.Order;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling:
 * - /place-order (POST processes transactional order creation)
 * - /orders (GET customer order history)
 * - /order-details (GET order tracking & breakdown)
 * - /order-success and /order-confirmation (GET order confirmation view)
 */
@WebServlet(urlPatterns = {"/place-order", "/orders", "/order-details", "/order-confirmation", "/order-success"})
public class OrderServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", request.getContextPath() + request.getServletPath());
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String path = request.getServletPath();

        switch (path) {
            case "/orders":
                handleOrderHistory(request, response, userId);
                break;
            case "/order-details":
                handleOrderDetails(request, response, userId);
                break;
            case "/order-confirmation":
            case "/order-success":
                handleOrderConfirmation(request, response, userId);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/orders");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String path = request.getServletPath();

        if ("/place-order".equals(path)) {
            handlePlaceOrder(request, response, userId);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        
        List<CartItem> cartItems = cartDAO.getCartByUserId(userId);
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
            return;
        }

        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String mobile = request.getParameter("mobile");
        String paymentMethod = request.getParameter("paymentMethod");

        if (address == null || address.trim().isEmpty() ||
            city == null || city.trim().isEmpty() ||
            pincode == null || pincode.trim().isEmpty() ||
            mobile == null || mobile.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All address and contact fields are required.");
            request.getRequestDispatcher("/checkout").forward(request, response);
            return;
        }

        double subtotal = cartDAO.calculateCartTotal(userId);
        double deliveryFee = (subtotal >= 499.0) ? 0.0 : 40.0;
        double handlingFee = 5.0;
        double grandTotal = subtotal + deliveryFee + handlingFee;

        // Generate clean human-readable order ID
        String orderId = "ORD-" + (int)(100000 + Math.random() * 900000);

        Order order = new Order();
        order.setId(orderId);
        order.setUserId(userId);
        order.setTotalAmount(grandTotal);
        order.setAddress(address.trim());
        order.setCity(city.trim());
        order.setState(state != null ? state.trim() : "Maharashtra");
        order.setPincode(pincode.trim());
        order.setMobile(mobile.trim());
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "Cash on Delivery");
        order.setStatus("Confirmed");

        // Atomic JDBC Transaction
        boolean isCreated = orderDAO.createOrder(order, cartItems);

        if (isCreated) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("cartCount", 0);
                session.setAttribute("cartTotal", 0.0);
            }
            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + orderId);
        } else {
            request.setAttribute("errorMessage", "Could not complete order. One or more items might be out of stock.");
            request.getRequestDispatcher("/checkout").forward(request, response);
        }
    }

    private void handleOrderHistory(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/orders.jsp").forward(request, response);
    }

    private void handleOrderDetails(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Order order = orderDAO.getOrderById(orderId.trim());
        if (order != null && order.getUserId() == userId) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-details.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void handleOrderConfirmation(HttpServletRequest request, HttpServletResponse response, int userId) 
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Order order = orderDAO.getOrderById(orderId.trim());
        if (order != null && order.getUserId() == userId) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-success.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
