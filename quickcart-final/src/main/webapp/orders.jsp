<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.Order" %>
<%@ page import="com.quickcart.model.OrderItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .order-history-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
        }
        .order-history-card:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--primary-border);
        }
        .order-header-strip {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 14px;
            margin-bottom: 16px;
        }
        .order-status-pill {
            padding: 4px 12px;
            border-radius: 9999px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
        }
        .status-Pending { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; }
        .status-Confirmed { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .status-Shipped { background: #f5f3ff; color: #6d28d9; border: 1px solid #ddd6fe; }
        .status-Delivered { background: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; }
        .status-Cancelled { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }

        .order-items-preview {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-bottom: 16px;
        }
        .item-preview-line {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
        }
        .item-preview-thumb {
            width: 44px;
            height: 44px;
            object-fit: contain;
            background: #f8fafc;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            padding: 4px;
        }
        .order-footer-strip {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #f1f5f9;
            padding-top: 14px;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <div class="breadcrumb" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
            <span>My Orders</span>
        </div>

        <h1 style="font-size: 24px; font-weight: 900; margin-bottom: 24px;">
            📦 Order History & Live Tracking
        </h1>

        <% if (orders != null && !orders.isEmpty()) { %>
            <div>
                <% for (Order o : orders) { %>
                    <div class="order-history-card">
                        <div class="order-header-strip">
                            <div>
                                <span style="font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: 700;">ORDER PLACED</span>
                                <div style="font-size: 13px; font-weight: 700; color: #0f172a;">
                                    <%= o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "Recent" %>
                                </div>
                            </div>
                            <div>
                                <span style="font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: 700;">ORDER ID</span>
                                <div style="font-size: 14px; font-weight: 900; color: var(--primary);">
                                    <%= o.getId() %>
                                </div>
                            </div>
                            <div>
                                <span class="order-status-pill status-<%= o.getStatus() %>">
                                    ● <%= o.getStatus() %>
                                </span>
                            </div>
                        </div>

                        <!-- Items in this Order -->
                        <div class="order-items-preview">
                            <% if (o.getItems() != null) { %>
                                <% for (OrderItem item : o.getItems()) { %>
                                    <div class="item-preview-line">
                                        <img 
                                            src="<%= request.getContextPath() %>/<%= item.getProductImage() %>" 
                                            alt="<%= item.getProductName() %>" 
                                            class="item-preview-thumb"
                                            onerror="this.src='https://placehold.co/80x80/f8fafc/64748b?text=Item';"
                                        >
                                        <div style="flex: 1;">
                                            <div style="font-weight: 700;"><%= item.getProductName() %></div>
                                            <div style="font-size: 11px; color: #64748b;">Qty: <%= item.getQuantity() %> • ₹<%= String.format("%.2f", item.getPrice()) %> each</div>
                                        </div>
                                        <div style="font-weight: 800; font-size: 13px;">
                                            ₹<%= String.format("%.2f", item.getSubtotal()) %>
                                        </div>
                                    </div>
                                <% } %>
                            <% } %>
                        </div>

                        <div class="order-footer-strip">
                            <div>
                                <span style="font-size: 12px; color: #64748b;">Total Amount:</span>
                                <strong style="font-size: 16px; color: var(--text-primary); margin-left: 6px;">
                                    ₹<%= String.format("%.2f", o.getTotalAmount()) %>
                                </strong>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <a href="<%= request.getContextPath() %>/order-details?orderId=<%= o.getId() %>" class="btn-action" style="font-size: 12px; padding: 6px 12px;">
                                    🔍 View Invoice & Track
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state-card">
                <div style="font-size: 56px; margin-bottom: 14px;">📦</div>
                <h2>No Orders Yet</h2>
                <p style="color: var(--text-secondary); margin: 8px 0 20px;">
                    You have not placed any orders yet. Try QuickCart's 15-minute express delivery today!
                </p>
                <a href="<%= request.getContextPath() %>/products" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 28px;">
                    Start Shopping
                </a>
            </div>
        <% } %>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
