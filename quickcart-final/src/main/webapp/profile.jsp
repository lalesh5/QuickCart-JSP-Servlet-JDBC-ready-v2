<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .profile-container {
            max-width: 600px;
            margin: 30px auto;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 32px;
            box-shadow: var(--shadow-sm);
        }
        .profile-avatar-large {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--primary);
            color: #ffffff;
            font-size: 28px;
            font-weight: 900;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
        }
        .profile-info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
        }
        .profile-info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #64748b;
            font-weight: 700;
        }
        .info-val {
            font-weight: 800;
            color: #0f172a;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <div class="breadcrumb" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
            <span>My Account</span>
        </div>

        <div class="profile-container">
            <div class="profile-avatar-large">
                <%= user.getName().substring(0, 1).toUpperCase() %>
            </div>

            <h2 style="font-size: 22px; font-weight: 900; text-align: center; margin-bottom: 4px;">
                <%= user.getName() %>
            </h2>
            <div style="text-align: center; margin-bottom: 24px;">
                <span style="background: var(--primary-light); color: var(--primary); font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 9999px;">
                    <%= user.getRole() %> ACCOUNT
                </span>
            </div>

            <div class="profile-info-row">
                <span class="info-label">Full Name</span>
                <span class="info-val"><%= user.getName() %></span>
            </div>

            <div class="profile-info-row">
                <span class="info-label">Email Address</span>
                <span class="info-val"><%= user.getEmail() %></span>
            </div>

            <div class="profile-info-row">
                <span class="info-label">Mobile Number</span>
                <span class="info-val"><%= user.getMobile() %></span>
            </div>

            <div class="profile-info-row">
                <span class="info-label">Default Express Hub</span>
                <span class="info-val">Powai Central Dark Store (400076)</span>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 24px;">
                <a href="<%= request.getContextPath() %>/orders" class="btn-action" style="justify-content: center; padding: 12px;">
                    📦 View My Orders
                </a>
                <a href="<%= request.getContextPath() %>/cart.jsp" class="btn-action" style="justify-content: center; padding: 12px;">
                    🛒 View Cart
                </a>
            </div>

            <% if ("ADMIN".equalsIgnoreCase(user.getRole())) { %>
                <div style="margin-top: 16px;">
                    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn-primary" style="display: block; text-align: center; padding: 12px; background: #b45309;">
                        🛡️ Open Store Admin Dashboard
                    </a>
                </div>
            <% } %>

            <div style="margin-top: 16px; text-align: center;">
                <a href="<%= request.getContextPath() %>/logout" style="color: #ef4444; font-size: 13px; font-weight: 800;">
                    Sign Out of Account
                </a>
            </div>
        </div>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
