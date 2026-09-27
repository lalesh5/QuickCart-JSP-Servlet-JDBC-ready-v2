<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.ProductDAO" %>
<%@ page import="com.quickcart.model.Product" %>
<%@ page import="java.util.List" %>
<%
    ProductDAO productDAO = new ProductDAO();
    List<Product> dealProducts = productDAO.getDealProducts();
    List<Product> mobProducts = productDAO.getProductsByCategory("Mobiles");
    List<Product> groceryProducts = productDAO.getProductsByCategory("Food & Health");
    List<Product> fashionProducts = productDAO.getProductsByCategory("Fashion");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickCart - 15-Minute Hyperlocal Express Delivery</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <!-- Hero Promo Banner Section -->
        <section class="hero-banner">
            <div class="hero-content">
                <div class="hero-badge">
                    <span>⚡</span> 15-MINUTE GUARANTEED DELIVERY
                </div>
                <h1 class="hero-title">
                    Groceries, Gadgets & Daily Essentials <br>
                    <span>Delivered in 15 Minutes.</span>
                </h1>
                <p class="hero-subtitle">
                    Experience India's fastest hyperlocal store. Fresh milk, smartphones, skincare, 
                    and fashion from your nearest high-speed electric dark store.
                </p>
                <div class="hero-cta-group">
                    <a href="<%= request.getContextPath() %>/products?sort=discount" class="btn-hero-primary">
                        ⚡ Shop Super Flash Deals
                    </a>
                    <a href="<%= request.getContextPath() %>/products" class="btn-hero-secondary">
                        📦 Explore Full Catalog
                    </a>
                </div>
            </div>
            <div class="hero-visual">
                <div class="hero-clock-card">
                    <div style="font-size: 38px;">⏱️</div>
                    <div>
                        <div style="font-size: 20px; font-weight: 900; color: #10b981;">12-15 Mins</div>
                        <div style="font-size: 11px; color: #64748b; font-weight: 700;">AVERAGE RIDER ARRIVAL</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 8 Core Categories Grid -->
        <section class="section-block">
            <div class="section-header">
                <div>
                    <h2 class="section-title">Shop by Category</h2>
                    <p class="section-subtitle">Select from our 8 signature categories for instant express delivery</p>
                </div>
                <a href="<%= request.getContextPath() %>/products" class="view-all-link">View All Categories →</a>
            </div>

            <div class="category-grid">
                <a href="<%= request.getContextPath() %>/products?category=Fashion" class="category-card cat-fashion">
                    <div class="cat-icon">👗</div>
                    <span class="cat-name">Fashion</span>
                    <span class="cat-badge">Up to 60% Off</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Mobiles" class="category-card cat-mobiles">
                    <div class="cat-icon">📱</div>
                    <span class="cat-name">Mobiles</span>
                    <span class="cat-badge">Top Brands</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Electronics" class="category-card cat-electronics">
                    <div class="cat-icon">🎧</div>
                    <span class="cat-name">Electronics</span>
                    <span class="cat-badge">Latest Audio</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Beauty" class="category-card cat-beauty">
                    <div class="cat-icon">✨</div>
                    <span class="cat-name">Beauty</span>
                    <span class="cat-badge">100% Genuine</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Home" class="category-card cat-home">
                    <div class="cat-icon">🏠</div>
                    <span class="cat-name">Home</span>
                    <span class="cat-badge">Kitchenware</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Appliances" class="category-card cat-appliances">
                    <div class="cat-icon">🍳</div>
                    <span class="cat-name">Appliances</span>
                    <span class="cat-badge">Air Fryers & More</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Food%20%26%20Health" class="category-card cat-food">
                    <div class="cat-icon">🥛</div>
                    <span class="cat-name">Food & Health</span>
                    <span class="cat-badge">Fresh Daily</span>
                </a>

                <a href="<%= request.getContextPath() %>/products?category=Stationery" class="category-card cat-stationery">
                    <div class="cat-icon">✏️</div>
                    <span class="cat-name">Stationery</span>
                    <span class="cat-badge">Notebooks & Pens</span>
                </a>
            </div>
        </section>

        <!-- Flash Deals Shelf (Dynamic from MySQL) -->
        <section class="section-block">
            <div class="section-header">
                <div>
                    <span class="deal-tag">⚡ FLASH DEALS</span>
                    <h2 class="section-title">Today's Super Deals: Up to 70% Off</h2>
                    <p class="section-subtitle">Limited stocks available in Powai dark store. Order before timer expires!</p>
                </div>
                <a href="<%= request.getContextPath() %>/products?sort=discount" class="view-all-link">See All Deals →</a>
            </div>

            <div class="product-shelf-grid">
                <% for (Product p : dealProducts) { %>
                    <div class="product-card">
                        <div class="card-img-wrapper">
                            <% if (p.getDiscount() > 0) { %>
                                <span class="discount-badge"><%= p.getDiscount() %>% OFF</span>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>">
                                <img 
                                    src="<%= request.getContextPath() %>/<%= p.getImage() %>" 
                                    alt="<%= p.getName() %>" 
                                    class="product-thumb"
                                    onerror="this.src='https://placehold.co/400x400/f1f5f9/64748b?text=<%= p.getCategory() %>';"
                                >
                            </a>
                        </div>
                        <div class="card-body">
                            <span class="card-category"><%= p.getCategory() %></span>
                            <h3 class="card-title">
                                <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>">
                                    <%= p.getName() %>
                                </a>
                            </h3>
                            <div class="card-rating">
                                <span class="stars">★</span> <strong><%= p.getRating() %></strong>
                                <span class="stock-status <%= p.getStock() > 0 ? "in-stock" : "out-of-stock" %>">
                                    • <%= p.getStock() > 0 ? "In Stock (" + p.getStock() + ")" : "Out of Stock" %>
                                </span>
                            </div>
                            <div class="card-price-row">
                                <div class="price-box">
                                    <span class="curr-price">₹<%= String.format("%.2f", p.getDiscountedPrice()) %></span>
                                    <% if (p.getDiscount() > 0) { %>
                                        <span class="old-price">₹<%= String.format("%.2f", p.getPrice()) %></span>
                                    <% } %>
                                </div>
                                <form action="<%= request.getContextPath() %>/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-add-cart" <%= p.getStock() <= 0 ? "disabled" : "" %>>
                                        + ADD
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

        <!-- Fresh Groceries & Pantry Shelf -->
        <section class="section-block">
            <div class="section-header">
                <div>
                    <span class="category-badge-pill" style="background: #ecfdf5; color: #059669;">🥛 15-MIN ESSENTIALS</span>
                    <h2 class="section-title">Fresh Groceries & Dairy</h2>
                    <p class="section-subtitle">Daily milk, fresh curd, bread, snacks & wellness essentials</p>
                </div>
                <a href="<%= request.getContextPath() %>/products?category=Food%20%26%20Health" class="view-all-link">Browse Grocery →</a>
            </div>

            <div class="product-shelf-grid">
                <% for (Product p : groceryProducts) { %>
                    <div class="product-card">
                        <div class="card-img-wrapper">
                            <% if (p.getDiscount() > 0) { %>
                                <span class="discount-badge"><%= p.getDiscount() %>% OFF</span>
                            <% } %>
                            <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>">
                                <img 
                                    src="<%= request.getContextPath() %>/<%= p.getImage() %>" 
                                    alt="<%= p.getName() %>" 
                                    class="product-thumb"
                                    onerror="this.src='https://placehold.co/400x400/f1f5f9/64748b?text=Groceries';"
                                >
                            </a>
                        </div>
                        <div class="card-body">
                            <span class="card-category"><%= p.getCategory() %></span>
                            <h3 class="card-title">
                                <a href="<%= request.getContextPath() %>/product-details?id=<%= p.getId() %>">
                                    <%= p.getName() %>
                                </a>
                            </h3>
                            <div class="card-rating">
                                <span class="stars">★</span> <strong><%= p.getRating() %></strong>
                                <span class="stock-status <%= p.getStock() > 0 ? "in-stock" : "out-of-stock" %>">
                                    • <%= p.getStock() > 0 ? "Available" : "Sold Out" %>
                                </span>
                            </div>
                            <div class="card-price-row">
                                <div class="price-box">
                                    <span class="curr-price">₹<%= String.format("%.2f", p.getDiscountedPrice()) %></span>
                                    <% if (p.getDiscount() > 0) { %>
                                        <span class="old-price">₹<%= String.format("%.2f", p.getPrice()) %></span>
                                    <% } %>
                                </div>
                                <form action="<%= request.getContextPath() %>/cart" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-add-cart" <%= p.getStock() <= 0 ? "disabled" : "" %>>
                                        + ADD
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

    </main>

    <!-- Global Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
