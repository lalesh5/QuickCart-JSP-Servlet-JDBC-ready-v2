<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.UserDAO" %>
<%@ page import="com.quickcart.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Directory - QuickCart Admin</title>
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
            <a href="<%= request.getContextPath() %>/admin/orders.jsp">🛒 Orders</a>
            <a href="<%= request.getContextPath() %>/admin/users.jsp" class="active">👥 Customers</a>
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">🌐 View Store</a>
            <a href="<%= request.getContextPath() %>/logout" style="color: #fca5a5;">🚪 Logout</a>
        </div>
    </div>

    <main class="page-container">

        <div style="margin-bottom: 24px;">
            <h1 style="font-size: 24px; font-weight: 900; color: #0f172a;">Registered Users & Customers</h1>
            <p style="font-size: 13px; color: #64748b; margin-top: 2px;">Directory of QuickCart customer accounts and staff</p>
        </div>

        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-xl); padding: 24px; box-shadow: var(--shadow-sm);">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email Address</th>
                        <th>Mobile Number</th>
                        <th>System Role</th>
                        <th>Joined Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users != null && !users.isEmpty()) { %>
                        <% for (User u : users) { %>
                            <tr>
                                <td style="font-weight: 800;">#<%= u.getId() %></td>
                                <td style="font-weight: 700; color: #0f172a;"><%= u.getName() %></td>
                                <td><%= u.getEmail() %></td>
                                <td><%= u.getMobile() %></td>
                                <td>
                                    <span style="padding: 2px 8px; border-radius: 9999px; font-size: 10px; font-weight: 800; background: <%= "ADMIN".equalsIgnoreCase(u.getRole()) ? "#fef3c7; color: #b45309;" : "#ecfdf5; color: #059669;" %>">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td>
                                    <%= u.getCreatedAt() != null ? sdf.format(u.getCreatedAt()) : "Recent" %>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="6" style="text-align: center; color: #94a3b8; padding: 24px;">No users found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
