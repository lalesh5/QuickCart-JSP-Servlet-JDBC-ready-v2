<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.Order" %>
<%@ page import="com.quickcart.model.OrderItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order #<%= order.getId() %> - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .tracker-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .progress-track {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            margin: 30px 10px 10px;
        }
        .progress-track::before {
            content: '';
            position: absolute;
            top: 14px;
            left: 20px;
            right: 20px;
            height: 4px;
            background: #e2e8f0;
            z-index: 1;
        }
        .track-step {
            position: relative;
            z-index: 2;
            text-align: center;
        }
        .step-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #ffffff;
            border: 3px solid #cbd5e1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
            margin: 0 auto 8px;
            color: #64748b;
        }
        .track-step.done .step-circle {
            background: #10b981;
            border-color: #10b981;
            color: #ffffff;
        }
        .track-step.active .step-circle {
            background: var(--primary);
            border-color: var(--primary);
            color: #ffffff;
            box-shadow: 0 0 0 4px rgba(124, 58, 237, 0.2);
        }
        .track-label {
            font-size: 12px;
            font-weight: 700;
            color: #475569;
        }
        .detail-meta-box {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <div class="breadcrumb" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
            <a href="<%= request.getContextPath() %>/orders">My Orders</a> &gt; 
            <span><%= order.getId() %></span>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <div>
                <h1 style="font-size: 24px; font-weight: 900; color: #0f172a;">Order #<%= order.getId() %></h1>
                <p style="font-size: 13px; color: #64748b; margin-top: 4px;">
                    Placed on <%= order.getOrderDate() != null ? sdf.format(order.getOrderDate()) : "Recent" %>
                </p>
            </div>
            <a href="javascript:window.print();" class="btn-action" style="font-size: 12px;">
                🖨️ Print Invoice
            </a>
        </div>

        <!-- 4-Stage Express Delivery Tracker -->
        <div class="tracker-card">
            <h3 style="font-size: 15px; font-weight: 900; margin-bottom: 8px;">Order & Dispatch Status: <span style="color: var(--primary);"><%= order.getStatus() %></span></h3>
            
            <div class="progress-track">
                <div class="track-step done">
                    <div class="step-circle">✓</div>
                    <span class="track-label">Order Placed</span>
                </div>
                <div class="track-step <%= !"Pending".equals(order.getStatus()) ? "done" : "active" %>">
                    <div class="step-circle"><%= !"Pending".equals(order.getStatus()) ? "✓" : "2" %></div>
                    <span class="track-label">Packing at Hub</span>
                </div>
                <div class="track-step <%= "Shipped".equals(order.getStatus()) || "Delivered".equals(order.getStatus()) ? "done" : ("Confirmed".equals(order.getStatus()) ? "active" : "") %>">
                    <div class="step-circle"><%= "Shipped".equals(order.getStatus()) || "Delivered".equals(order.getStatus()) ? "✓" : "3" %></div>
                    <span class="track-label">Rider Out</span>
                </div>
                <div class="track-step <%= "Delivered".equals(order.getStatus()) ? "done" : "" %>">
                    <div class="step-circle"><%= "Delivered".equals(order.getStatus()) ? "✓" : "4" %></div>
                    <span class="track-label">Delivered</span>
                </div>
            </div>
        </div>

        <!-- Address and Payment Meta -->
        <div class="detail-meta-box">
            <div class="tracker-card" style="margin-bottom: 0;">
                <h4 style="font-size: 13px; font-weight: 800; text-transform: uppercase; color: #64748b; margin-bottom: 12px;">📍 Delivery Location</h4>
                <div style="font-size: 14px; font-weight: 700; color: #0f172a;"><%= order.getAddress() %></div>
                <div style="font-size: 13px; color: #475569; margin-top: 2px;"><%= order.getCity() %>, <%= order.getState() %> - <%= order.getPincode() %></div>
                <div style="font-size: 13px; color: #475569; margin-top: 6px;">📞 Contact: <strong><%= order.getMobile() %></strong></div>
            </div>

            <div class="tracker-card" style="margin-bottom: 0;">
                <h4 style="font-size: 13px; font-weight: 800; text-transform: uppercase; color: #64748b; margin-bottom: 12px;">💳 Payment Summary</h4>
                <div style="font-size: 13px; margin-bottom: 6px;">Payment Method: <strong><%= order.getPaymentMethod() %></strong></div>
                <div style="font-size: 13px; margin-bottom: 6px;">Delivery Partner: <strong>QuickCart Electric Express (Powai Hub)</strong></div>
                <div style="font-size: 16px; font-weight: 900; margin-top: 10px; color: var(--primary);">
                    Total Paid: ₹<%= String.format("%.2f", order.getTotalAmount()) %>
                </div>
            </div>
        </div>

        <!-- Items Table -->
        <div class="tracker-card" style="margin-top: 24px;">
            <h3 style="font-size: 16px; font-weight: 900; margin-bottom: 16px;">Items in this Shipment</h3>
            <table class="items-table" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="border-bottom: 1px solid var(--border-color); text-align: left;">
                        <th style="padding: 10px;">Item</th>
                        <th style="text-align: center; padding: 10px;">Quantity</th>
                        <th style="text-align: right; padding: 10px;">Price</th>
                        <th style="text-align: right; padding: 10px;">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (order.getItems() != null) { %>
                        <% for (OrderItem it : order.getItems()) { %>
                            <tr style="border-bottom: 1px solid #f1f5f9;">
                                <td style="padding: 12px 10px; display: flex; align-items: center; gap: 12px;">
                                    <img 
                                        src="<%= request.getContextPath() %>/<%= it.getProductImage() %>" 
                                        alt="<%= it.getProductName() %>" 
                                        style="width: 44px; height: 44px; object-fit: contain; border-radius: 6px; border: 1px solid var(--border-color);"
                                        onerror="this.src='https://placehold.co/80x80/f8fafc/64748b?text=Item';"
                                    >
                                    <span style="font-weight: 700;"><%= it.getProductName() %></span>
                                </td>
                                <td style="text-align: center; padding: 10px;"><%= it.getQuantity() %></td>
                                <td style="text-align: right; padding: 10px;">₹<%= String.format("%.2f", it.getPrice()) %></td>
                                <td style="text-align: right; padding: 10px; font-weight: 800;">₹<%= String.format("%.2f", it.getSubtotal()) %></td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
