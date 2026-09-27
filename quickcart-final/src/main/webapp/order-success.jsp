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
    <title>Order Placed Successfully! - QuickCart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .success-box {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 36px 28px;
            max-width: 680px;
            margin: 20px auto 40px;
            text-align: center;
            box-shadow: var(--shadow-md);
        }
        .check-badge {
            width: 68px;
            height: 68px;
            background: #ecfdf5;
            color: #059669;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            margin: 0 auto 16px;
            border: 2px solid #a7f3d0;
        }
        .countdown-card {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%);
            color: #ffffff;
            border-radius: var(--radius-lg);
            padding: 20px;
            margin: 24px 0;
            display: flex;
            align-items: center;
            justify-content: space-around;
        }
        .order-meta-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            text-align: left;
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 18px;
            margin: 20px 0;
            font-size: 13px;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">
        <div class="success-box">
            <div class="check-badge">✓</div>
            <span style="background: #ecfdf5; color: #065f46; font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 9999px;">
                ORDER CONFIRMED & DISPATCHED
            </span>
            <h1 style="font-size: 26px; font-weight: 900; margin: 12px 0 6px; color: var(--text-primary);">
                Thank You for Ordering!
            </h1>
            <p style="color: var(--text-secondary); font-size: 14px;">
                Your order ID is <strong style="color: var(--primary);"><%= order.getId() %></strong>. 
                Our local dark store has packed your package and assigned a fast electric rider.
            </p>

            <!-- 15-Minute Delivery Countdown Card -->
            <div class="countdown-card">
                <div style="font-size: 40px;">⚡</div>
                <div style="text-align: left;">
                    <div style="font-size: 20px; font-weight: 900;">Estimated Arrival: 12-15 Mins</div>
                    <div style="font-size: 12px; color: #ecfdf5;">Rider: Ramesh Kumar (Electric Bike • MH-03-EB-4192)</div>
                </div>
            </div>

            <div class="order-meta-grid">
                <div>
                    <span style="font-size: 11px; font-weight: 800; text-transform: uppercase; color: #64748b; display: block;">Delivery Address</span>
                    <strong><%= order.getAddress() %></strong><br>
                    <%= order.getCity() %>, <%= order.getState() %> - <%= order.getPincode() %><br>
                    📞 Phone: <%= order.getMobile() %>
                </div>
                <div>
                    <span style="font-size: 11px; font-weight: 800; text-transform: uppercase; color: #64748b; display: block;">Payment & Bill</span>
                    <strong>Method:</strong> <%= order.getPaymentMethod() %><br>
                    <strong>Total Amount:</strong> ₹<%= String.format("%.2f", order.getTotalAmount()) %><br>
                    <strong>Status:</strong> <span style="color: #059669; font-weight: 800;"><%= order.getStatus() %></span>
                </div>
            </div>

            <!-- Ordered Items List -->
            <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
                <div style="text-align: left; margin: 20px 0;">
                    <h3 style="font-size: 14px; font-weight: 800; color: #475569; text-transform: uppercase; margin-bottom: 10px;">Ordered Items</h3>
                    <div style="border: 1px solid var(--border-color); border-radius: var(--radius-md); overflow: hidden;">
                        <% for (OrderItem item : order.getItems()) { %>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; border-bottom: 1px solid #f1f5f9; background: #ffffff;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span style="font-size: 13px; font-weight: 700;"><%= item.getProductName() %></span>
                                    <span style="font-size: 11px; color: #64748b;">(Qty: <%= item.getQuantity() %>)</span>
                                </div>
                                <span style="font-size: 13px; font-weight: 800;">₹<%= String.format("%.2f", item.getSubtotal()) %></span>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <div style="display: flex; gap: 12px; justify-content: center; margin-top: 24px;">
                <a href="<%= request.getContextPath() %>/orders" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 24px;">
                    📦 Track in My Orders
                </a>
                <a href="<%= request.getContextPath() %>/products" class="btn-action" style="padding: 12px 24px;">
                    🛍️ Continue Shopping
                </a>
            </div>
        </div>
    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
