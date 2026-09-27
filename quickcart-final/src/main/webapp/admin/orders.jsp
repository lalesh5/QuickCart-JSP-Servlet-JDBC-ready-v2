<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.OrderDAO" %>
<%@ page import="com.quickcart.model.Order" %>
<%@ page import="com.quickcart.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    OrderDAO orderDAO = new OrderDAO();
    List<Order> orders = orderDAO.getAllOrders();
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - QuickCart Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .admin-nav-bar {
            background: #1e293b;
            color: #ffffff;
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-nav-links {
            display: flex;
            gap: 16px;
            font-size: 13px;
            font-weight: 700;
        }
        .admin-nav-links a {
            color: #cbd5e1;
            padding: 6px 12px;
            border-radius: var(--radius-md);
        }
        .admin-nav-links a.active, .admin-nav-links a:hover {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .admin-table th, .admin-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }
        .admin-table th {
            background: #f8fafc;
            color: #475569;
            font-weight: 800;
            font-size: 11px;
            text-transform: uppercase;
        }
        .status-select {
            padding: 6px 10px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            outline: none;
            background: #ffffff;
        }
    </style>
</head>
<body style="background: #f1f5f9;">

    <!-- Top Admin Bar -->
    <div class="admin-nav-bar">
        <div style="display: flex; align-items: center; gap: 12px;">
            <div class="bolt" style="width: 28px; height: 28px; font-size: 14px; border-radius: 6px; background: var(--primary); color: #10b981; display:flex; align-items:center; justify-content:center;">⚡</div>
            <strong style="font-size: 15px; letter-spacing: -0.5px;">QUICKCART ADMIN CONSOLE</strong>
        </div>
        <div class="admin-nav-links">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">📊 Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/products.jsp">📦 Products</a>
            <a href="<%= request.getContextPath() %>/admin/orders.jsp" class="active">🛒 Orders</a>
            <a href="<%= request.getContextPath() %>/admin/users.jsp">👥 Customers</a>
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">🌐 View Store</a>
            <a href="<%= request.getContextPath() %>/logout" style="color: #fca5a5;">🚪 Logout</a>
        </div>
    </div>

    <main class="page-container">

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 24px; font-weight: 900; color: #0f172a;">Customer Orders & Dispatching</h1>
            <p style="font-size: 13px; color: #64748b; margin-top: 2px;">Update fulfillment status for delivery riders and customers</p>
        </div>

        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-xl); padding: 24px; box-shadow: var(--shadow-sm);">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer & Contact</th>
                        <th>Delivery Destination</th>
                        <th>Items Count</th>
                        <th>Total Amount</th>
                        <th>Current Status</th>
                        <th>Change Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders != null && !orders.isEmpty()) { %>
                        <% for (Order o : orders) { %>
                            <tr>
                                <td>
                                    <strong style="color: var(--primary);"><%= o.getId() %></strong>
                                    <div style="font-size: 11px; color: #64748b;">
                                        <%= o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "" %>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-weight: 700;"><%= o.getCustomerName() != null ? o.getCustomerName() : "User #" + o.getUserId() %></div>
                                    <div style="font-size: 11px; color: #64748b;"><%= o.getCustomerEmail() != null ? o.getCustomerEmail() : "" %></div>
                                    <div style="font-size: 11px; color: #059669; font-weight: 700;">📞 <%= o.getMobile() %></div>
                                </td>
                                <td>
                                    <div style="font-size: 12px; max-width: 220px; line-height: 1.3;"><%= o.getAddress() %>, <%= o.getCity() %> (<%= o.getPincode() %>)</div>
                                </td>
                                <td style="font-weight: 700;">
                                    <%= o.getItems() != null ? o.getItems().size() : 0 %> items
                                </td>
                                <td style="font-weight: 800; font-size: 14px;">
                                    ₹<%= String.format("%.2f", o.getTotalAmount()) %>
                                    <div style="font-size: 10px; color: #64748b; font-weight: 600;"><%= o.getPaymentMethod() %></div>
                                </td>
                                <td>
                                    <span class="order-status-pill status-<%= o.getStatus() %>">
                                        ● <%= o.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/admin/order-action" method="post" style="display: flex; gap: 6px; align-items: center;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                        <select name="status" class="status-select">
                                            <option value="Pending" <%= "Pending".equals(o.getStatus()) ? "selected" : "" %>>Pending</option>
                                            <option value="Confirmed" <%= "Confirmed".equals(o.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                            <option value="Shipped" <%= "Shipped".equals(o.getStatus()) ? "selected" : "" %>>Shipped</option>
                                            <option value="Delivered" <%= "Delivered".equals(o.getStatus()) ? "selected" : "" %>>Delivered</option>
                                            <option value="Cancelled" <%= "Cancelled".equals(o.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn-action" style="padding: 4px 8px; font-size: 11px;">
                                            Update
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #94a3b8; padding: 24px;">No customer orders found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
