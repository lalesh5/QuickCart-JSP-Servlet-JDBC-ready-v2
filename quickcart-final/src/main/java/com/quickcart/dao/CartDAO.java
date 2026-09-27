package com.quickcart.dao;

import com.quickcart.model.CartItem;
import com.quickcart.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Shopping Cart operations.
 * Handles adding, updating quantities, removing items, and calculating order totals.
 */
public class CartDAO {

    /**
     * Retrieves all cart items for a specific user, joined with product details.
     * @param userId user ID
     * @return List of CartItem objects
     */
    public List<CartItem> getCartByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.id, c.user_id, c.product_id, c.quantity, " +
                     "p.name AS product_name, p.category AS product_category, " +
                     "p.price AS product_price, p.discount AS product_discount, " +
                     "p.image AS product_image, p.stock AS product_stock " +
                     "FROM cart c " +
                     "JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductCategory(rs.getString("product_category"));
                    item.setProductPrice(rs.getDouble("product_price"));
                    item.setProductDiscount(rs.getInt("product_discount"));
                    item.setProductImage(rs.getString("product_image"));
                    item.setProductStock(rs.getInt("product_stock"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Adds an item to the cart. If the product is already in the cart, increases its quantity.
     * @param userId user ID
     * @param productId product ID
     * @param quantity quantity to add
     * @return true if successful, false otherwise
     */
    public boolean addToCart(int userId, int productId, int quantity) {
        // First check if product already exists in user's cart
        String checkSql = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE id = ?";
        String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            // Check existing
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, userId);
                psCheck.setInt(2, productId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        int cartId = rs.getInt("id");
                        try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                            psUpdate.setInt(1, quantity);
                            psUpdate.setInt(2, cartId);
                            return psUpdate.executeUpdate() > 0;
                        }
                    }
                }
            }

            // If not found, insert new
            try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                psInsert.setInt(1, userId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, quantity);
                return psInsert.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the exact quantity of a cart item.
     * @param cartId cart row ID
     * @param quantity new quantity
     * @param userId user ID for security
     * @return true if updated
     */
    public boolean updateQuantity(int cartId, int quantity, int userId) {
        if (quantity <= 0) {
            return removeFromCart(cartId, userId);
        }
        String sql = "UPDATE cart SET quantity = ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes an item from the cart.
     * @param cartId cart row ID
     * @param userId user ID for security
     * @return true if deleted
     */
    public boolean removeFromCart(int cartId, int userId) {
        String sql = "DELETE FROM cart WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Clears all items from the user's cart (called upon successful checkout).
     * @param userId user ID
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Clears user's cart using an active database transaction.
     * @param userId user ID
     * @param conn active transaction connection
     */
    public boolean clearCart(int userId, Connection conn) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        }
    }

    /**
     * Gets the total number of items in a user's cart for the Header badge pill.
     * @param userId user ID
     * @return count of items
     */
    public int getCartCount(int userId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Computes the total cart amount after considering product discounts.
     * @param userId user ID
     * @return total cart sum in INR
     */
    public double calculateCartTotal(int userId) {
        List<CartItem> items = getCartByUserId(userId);
        double total = 0.0;
        for (CartItem item : items) {
            total += item.getTotalPrice();
        }
        return total;
    }
}
