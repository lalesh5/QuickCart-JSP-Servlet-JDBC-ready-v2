<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickcart.dao.ProductDAO" %>
<%@ page import="com.quickcart.model.Product" %>
<%@ page import="java.util.List" %>
<%
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Catalog - QuickCart Admin</title>
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
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .admin-table th, .admin-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }
        .admin-table th {
            background: #f8fafc;
            color: #475569;
            font-weight: 800;
            font-size: 11px;
            text-transform: uppercase;
        }
        .thumb-mini {
            width: 44px;
            height: 44px;
            object-fit: contain;
            background: #f8fafc;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 3px;
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

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <div>
                <h1 style="font-size: 24px; font-weight: 900; color: #0f172a;">Product Catalog Management</h1>
                <p style="font-size: 13px; color: #64748b; margin-top: 2px;">Manage inventory, discounts, prices and categories</p>
            </div>
            <a href="<%= request.getContextPath() %>/admin/add-product.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 10px 18px;">
                + Add New Product
            </a>
        </div>

        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-xl); padding: 24px; box-shadow: var(--shadow-sm);">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Category</th>
                        <th>Original Price</th>
                        <th>Discount</th>
                        <th>Selling Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null && !products.isEmpty()) { %>
                        <% for (Product p : products) { %>
                            <tr>
                                <td style="display: flex; align-items: center; gap: 12px;">
                                    <img 
                                        src="<%= request.getContextPath() %>/<%= p.getImage() %>" 
                                        alt="<%= p.getName() %>" 
                                        class="thumb-mini"
                                        onerror="this.src='https://placehold.co/80x80/f8fafc/64748b?text=Item';"
                                    >
                                    <div>
                                        <div style="font-weight: 700; color: #0f172a;"><%= p.getName() %></div>
                                        <div style="font-size: 11px; color: #64748b;">ID: #<%= p.getId() %></div>
                                    </div>
                                </td>
                                <td>
                                    <span style="background: #f1f5f9; padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700;">
                                        <%= p.getCategory() %>
                                    </span>
                                </td>
                                <td>₹<%= String.format("%.2f", p.getPrice()) %></td>
                                <td>
                                    <% if (p.getDiscount() > 0) { %>
                                        <span style="background: #fee2e2; color: #b91c1c; font-size: 11px; font-weight: 800; padding: 2px 6px; border-radius: 4px;">
                                            <%= p.getDiscount() %>% OFF
                                        </span>
                                    <% } else { %>
                                        <span style="color: #94a3b8;">0%</span>
                                    <% } %>
                                </td>
                                <td style="font-weight: 800; color: var(--text-primary);">
                                    ₹<%= String.format("%.2f", p.getDiscountedPrice()) %>
                                </td>
                                <td>
                                    <span style="font-weight: 700; color: <%= p.getStock() > 10 ? "#059669" : (p.getStock() > 0 ? "#d97706" : "#dc2626") %>;">
                                        <%= p.getStock() %> units
                                    </span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="<%= request.getContextPath() %>/admin/edit-product.jsp?id=<%= p.getId() %>" class="btn-action" style="padding: 4px 8px; font-size: 11px;">
                                            ✏️ Edit
                                        </a>
                                        <a href="<%= request.getContextPath() %>/admin/product-action?action=delete&id=<%= p.getId() %>" 
                                           class="btn-action" 
                                           style="padding: 4px 8px; font-size: 11px; color: #ef4444;"
                                           onclick="return confirm('Are you sure you want to delete this product?');">
                                            🗑️
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #94a3b8; padding: 24px;">No products in catalog.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </main>

</body>
</html>
