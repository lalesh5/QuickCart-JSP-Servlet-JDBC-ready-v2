<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Brand Value Guarantee Pillars -->
<div class="footer-pillars-strip">
    <div class="pillars-container">
        <div class="pillar-card">
            <div class="pillar-icon" style="background: #f5f3ff; color: #7c3aed;">⚡</div>
            <div>
                <h4>15-Min Delivery</h4>
                <p>Hyperlocal electric dark stores</p>
            </div>
        </div>

        <div class="pillar-card">
            <div class="pillar-icon" style="background: #ecfdf5; color: #10b981;">🛡️</div>
            <div>
                <h4>100% Genuine</h4>
                <p>Direct from verified brands</p>
            </div>
        </div>

        <div class="pillar-card">
            <div class="pillar-icon" style="background: #fef2f2; color: #ef4444;">🔄</div>
            <div>
                <h4>Instant Easy Returns</h4>
                <p>Doorstep doorstep pickup</p>
            </div>
        </div>

        <div class="pillar-card">
            <div class="pillar-icon" style="background: #fffbeb; color: #f59e0b;">🎧</div>
            <div>
                <h4>24x7 Customer Support</h4>
                <p>Prompt resolution assistance</p>
            </div>
        </div>
    </div>
</div>

<!-- Main Footer -->
<footer class="main-footer">
    <div class="footer-links-grid">
        <div class="footer-brand-col">
            <div class="brand-logo" style="margin-bottom: 12px;">
                <div class="bolt">⚡</div>
                <div><span class="brand-quick" style="color: #ffffff;">QUICK</span><span class="brand-cart" style="color: #34d399;">CART</span></div>
            </div>
            <p style="font-size: 13px; color: #94a3b8; line-height: 1.6; max-width: 340px;">
                QuickCart is India's fastest hyperlocal marketplace delivering fresh groceries, 
                smartphones, trending fashion, beauty products, and home essentials in 15 minutes.
            </p>
            <div style="margin-top: 16px;">
                <span class="payment-badge">⚡ UPI Accepted</span>
                <span class="payment-badge">💳 Credit / Debit</span>
                <span class="payment-badge">💵 Cash on Delivery</span>
            </div>
        </div>

        <div>
            <h4 class="footer-heading">Top Categories</h4>
            <ul class="footer-nav-list">
                <li><a href="<%= request.getContextPath() %>/products?category=Fashion">👗 Fashion & Apparel</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Mobiles">📱 Mobiles & Accessories</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Electronics">🎧 Audio & Electronics</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Beauty">✨ Skincare & Beauty</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Food%20%26%20Health">🥛 Food & Fresh Dairy</a></li>
            </ul>
        </div>

        <div>
            <h4 class="footer-heading">Explore More</h4>
            <ul class="footer-nav-list">
                <li><a href="<%= request.getContextPath() %>/products?category=Home">🏠 Home & Kitchen</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Appliances">🍳 Smart Appliances</a></li>
                <li><a href="<%= request.getContextPath() %>/products?category=Stationery">✏️ Stationery & Books</a></li>
                <li><a href="<%= request.getContextPath() %>/products?sort=discount">🔥 Flash Discount Deals</a></li>
                <li><a href="<%= request.getContextPath() %>/products">📦 Browse Entire Catalog</a></li>
            </ul>
        </div>

        <div>
            <h4 class="footer-heading">Customer Care</h4>
            <ul class="footer-nav-list">
                <li><a href="<%= request.getContextPath() %>/orders">My Orders & Live Tracking</a></li>
                <li><a href="<%= request.getContextPath() %>/cart.jsp">My Shopping Cart</a></li>
                <li><a href="<%= request.getContextPath() %>/profile.jsp">My Account & Addresses</a></li>
                <li><a href="<%= request.getContextPath() %>/login.jsp">Customer Login / Register</a></li>
            </ul>
        </div>
    </div>

    <div class="footer-bottom">
        <span>© 2026 QuickCart Express Delivery India Pvt Ltd. Second Year Computer Engineering Mini Project.</span>
        <div style="display: flex; align-items: center; gap: 8px;">
            <span class="online-indicator"></span>
            <span style="color: #34d399; font-weight: 600;">15-Min Express Delivery Active</span>
        </div>
    </div>
</footer>
