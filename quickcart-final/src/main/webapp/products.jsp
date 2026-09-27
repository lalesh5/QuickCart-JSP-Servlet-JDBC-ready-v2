<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.Product" %>
<%@ page import="java.util.List" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String currentSort = (String) request.getAttribute("currentSort");
    if (selectedCategory == null) selectedCategory = "All";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%= (searchQuery != null) ? "Search: " + searchQuery : selectedCategory + " Products" %> - QuickCart
    </title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <!-- Breadcrumb & Page Title -->
        <div class="catalog-header-bar">
            <div>
                <div class="breadcrumb">
                    <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
                    <a href="<%= request.getContextPath() %>/products">Catalog</a> &gt; 
                    <span><%= (searchQuery != null) ? "Search Results" : selectedCategory %></span>
                </div>
                <h1 class="catalog-title">
                    <% if (searchQuery != null) { %>
                        Search Results for "<span style="color: var(--primary);"><%= searchQuery %></span>"
                    <% } else { %>
                        <%= selectedCategory %> Collection
                    <% } %>
                </h1>
                <p class="catalog-count">Showing <%= (products != null ? products.size() : 0) %> products delivered in 15 mins</p>
            </div>

            <!-- Sorting Dropdown -->
            <div class="sort-wrapper">
                <label for="sortSelect" style="font-size: 13px; font-weight: 700; color: #64748b;">Sort By:</label>
                <select 
                    id="sortSelect" 
                    class="sort-select" 
                    onchange="location.href='<%= request.getContextPath() %>/products?category=<%= selectedCategory %>&sort=' + this.value + '<%= (searchQuery != null ? "&search=" + searchQuery : "") %>';"
                >
                    <option value="" <%= currentSort == null ? "selected" : "" %>>Featured</option>
                    <option value="price_asc" <%= "price_asc".equals(currentSort) ? "selected" : "" %>>Price: Low to High</option>
                    <option value="price_desc" <%= "price_desc".equals(currentSort) ? "selected" : "" %>>Price: High to Low</option>
                    <option value="discount" <%= "discount".equals(currentSort) ? "selected" : "" %>>Highest Discount</option>
                </select>
            </div>
        </div>

        <!-- Category Filter Pills Strip -->
        <div class="category-filter-strip">
            <a href="<%= request.getContextPath() %>/products" 
               class="filter-pill <%= "All".equalsIgnoreCase(selectedCategory) && searchQuery == null ? "active" : "" %>">
                ✨ All Items
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Fashion" 
               class="filter-pill <%= "Fashion".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                👗 Fashion
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Mobiles" 
               class="filter-pill <%= "Mobiles".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                📱 Mobiles
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Electronics" 
               class="filter-pill <%= "Electronics".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                🎧 Electronics
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Beauty" 
               class="filter-pill <%= "Beauty".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                ✨ Beauty
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Home" 
               class="filter-pill <%= "Home".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                🏠 Home
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Appliances" 
               class="filter-pill <%= "Appliances".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                🍳 Appliances
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Food%20%26%20Health" 
               class="filter-pill <%= "Food & Health".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                🥛 Food & Health
            </a>
            <a href="<%= request.getContextPath() %>/products?category=Stationery" 
               class="filter-pill <%= "Stationery".equalsIgnoreCase(selectedCategory) ? "active" : "" %>">
                ✏️ Stationery
            </a>
        </div>

        <!-- Product Grid List -->
        <% if (products != null && !products.isEmpty()) { %>
            <div class="product-shelf-grid">
                <% for (Product p : products) { %>
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
        <% } else { %>
            <!-- No Products Found State -->
            <div class="empty-state-card">
                <div style="font-size: 48px; margin-bottom: 12px;">🔍</div>
                <h3>No Matching Products Found</h3>
                <p>We couldn't find any products matching your criteria in our local dark store.</p>
                <div style="margin-top: 18px;">
                    <a href="<%= request.getContextPath() %>/products" class="btn-primary" style="display: inline-block; width: auto; padding: 10px 24px;">
                        Browse All Store Categories
                    </a>
                </div>
            </div>
        <% } %>

    </main>

    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
