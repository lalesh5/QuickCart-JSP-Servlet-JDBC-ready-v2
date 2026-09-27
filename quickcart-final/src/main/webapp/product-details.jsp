<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.model.Product" %>
<%@ page import="java.util.List" %>
<%
    Product product = (Product) request.getAttribute("product");
    List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/products");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product.getName() %> - QuickCart Express Delivery</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header -->
    <%@ include file="includes/header.jsp" %>

    <main class="page-container">

        <!-- Breadcrumb -->
        <div class="breadcrumb" style="margin-bottom: 20px;">
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &gt; 
            <a href="<%= request.getContextPath() %>/products">Catalog</a> &gt; 
            <a href="<%= request.getContextPath() %>/products?category=<%= product.getCategory() %>"><%= product.getCategory() %></a> &gt; 
            <span><%= product.getName() %></span>
        </div>

        <!-- Product Presentation Grid -->
        <div class="product-detail-grid">
            <!-- Left: High-Res Product Image Card -->
            <div class="detail-gallery-card">
                <% if (product.getDiscount() > 0) { %>
                    <span class="detail-discount-tag">Save <%= product.getDiscount() %>%</span>
                <% } %>
                <img 
                    src="<%= request.getContextPath() %>/<%= product.getImage() %>" 
                    alt="<%= product.getName() %>" 
                    class="detail-main-img"
                    onerror="this.src='https://placehold.co/600x600/f8fafc/64748b?text=<%= product.getCategory() %>';"
                >
            </div>

            <!-- Right: Product Purchase Info & Action Block -->
            <div class="detail-info-card">
                <span class="detail-category-badge"><%= product.getCategory() %></span>
                <h1 class="detail-title"><%= product.getName() %></h1>

                <!-- Rating & Stock Badge Row -->
                <div class="detail-rating-row">
                    <div class="rating-pill">
                        <span>★</span>
                        <span><%= product.getRating() %></span>
                    </div>
                    <span style="font-size: 13px; color: #64748b; font-weight: 600;">(2,480 verified ratings)</span>
                    <span style="color: #cbd5e1;">•</span>
                    <span class="stock-indicator <%= product.getStock() > 0 ? "in-stock" : "out-of-stock" %>">
                        <%= product.getStock() > 0 ? "🟢 In Stock (" + product.getStock() + " units available)" : "🔴 Currently Out of Stock" %>
                    </span>
                </div>

                <!-- Price & Discount Block -->
                <div class="detail-price-box">
                    <span class="detail-curr-price">₹<%= String.format("%.2f", product.getDiscountedPrice()) %></span>
                    <% if (product.getDiscount() > 0) { %>
                        <span class="detail-old-price">₹<%= String.format("%.2f", product.getPrice()) %></span>
                        <span class="detail-savings-badge">
                            You Save ₹<%= String.format("%.2f", product.getPrice() - product.getDiscountedPrice()) %>
                        </span>
                    <% } %>
                    <div style="font-size: 11px; color: #64748b; margin-top: 4px;">Inclusive of all applicable taxes & GST</div>
                </div>

                <!-- 15-Minute Guaranteed Delivery Pill -->
                <div class="delivery-guarantee-card">
                    <div style="font-size: 26px;">⚡</div>
                    <div>
                        <div style="font-size: 13px; font-weight: 800; color: #059669;">15-Minute Superfast Delivery</div>
                        <div style="font-size: 12px; color: #475569;">Order now and receive by <strong>within 15 minutes</strong> at Powai dark store radius</div>
                    </div>
                </div>

                <!-- Product Description -->
                <div class="detail-description-section">
                    <h3 style="font-size: 14px; font-weight: 800; text-transform: uppercase; color: #475569; margin-bottom: 8px;">Product Overview</h3>
                    <p style="font-size: 14px; color: #334155; line-height: 1.6;"><%= product.getDescription() %></p>
                </div>

                <!-- Add to Cart Form with Quantity Selector -->
                <form action="<%= request.getContextPath() %>/cart" method="post" class="detail-action-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">

                    <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 20px;">
                        <label for="quantitySelect" style="font-size: 13px; font-weight: 800; color: #475569;">QUANTITY:</label>
                        <select id="quantitySelect" name="quantity" class="qty-select">
                            <% for (int i = 1; i <= Math.min(10, Math.max(1, product.getStock())); i++) { %>
                                <option value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="detail-btn-group">
                        <button type="submit" class="btn-add-detail" <%= product.getStock() <= 0 ? "disabled" : "" %>>
                            🛒 Add to Shopping Cart
                        </button>
                        <button type="submit" name="buyNow" value="true" class="btn-buynow-detail" <%= product.getStock() <= 0 ? "disabled" : "" %>>
                            ⚡ Buy Now (Instant Checkout)
                        </button>
                    </div>
                </form>

                <!-- Value Guarantees List -->
                <div class="detail-perks-grid">
                    <div class="perk-item">
                        <span>🛡️</span>
                        <span>100% Original Brand Warranty</span>
                    </div>
                    <div class="perk-item">
                        <span>🔄</span>
                        <span>7-Day Easy Return Policy</span>
                    </div>
                    <div class="perk-item">
                        <span>💵</span>
                        <span>Cash on Delivery & UPI Supported</span>
                    </div>
                </div>

            </div>
        </div>

        <!-- Related Category Products Shelf -->
        <% if (relatedProducts != null && !relatedProducts.isEmpty()) { %>
            <section class="section-block" style="margin-top: 48px;">
                <div class="section-header">
                    <div>
                        <h2 class="section-title">Similar Items in <%= product.getCategory() %></h2>
                        <p class="section-subtitle">Customers also looked at these popular recommendations</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/products?category=<%= product.getCategory() %>" class="view-all-link">View Category →</a>
                </div>

                <div class="product-shelf-grid">
                    <% for (Product p : relatedProducts) { %>
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
                                        • <%= p.getStock() > 0 ? "In Stock" : "Out of Stock" %>
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
        <% } %>

    </main>

    <!-- Footer -->
    <%@ include file="includes/footer.jsp" %>

</body>
</html>
