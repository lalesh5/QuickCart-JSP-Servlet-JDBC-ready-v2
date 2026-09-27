<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    Integer cartItemCount = (Integer) session.getAttribute("cartCount");
    Double cartTotalVal = (Double) session.getAttribute("cartTotal");
    if (cartItemCount == null) cartItemCount = 0;
    if (cartTotalVal == null) cartTotalVal = 0.0;
%>

<!-- Top Micro Announcement Strip -->
<div class="top-bar">
    <div class="top-bar-inner">
        <div style="display: flex; align-items: center; gap: 10px;">
            <div class="top-badge">
                <span>⚡</span> 10-15 MIN EXPRESS
            </div>
            <span style="color: #cbd5e1; font-weight: 600;">
                📍 Delivering to <strong>Powai, Mumbai (400076)</strong>
            </span>
        </div>
        <div class="top-nav-links">
            <span style="color: #34d399; font-weight: 700;">✨ Free Delivery above ₹499</span>
            <a href="<%= request.getContextPath() %>/products?sort=discount" style="color: #fde047; font-weight: 700;">
                🏷️ Super Deals
            </a>
            <% if (currentUser != null) { %>
                <a href="<%= request.getContextPath() %>/orders" style="color: #cbd5e1; font-weight: 600;">
                    📦 My Orders
                </a>
            <% } %>
            <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" 
                   style="background: rgba(245, 158, 11, 0.2); color: #fde047; padding: 2px 8px; border-radius: 9999px; border: 1px solid rgba(245, 158, 11, 0.4); font-weight: 800;">
                    🛡️ Admin Console
                </a>
            <% } %>
        </div>
    </div>
</div>

<!-- Main Navigation Header -->
<header class="main-header">
    <div class="header-container">
        <!-- Brand Logo -->
        <a href="<%= request.getContextPath() %>/index.jsp" class="brand-logo" title="QuickCart Express Home">
            <div class="bolt">⚡</div>
            <div>
                <span class="brand-quick">QUICK</span><span class="brand-cart">CART</span>
            </div>
        </a>

        <!-- Express 15-Min Delivery Badge -->
        <div class="express-pill-header">
            <span class="pulse-dot"></span>
            <div>
                <span style="font-size: 10px; text-transform: uppercase; color: #64748b; font-weight: 800; display: block; line-height: 1;">15 Mins Delivery</span>
                <span style="font-size: 12px; font-weight: 800; color: #0f172a;">Home • Mumbai</span>
            </div>
        </div>

        <!-- Central Search Bar -->
        <div class="header-search-wrapper">
            <form action="<%= request.getContextPath() %>/products" method="get" class="search-form">
                <span class="search-icon">🔍</span>
                <input 
                    type="text" 
                    name="search" 
                    class="search-input" 
                    placeholder="Search for groceries, phones, headphones, fashion, appliances..." 
                    value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>"
                    required
                >
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>

        <!-- Header Actions: My Orders, Profile, Cart -->
        <div class="header-actions">
            <!-- My Orders Button (Always directly accessible) -->
            <% if (currentUser != null) { %>
                <a href="<%= request.getContextPath() %>/orders" class="btn-action" title="View Order History & Tracking">
                    <span>📦</span>
                    <span class="hide-mobile">My Orders</span>
                </a>
            <% } %>

            <!-- User Authentication / Profile Dropdown -->
            <% if (currentUser != null) { %>
                <div class="user-menu-wrapper">
                    <a href="<%= request.getContextPath() %>/profile.jsp" class="btn-action user-pill">
                        <div class="user-avatar"><%= currentUser.getName().substring(0, 1).toUpperCase() %></div>
                        <div class="user-info hide-mobile">
                            <span class="user-role-label"><%= "ADMIN".equalsIgnoreCase(currentUser.getRole()) ? "Staff" : "Account" %></span>
                            <span class="user-display-name"><%= currentUser.getName().split(" ")[0] %></span>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn-logout" title="Sign Out">
                        🚪
                    </a>
                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn-action login-pill">
                    <span>👤</span>
                    <span>Sign In</span>
                </a>
            <% } %>

            <!-- Cart Pill Button with Count and INR Total -->
            <a href="<%= request.getContextPath() %>/cart.jsp" class="cart-pill-btn" title="View Shopping Cart">
                <div class="cart-icon-box">
                    <span>🛒</span>
                    <% if (cartItemCount > 0) { %>
                        <span class="cart-badge"><%= cartItemCount %></span>
                    <% } %>
                </div>
                <div class="cart-price-info hide-mobile">
                    <span class="cart-count-txt"><%= cartItemCount %> items</span>
                    <span class="cart-total-txt">₹<%= String.format("%.2f", cartTotalVal) %></span>
                </div>
            </a>
        </div>
    </div>
</header>
