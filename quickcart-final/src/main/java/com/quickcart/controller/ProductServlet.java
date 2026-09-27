package com.quickcart.controller;

import com.quickcart.dao.CartDAO;
import com.quickcart.dao.ProductDAO;
import com.quickcart.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;

/**
 * Controller servlet for Product Catalog, Category Filtering, Keyword Search, 
 * and Product Details viewing.
 */
@WebServlet(urlPatterns = {"/products", "/product-details", "/search"})
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        // Refresh cart count in session if user is logged in
        refreshCartBadge(request);

        if ("/product-details".equals(path)) {
            handleProductDetails(request, response);
        } else {
            // Handles both /products and /search
            handleProductList(request, response);
        }
    }

    /**
     * Handles product catalog filtering, search, and sorting.
     */
    private void handleProductList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        String search = request.getParameter("search");
        if (search == null) {
            search = request.getParameter("q"); // Support both ?search= and ?q=
        }
        String sort = request.getParameter("sort");

        List<Product> productList;

        if (search != null && !search.trim().isEmpty()) {
            productList = productDAO.searchProducts(search.trim());
            request.setAttribute("searchQuery", search.trim());
        } else if (category != null && !category.trim().isEmpty() && !"all".equalsIgnoreCase(category.trim())) {
            productList = productDAO.getProductsByCategory(category.trim());
            request.setAttribute("selectedCategory", category.trim());
        } else {
            productList = productDAO.getAllProducts();
            request.setAttribute("selectedCategory", "All");
        }

        // Apply sorting if requested
        if ("price_asc".equals(sort)) {
            productList.sort(Comparator.comparingDouble(Product::getDiscountedPrice));
            request.setAttribute("currentSort", "price_asc");
        } else if ("price_desc".equals(sort)) {
            productList.sort((p1, p2) -> Double.compare(p2.getDiscountedPrice(), p1.getDiscountedPrice()));
            request.setAttribute("currentSort", "price_desc");
        } else if ("discount".equals(sort)) {
            productList.sort((p1, p2) -> Integer.compare(p2.getDiscount(), p1.getDiscount()));
            request.setAttribute("currentSort", "discount");
        }

        request.setAttribute("products", productList);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    /**
     * Handles single product detail view.
     */
    private void handleProductDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam.trim());
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                // Also fetch related category products for "You Might Also Like" shelf
                List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategory());
                // Remove the current product from related items
                relatedProducts.removeIf(p -> p.getId() == product.getId());
                request.setAttribute("relatedProducts", relatedProducts);

                request.getRequestDispatcher("/product-details.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Product not found.");
                response.sendRedirect(request.getContextPath() + "/products");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    /**
     * Updates cart badge count in session for the logged-in user.
     */
    private void refreshCartBadge(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            int count = cartDAO.getCartCount(userId);
            double total = cartDAO.calculateCartTotal(userId);
            session.setAttribute("cartCount", count);
            session.setAttribute("cartTotal", total);
        }
    }
}
