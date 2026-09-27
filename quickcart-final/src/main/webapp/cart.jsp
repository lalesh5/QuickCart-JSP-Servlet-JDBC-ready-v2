<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.CartItem" %>
<%@ page import="com.quickcart.dao.CartDAO" %>
<%@ page import="java.util.List" %>
<%
    Integer uid = (Integer) session.getAttribute("userId");
    if (uid == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
        return;
    }

    CartDAO cartDAO = new CartDAO();
    List<CartItem> cartItems = cartDAO.getCartByUserId(uid);
    double subtotal = cartDAO.calculateCartTotal(uid);
    double deliveryFee = (subtotal >= 499.0 || subtotal == 0) ? 0.0 : 40.0;
    double handlingFee = (subtotal > 0) ? 5.0 : 0.0;
    double grandTotal = (subtotal > 0) ? (subtotal + deliveryFee + handlingFee) : 0.0;
    double amountForFreeDelivery = Math.max(0, 499.0 - subtotal);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .cart-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            align-items: start;
        }
        .cart-table-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-sm);
        }
        .cart-item-row {
            display: grid;
            grid-template-columns: 80px 1fr auto auto;
            gap: 16px;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .cart-item-row:last-child {
            border-bottom: none;
        }
        .cart-item-img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            background: #f8fafc;
            border-radius: var(--radius-md);
            padding: 6px;
            border: 1px solid var(--border-color);
        }
        .cart-qty-ctrl {
            display: inline-flex;
            align-items: center;
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-md);
            background: #f8fafc;
            overflow: hidden;
        }
        .btn-qty {
            background: transparent;
            border: none;
            width: 32px;
            height: 32px;
            font-size: 16px;
            font-weight: 900;
            cursor: pointer;
            color: var(--text-primary);
        }
        .btn-qty:hover {
            background: var(--primary-light);
            color: var(--primary);
        }
        .qty-val {
            width: 32px;
            text-align: center;
            font-weight: 800;
            font-size: 13px;
        }
        .summary-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 90px;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: var(--text-secondary);
            margin-bottom: 12px;
        }
        .summary-row.total {
            font-size: 18px;
            font-weight: 900;
            color: var(--text-primary);
            border-top: 1px dashed var(--border-color);
            padding-top: 14px;
            margin-top: 14px;
        }
        .free-delivery-box {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #065f46;
            padding: 10px 14px;
            border-radius: var(--radius-md);
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        @media (max-width: 850px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
            .cart-item-row {
                grid-template-columns: 70px 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <div class="breadcrumb" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
            <span>Shopping Cart</span>
        </div>

        <h1 style="font-size: 24px; font-weight: 900; margin-bottom: 24px;">
            Your Shopping Cart (<%= cartItems.size() %> items)
        </h1>

        <% if (cartItems != null && !cartItems.isEmpty()) { %>
            <div class="cart-layout">
                
                <!-- Left: List of Cart Items -->
                <div class="cart-table-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; padding-bottom: 12px; border-bottom: 1px solid var(--border-color);">
                        <span style="font-size: 12px; font-weight: 800; text-transform: uppercase; color: var(--text-secondary);">Dark Store Items (Powai)</span>
                        <form action="<%= request.getContextPath() %>/cart" method="post" style="margin: 0;">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" style="background: none; border: none; color: #ef4444; font-size: 12px; font-weight: 800; cursor: pointer;">
                                🗑️ Clear Entire Cart
                            </button>
                        </form>
                    </div>

                    <% for (CartItem item : cartItems) { %>
                        <div class="cart-item-row">
                            <img 
                                src="<%= request.getContextPath() %>/<%= item.getProductImage() %>" 
                                alt="<%= item.getProductName() %>" 
                                class="cart-item-img"
                                onerror="this.src='https://placehold.co/100x100/f8fafc/64748b?text=Item';"
                            >
                            <div>
                                <span style="font-size: 10px; font-weight: 800; text-transform: uppercase; color: var(--primary);">
                                    <%= item.getProductCategory() %>
                                </span>
                                <h3 style="font-size: 14px; font-weight: 800; color: var(--text-primary); margin: 2px 0 4px;">
                                    <%= item.getProductName() %>
                                </h3>
                                <div style="font-size: 13px; font-weight: 800; color: #0f172a;">
                                    ₹<%= String.format("%.2f", item.getEffectiveUnitPrice()) %> each
                                    <% if (item.getProductDiscount() > 0) { %>
                                        <span style="font-size: 11px; color: var(--text-muted); text-decoration: line-through;">
                                            ₹<%= String.format("%.2f", item.getProductPrice()) %>
                                        </span>
                                    <% } %>
                                </div>
                            </div>

                            <!-- Quantity Increment / Decrement -->
                            <div class="cart-qty-ctrl">
                                <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="cartId" value="<%= item.getId() %>">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                    <button type="submit" class="btn-qty">−</button>
                                </form>
                                <span class="qty-val"><%= item.getQuantity() %></span>
                                <form action="<%= request.getContextPath() %>/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="cartId" value="<%= item.getId() %>">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                    <button type="submit" class="btn-qty" <%= item.getQuantity() >= item.getProductStock() ? "disabled" : "" %>>+</button>
                                </form>
                            </div>

                            <!-- Line Subtotal & Remove -->
                            <div style="text-align: right;">
                                <div style="font-size: 15px; font-weight: 900; color: var(--text-primary);">
                                    ₹<%= String.format("%.2f", item.getTotalPrice()) %>
                                </div>
                                <form action="<%= request.getContextPath() %>/cart" method="post" style="margin-top: 6px;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartId" value="<%= item.getId() %>">
                                    <button type="submit" style="background: none; border: none; color: #94a3b8; font-size: 11px; font-weight: 700; cursor: pointer;" title="Remove Item">
                                        ✕ Remove
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } %>

                    <div style="margin-top: 20px; padding-top: 14px; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between;">
                        <a href="<%= request.getContextPath() %>/products" class="btn-action">
                            ← Continue Shopping
                        </a>
                    </div>
                </div>

                <!-- Right: Order Bill Summary & Checkout -->
                <div class="summary-card">
                    <h2 style="font-size: 16px; font-weight: 900; margin-bottom: 16px;">Bill Details</h2>

                    <% if (amountForFreeDelivery > 0) { %>
                        <div class="free-delivery-box">
                            <span>⚡</span>
                            <span>Add <strong>₹<%= String.format("%.2f", amountForFreeDelivery) %></strong> more for <strong>FREE Delivery</strong>!</span>
                        </div>
                    <% } else { %>
                        <div class="free-delivery-box">
                            <span>🎉</span>
                            <span>Congratulations! You unlocked <strong>FREE 15-Min Delivery</strong></span>
                        </div>
                    <% } %>

                    <div class="summary-row">
                        <span>Items Subtotal</span>
                        <span>₹<%= String.format("%.2f", subtotal) %></span>
                    </div>

                    <div class="summary-row">
                        <span>15-Min Express Delivery</span>
                        <span>
                            <% if (deliveryFee == 0.0) { %>
                                <strong style="color: #059669;">FREE</strong>
                            <% } else { %>
                                ₹<%= String.format("%.2f", deliveryFee) %>
                            <% } %>
                        </span>
                    </div>

                    <div class="summary-row">
                        <span>Handling & Dark Store Fee</span>
                        <span>₹<%= String.format("%.2f", handlingFee) %></span>
                    </div>

                    <div class="summary-row total">
                        <span>To Pay</span>
                        <span style="color: var(--primary);">₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>

                    <div style="margin-top: 24px;">
                        <a href="<%= request.getContextPath() %>/checkout" class="btn-primary" style="display: block; text-align: center; padding: 14px; text-decoration: none; font-size: 15px;">
                            ⚡ Proceed to Checkout (₹<%= String.format("%.2f", grandTotal) %>)
                        </a>
                    </div>

                    <div style="margin-top: 16px; font-size: 11px; color: #64748b; text-align: center;">
                        🔒 256-bit Secure Checkout • UPI, Cards & Cash on Delivery
                    </div>
                </div>

            </div>
        <% } else { %>
            <!-- Empty Cart State -->
            <div class="empty-state-card">
                <div style="font-size: 56px; margin-bottom: 14px;">🛒</div>
                <h2>Your Shopping Cart is Empty</h2>
                <p style="color: var(--text-secondary); margin: 8px 0 20px;">
                    Looks like you haven't added anything to your cart yet. Explore thousands of items delivered in 15 minutes!
                </p>
                <a href="<%= request.getContextPath() %>/products" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 28px;">
                    Start Shopping Now
                </a>
            </div>
        <% } %>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
