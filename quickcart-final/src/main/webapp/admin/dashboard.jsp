<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.OrderDAO" %>
<%@ page import="com.quickcart.dao.ProductDAO" %>
<%@ page import="com.quickcart.dao.UserDAO" %>
<%@ page import="com.quickcart.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    OrderDAO orderDAO = new OrderDAO();
    ProductDAO productDAO = new ProductDAO();
    UserDAO userDAO = new UserDAO();

    double totalRevenue = orderDAO.getTotalSalesAmount();
    int totalOrders = orderDAO.getTotalOrdersCount();
    int totalProducts = productDAO.getTotalProductsCount();
    int totalUsers = userDAO.getTotalUsersCount();

    List<Order> recentOrders = orderDAO.getAllOrders();
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - QuickCart Console</title>
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
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin: 24px 0 32px;
        }
        .kpi-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }
        .kpi-title {
            font-size: 12px;
            font-weight: 800;
            text-transform: uppercase;
            color: #64748b;
            margin-bottom: 8px;
        }
        .kpi-val {
            font-size: 28px;
            font-weight: 900;
            color: #0f172a;
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
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="active">📊 Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/products.jsp">📦 Products</a>
            <a href="<%= request.getContextPath() %>/admin/orders.jsp">🛒 Orders</a>
            <a href="<%= request.getContextPath() %>/admin/users.jsp">👥 Customers</a>
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">🌐 View Store</a>
            <a href="<%= request.getContextPath() %>/logout" style="color: #fca5a5;">🚪 Logout</a>
        </div>
    </div>

    <main class="page-container">

        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 style="font-size: 24px; font-weight: 900; color: #0f172a;">Store Performance Overview</h1>
                <p style="font-size: 13px; color: #64748b; margin-top: 2px;">Powai Hyperlocal Hub Operations • Live Metrics</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin/add-product.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 10px 18px;">
                + Add New Product
            </a>
        </div>

        <!-- 4 KPI Performance Cards -->
        <div class="kpi-grid">
            <div class="kpi-card" style="border-left: 4px solid var(--primary);">
                <div class="kpi-title">Total Revenue / Sales</div>
                <div class="kpi-val" style="color: var(--primary);">₹<%= String.format("%.2f", totalRevenue) %></div>
                <div style="font-size: 11px; color: #10b981; font-weight: 700; margin-top: 4px;">↑ From delivered orders</div>
            </div>

            <div class="kpi-card" style="border-left: 4px solid #10b981;">
                <div class="kpi-title">Total Orders Placed</div>
                <div class="kpi-val" style="color: #10b981;"><%= totalOrders %></div>
                <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Express deliveries dispatched</div>
            </div>

            <div class="kpi-card" style="border-left: 4px solid #f59e0b;">
                <div class="kpi-title">Active Catalog Items</div>
                <div class="kpi-val" style="color: #f59e0b;"><%= totalProducts %></div>
                <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Across 8 core categories</div>
            </div>

            <div class="kpi-card" style="border-left: 4px solid #3b82f6;">
                <div class="kpi-title">Registered Customers</div>
                <div class="kpi-val" style="color: #3b82f6;"><%= totalUsers %></div>
                <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Active user accounts</div>
            </div>
        </div>

        <!-- Recent Customer Orders Table -->
        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-xl); padding: 24px; box-shadow: var(--shadow-sm);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <h2 style="font-size: 17px; font-weight: 900; color: #0f172a;">Recent Orders</h2>
                <a href="<%= request.getContextPath() %>/admin/orders.jsp" class="view-all-link">Manage All Orders →</a>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Date & Time</th>
                        <th>Total Amount</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                        <% for (int i = 0; i < Math.min(6, recentOrders.size()); i++) { 
                            Order ord = recentOrders.get(i);
                        %>
                            <tr>
                                <td style="font-weight: 900; color: var(--primary);"><%= ord.getId() %></td>
                                <td>
                                    <div style="font-weight: 700;"><%= ord.getCustomerName() != null ? ord.getCustomerName() : "Customer #" + ord.getUserId() %></div>
                                    <div style="font-size: 11px; color: #64748b;"><%= ord.getCustomerEmail() != null ? ord.getCustomerEmail() : "" %></div>
                                </td>
                                <td><%= ord.getOrderDate() != null ? sdf.format(ord.getOrderDate()) : "Recent" %></td>
                                <td style="font-weight: 800;">₹<%= String.format("%.2f", ord.getTotalAmount()) %></td>
                                <td><%= ord.getPaymentMethod() %></td>
                                <td>
                                    <span class="order-status-pill status-<%= ord.getStatus() %>">
                                        ● <%= ord.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/orders.jsp" class="btn-action" style="padding: 4px 8px; font-size: 11px;">
                                        Update
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #94a3b8; padding: 20px;">No orders found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
