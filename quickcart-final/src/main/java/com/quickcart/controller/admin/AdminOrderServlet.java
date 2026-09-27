package com.quickcart.controller.admin;

import com.quickcart.dao.OrderDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Admin controller for Order operations:
 * - Update order status (Pending -> Confirmed -> Shipped -> Delivered -> Cancelled)
 */
@WebServlet("/admin/order-action")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        if ("updateStatus".equals(action) && orderId != null && status != null) {
            orderDAO.updateOrderStatus(orderId.trim(), status.trim());
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/orders.jsp");
    }
}
