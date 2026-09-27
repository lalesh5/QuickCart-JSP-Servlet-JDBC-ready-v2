<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.Order" %>
<%@ page import="com.quickcart.model.OrderItem" %>
<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Placed Successfully! - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .confirm-wrapper {
            max-width: 680px;
            margin: 40px auto;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 36px 30px;
            box-shadow: var(--shadow-lg);
            text-align: center;
        }
        .success-badge {
            width: 70px;
            height: 70px;
            background: #ecfdf5;
            color: #059669;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            margin: 0 auto 16px;
            border: 2px solid #a7f3d0;
        }
        .eta-box {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: #ffffff;
            border-radius: var(--radius-lg);
            padding: 18px 24px;
            margin: 24px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .order-meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            text-align: left;
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-lg);
            padding: 18px;
            margin-bottom: 24px;
            font-size: 13px;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 13px;
            margin-bottom: 24px;
        }
        .items-table th, .items-table td {
            padding: 10px 12px;
            border-bottom: 1px solid var(--border-color);
        }
        .items-table th {
            font-weight: 800;
            color: var(--text-secondary);
            background: #f8fafc;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">
        <div class="confirm-wrapper">
            <div class="success-badge">✅</div>
            <h1 style="font-size: 26px; font-weight: 900; color: #0f172a;">Order Placed Successfully!</h1>
            <p style="font-size: 14px; color: #475569; margin-top: 6px;">
                Thank you for ordering with QuickCart. Your order <strong><%= order.getId() %></strong> is confirmed.
            </p>

            <!-- 15-Minute Guaranteed Delivery ETA Card -->
            <div class="eta-box">
                <div style="text-align: left;">
                    <div style="font-size: 11px; text-transform: uppercase; font-weight: 800; opacity: 0.9;">Estimated Arrival</div>
                    <div style="font-size: 24px; font-weight: 900;">12 - 15 Minutes</div>
                    <div style="font-size: 12px; opacity: 0.95;">⚡ Electric rider assigned at Powai Dark Store</div>
                </div>
                <div style="font-size: 42px;">🛵</div>
            </div>

            <!-- Order Details Grid -->
            <div class="order-meta-grid">
                <div>
                    <span style="color: #64748b; font-weight: 700;">Order ID:</span><br>
                    <strong><%= order.getId() %></strong>
                </div>
                <div>
                    <span style="color: #64748b; font-weight: 700;">Payment Method:</span><br>
                    <strong><%= order.getPaymentMethod() %></strong>
                </div>
                <div>
                    <span style="color: #64748b; font-weight: 700;">Delivery Address:</span><br>
                    <span><%= order.getAddress() %>, <%= order.getCity() %> (<%= order.getPincode() %>)</span>
                </div>
                <div>
                    <span style="color: #64748b; font-weight: 700;">Total Paid:</span><br>
                    <strong style="color: var(--primary); font-size: 16px;">₹<%= String.format("%.2f", order.getTotalAmount()) %></strong>
                </div>
            </div>

            <!-- Ordered Items Table -->
            <h3 style="font-size: 15px; font-weight: 800; text-align: left; margin-bottom: 12px;">Purchased Items</h3>
            <table class="items-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th style="text-align: center;">Qty</th>
                        <th style="text-align: right;">Price</th>
                        <th style="text-align: right;">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (order.getItems() != null) { %>
                        <% for (OrderItem item : order.getItems()) { %>
                            <tr>
                                <td style="font-weight: 700;"><%= item.getProductName() %></td>
                                <td style="text-align: center;"><%= item.getQuantity() %></td>
                                <td style="text-align: right;">₹<%= String.format("%.2f", item.getPrice()) %></td>
                                <td style="text-align: right; font-weight: 800;">₹<%= String.format("%.2f", item.getSubtotal()) %></td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>

            <div style="display: flex; gap: 12px; justify-content: center;">
                <a href="<%= request.getContextPath() %>/orders" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 24px;">
                    📦 View All My Orders
                </a>
                <a href="<%= request.getContextPath() %>/products" class="btn-action" style="padding: 12px 20px;">
                    🛍️ Continue Shopping
                </a>
            </div>

        </div>
    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
