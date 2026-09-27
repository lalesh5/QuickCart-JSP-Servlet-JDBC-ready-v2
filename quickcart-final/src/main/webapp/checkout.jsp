<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.CartItem" %>
<%@ page import="com.quickcart.model.User" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double deliveryFee = (Double) request.getAttribute("deliveryFee");
    Double handlingFee = (Double) request.getAttribute("handlingFee");
    Double grandTotal = (Double) request.getAttribute("grandTotal");

    if (subtotal == null) subtotal = 0.0;
    if (deliveryFee == null) deliveryFee = 0.0;
    if (handlingFee == null) handlingFee = 5.0;
    if (grandTotal == null) grandTotal = subtotal + deliveryFee + handlingFee;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout - QuickCart Express</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .checkout-grid {
            display: grid;
            grid-template-columns: 2fr 1.2fr;
            gap: 24px;
            align-items: start;
        }
        .checkout-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
        }
        .section-step {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            font-weight: 900;
            color: var(--text-primary);
            margin-bottom: 16px;
        }
        .step-num {
            width: 28px;
            height: 28px;
            background: var(--primary);
            color: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
        }
        .slot-options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }
        .slot-card {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .slot-card.selected, .slot-card:hover {
            border-color: var(--success);
            background: var(--success-light);
        }
        .slot-card input {
            margin-right: 6px;
        }
        .payment-option-card {
            border: 1.5px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .payment-option-card:hover {
            border-color: var(--primary);
            background: var(--primary-light);
        }
        @media (max-width: 850px) {
            .checkout-grid {
                grid-template-columns: 1fr;
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
            <a href="<%= request.getContextPath() %>/cart.jsp">Cart</a> &gt; 
            <span>Checkout</span>
        </div>

        <h1 style="font-size: 24px; font-weight: 900; margin-bottom: 24px;">
            ⚡ QuickCart Express Checkout
        </h1>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <span>⚠️</span>
                <span><%= request.getAttribute("errorMessage") %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/place-order" method="post">
            <div class="checkout-grid">

                <!-- Left Column: Forms -->
                <div>
                    <!-- Step 1: Delivery Slot -->
                    <div class="checkout-card">
                        <div class="section-step">
                            <span class="step-num">1</span>
                            <span>Choose Delivery Speed</span>
                        </div>
                        <div class="slot-options-grid">
                            <label class="slot-card selected">
                                <input type="radio" name="deliverySlot" value="15-Min Express" checked>
                                <strong>⚡ 15-Min Express</strong>
                                <p style="font-size: 11px; color: var(--text-secondary); margin-top: 4px;">Delivered in ~15 mins from Powai Hub</p>
                            </label>
                            <label class="slot-card">
                                <input type="radio" name="deliverySlot" value="Evening (5-8 PM)">
                                <strong>🌆 Evening Slot</strong>
                                <p style="font-size: 11px; color: var(--text-secondary); margin-top: 4px;">Between 5:00 PM - 8:00 PM</p>
                            </label>
                            <label class="slot-card">
                                <input type="radio" name="deliverySlot" value="Tomorrow Morning">
                                <strong>🌅 Next Morning</strong>
                                <p style="font-size: 11px; color: var(--text-secondary); margin-top: 4px;">Between 7:00 AM - 10:00 AM</p>
                            </label>
                        </div>
                    </div>

                    <!-- Step 2: Delivery Address -->
                    <div class="checkout-card">
                        <div class="section-step">
                            <span class="step-num">2</span>
                            <span>Delivery Address</span>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="address">House / Flat No, Building & Street Address</label>
                            <input 
                                type="text" 
                                id="address" 
                                name="address" 
                                class="form-input" 
                                placeholder="e.g. Flat 402, Sunshine Heights, Hiranandani Gardens" 
                                required
                            >
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px;">
                            <div class="form-group">
                                <label class="form-label" for="city">City</label>
                                <input type="text" id="city" name="city" class="form-input" value="Mumbai" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="state">State</label>
                                <input type="text" id="state" name="state" class="form-input" value="Maharashtra" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="pincode">Pincode</label>
                                <input type="text" id="pincode" name="pincode" class="form-input" value="400076" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="mobile">Rider Contact Mobile Number</label>
                            <input 
                                type="tel" 
                                id="mobile" 
                                name="mobile" 
                                class="form-input" 
                                value="<%= user != null ? user.getMobile() : "" %>" 
                                placeholder="10-digit mobile number" 
                                pattern="[0-9]{10}" 
                                required
                            >
                        </div>
                    </div>

                    <!-- Step 3: Payment Method Selection -->
                    <div class="checkout-card">
                        <div class="section-step">
                            <span class="step-num">3</span>
                            <span>Select Payment Method</span>
                        </div>

                        <label class="payment-option-card">
                            <input type="radio" name="paymentMethod" value="Cash on Delivery" checked>
                            <div style="font-size: 20px;">💵</div>
                            <div>
                                <strong>Cash on Delivery (Pay on Arrival)</strong>
                                <p style="font-size: 11px; color: var(--text-secondary);">Pay cash or UPI to delivery partner at doorstep</p>
                            </div>
                        </label>

                        <label class="payment-option-card">
                            <input type="radio" name="paymentMethod" value="UPI / QR Code">
                            <div style="font-size: 20px;">⚡</div>
                            <div>
                                <strong>UPI / QR Code (Google Pay, PhonePe, Paytm)</strong>
                                <p style="font-size: 11px; color: var(--text-secondary);">Instant UPI confirmation</p>
                            </div>
                        </label>

                        <label class="payment-option-card">
                            <input type="radio" name="paymentMethod" value="Credit / Debit Card">
                            <div style="font-size: 20px;">💳</div>
                            <div>
                                <strong>Credit / Debit Cards</strong>
                                <p style="font-size: 11px; color: var(--text-secondary);">Visa, MasterCard, RuPay cards accepted</p>
                            </div>
                        </label>
                    </div>

                </div>

                <!-- Right Column: Order Review & Confirmation -->
                <div class="checkout-card" style="position: sticky; top: 90px;">
                    <h2 style="font-size: 16px; font-weight: 900; margin-bottom: 16px;">Order Summary</h2>

                    <!-- Items Mini List -->
                    <div style="max-height: 220px; overflow-y: auto; margin-bottom: 16px;">
                        <% if (cartItems != null) { %>
                            <% for (CartItem ci : cartItems) { %>
                                <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 8px;">
                                    <span style="color: var(--text-primary); font-weight: 600;">
                                        <%= ci.getQuantity() %>x <%= ci.getProductName() %>
                                    </span>
                                    <span style="font-weight: 800;">
                                        ₹<%= String.format("%.2f", ci.getTotalPrice()) %>
                                    </span>
                                </div>
                            <% } %>
                        <% } %>
                    </div>

                    <div style="border-top: 1px solid var(--border-color); padding-top: 12px;">
                        <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 8px;">
                            <span style="color: var(--text-secondary);">Items Total</span>
                            <span>₹<%= String.format("%.2f", subtotal) %></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 8px;">
                            <span style="color: var(--text-secondary);">15-Min Delivery</span>
                            <span><%= deliveryFee == 0.0 ? "<strong style='color:#059669;'>FREE</strong>" : "₹" + String.format("%.2f", deliveryFee) %></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 8px;">
                            <span style="color: var(--text-secondary);">Handling Fee</span>
                            <span>₹<%= String.format("%.2f", handlingFee) %></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 18px; font-weight: 900; margin-top: 12px; padding-top: 12px; border-top: 1px dashed var(--border-color);">
                            <span>Total Payable</span>
                            <span style="color: var(--primary);">₹<%= String.format("%.2f", grandTotal) %></span>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary" style="margin-top: 20px; padding: 14px; font-size: 15px;">
                        ⚡ Place Order Now (₹<%= String.format("%.2f", grandTotal) %>)
                    </button>

                    <div style="font-size: 11px; color: #64748b; text-align: center; margin-top: 12px;">
                        ⚡ 15-Minute Guaranteed Dispatch from Dark Store
                    </div>
                </div>

            </div>
        </form>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
