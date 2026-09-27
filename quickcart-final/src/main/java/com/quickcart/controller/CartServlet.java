package com.quickcart.controller;

import com.quickcart.dao.CartDAO;
import com.quickcart.dao.ProductDAO;
import com.quickcart.model.CartItem;
import com.quickcart.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Shopping Cart operations:
 * - View Cart (GET /cart)
 * - Add to Cart (POST /cart?action=add)
 * - Update Quantity (POST /cart?action=update)
 * - Remove Item (POST /cart?action=remove)
 * - Clear Cart (POST /cart?action=clear)
 * - Buy Now (instant redirect to checkout)
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Save return target and redirect to login
            session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/cart");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        List<CartItem> cartItems = cartDAO.getCartByUserId(userId);
        double cartTotal = cartDAO.calculateCartTotal(userId);
        int cartCount = cartDAO.getCartCount(userId);

        session.setAttribute("cartCount", cartCount);
        session.setAttribute("cartTotal", cartTotal);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/cart");
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=login_required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        if (action == null) action = "add";

        try {
            switch (action) {
                case "add": {
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = 1;
                    if (request.getParameter("quantity") != null) {
                        try {
                            quantity = Integer.parseInt(request.getParameter("quantity"));
                        } catch (NumberFormatException ignored) {}
                    }
                    if (quantity < 1) quantity = 1;

                    // Verify stock availability
                    Product product = productDAO.getProductById(productId);
                    if (product != null && product.getStock() >= quantity) {
                        cartDAO.addToCart(userId, productId, quantity);
                    }

                    // Check if Buy Now button was clicked
                    String buyNow = request.getParameter("buyNow");
                    if ("true".equalsIgnoreCase(buyNow)) {
                        response.sendRedirect(request.getContextPath() + "/checkout");
                        return;
                    }
                    break;
                }

                case "update": {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    cartDAO.updateQuantity(cartId, quantity, userId);
                    break;
                }

                case "remove": {
                    int cartId = Integer.parseInt(request.getParameter("cartId"));
                    cartDAO.removeFromCart(cartId, userId);
                    break;
                }

                case "clear": {
                    cartDAO.clearCart(userId);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Refresh cart stats in session
        int cartCount = cartDAO.getCartCount(userId);
        double cartTotal = cartDAO.calculateCartTotal(userId);
        session.setAttribute("cartCount", cartCount);
        session.setAttribute("cartTotal", cartTotal);

        // Redirect back to referring page or to cart
        String referer = request.getHeader("referer");
        if (referer != null && (referer.contains("/products") || referer.contains("/product-details") || referer.contains("/index.jsp"))) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
