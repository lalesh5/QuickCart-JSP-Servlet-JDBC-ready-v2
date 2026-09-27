<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.ProductDAO" %>
<%@ page import="com.quickcart.model.Product" %>
<%
    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    Product p = productDAO.getProductById(Integer.parseInt(idParam));
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product #<%= p.getId() %> - QuickCart Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .admin-nav-bar {
            background: #1e293b;
            color: #ffffff;
            padding: 12px 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-nav-links {
            display: flex;
            gap: 16px;
            font-size: 13px;
            font-weight: 700;
        }
        .admin-nav-links a {
            color: #cbd5e1;
            padding: 6px 12px;
            border-radius: var(--radius-md);
        }
        .admin-nav-links a.active, .admin-nav-links a:hover {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff;
        }
        .form-card {
            max-width: 680px;
            margin: 24px auto;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-xl);
            padding: 32px;
            box-shadow: var(--shadow-sm);
        }
    </style>
</head>
<body style="background: #f1f5f9;">

    <!-- Top Admin Bar -->
    <div class="admin-nav-bar">
        <div style="display: flex; align-items: center; gap: 12px;">
            <div class="bolt" style="width: 28px; height: 28px; font-size: 14px; border-radius: 6px; background: var(--primary); color: #10b981; display:flex; align-items:center; justify-content:center;">⚡</div>
            <strong style="font-size: 15px; letter-spacing: -0.5px;">QUICKCART ADMIN CONSOLE</strong>
        </div>
        <div class="admin-nav-links">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">📊 Dashboard</a>
            <a href="<%= request.getContextPath() %>/admin/products.jsp" class="active">📦 Products</a>
            <a href="<%= request.getContextPath() %>/admin/orders.jsp">🛒 Orders</a>
            <a href="<%= request.getContextPath() %>/admin/users.jsp">👥 Customers</a>
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank" style="background: rgba(16, 185, 129, 0.2); color: #34d399;">🌐 View Store</a>
            <a href="<%= request.getContextPath() %>/logout" style="color: #fca5a5;">🚪 Logout</a>
        </div>
    </div>

    <main class="page-container">

        <div class="breadcrumb" style="margin-bottom: 16px;">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a> &gt; 
            <a href="<%= request.getContextPath() %>/admin/products.jsp">Products</a> &gt; 
            <span>Edit #<%= p.getId() %></span>
        </div>

        <div class="form-card">
            <h2 style="font-size: 20px; font-weight: 900; margin-bottom: 6px;">Edit Product #<%= p.getId() %></h2>
            <p style="font-size: 13px; color: #64748b; margin-bottom: 24px;">Update prices, discount, or inventory count</p>

            <form action="<%= request.getContextPath() %>/admin/product-action" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= p.getId() %>">

                <div class="form-group">
                    <label class="form-label" for="name">Product Name / Title</label>
                    <input type="text" id="name" name="name" class="form-input" value="<%= p.getName() %>" required autofocus>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="category">Category</label>
                        <select id="category" name="category" class="form-input" required>
                            <option value="Fashion" <%= "Fashion".equals(p.getCategory()) ? "selected" : "" %>>Fashion</option>
                            <option value="Mobiles" <%= "Mobiles".equals(p.getCategory()) ? "selected" : "" %>>Mobiles</option>
                            <option value="Electronics" <%= "Electronics".equals(p.getCategory()) ? "selected" : "" %>>Electronics</option>
                            <option value="Beauty" <%= "Beauty".equals(p.getCategory()) ? "selected" : "" %>>Beauty</option>
                            <option value="Home" <%= "Home".equals(p.getCategory()) ? "selected" : "" %>>Home</option>
                            <option value="Appliances" <%= "Appliances".equals(p.getCategory()) ? "selected" : "" %>>Appliances</option>
                            <option value="Food & Health" <%= "Food & Health".equals(p.getCategory()) ? "selected" : "" %>>Food & Health</option>
                            <option value="Stationery" <%= "Stationery".equals(p.getCategory()) ? "selected" : "" %>>Stationery</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="price">Original Price (₹)</label>
                        <input type="number" step="0.01" id="price" name="price" class="form-input" value="<%= p.getPrice() %>" required>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group">
                        <label class="form-label" for="discount">Discount Percentage (%)</label>
                        <input type="number" id="discount" name="discount" class="form-input" value="<%= p.getDiscount() %>" min="0" max="90" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="stock">Available Stock Units</label>
                        <input type="number" id="stock" name="stock" class="form-input" value="<%= p.getStock() %>" min="0" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="image">Image Path or URL</label>
                    <input type="text" id="image" name="image" class="form-input" value="<%= p.getImage() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="description">Full Description</label>
                    <textarea id="description" name="description" class="form-input" rows="4" required><%= p.getDescription() %></textarea>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 24px;">
                    <button type="submit" class="btn-primary" style="flex: 1; padding: 12px;">
                        Update Product Changes
                    </button>
                    <a href="<%= request.getContextPath() %>/admin/products.jsp" class="btn-action" style="padding: 12px 20px;">
                        Cancel
                    </a>
                </div>
            </form>
        </div>

    </main>

</body>
</html>
