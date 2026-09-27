package com.quickcart.dao;

import com.quickcart.model.CartItem;
import com.quickcart.model.Order;
import com.quickcart.model.OrderItem;
import com.quickcart.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for Order Management.
 * Implements ACID transactions for order placement, stock deduction, and order history.
 */
public class OrderDAO {

    private final ProductDAO productDAO = new ProductDAO();
    private final CartDAO cartDAO = new CartDAO();

    /**
     * Creates an order atomically using a single JDBC Database Transaction.
     * Inserts into 'orders', inserts each item into 'order_items', reduces stock in 'products',
     * and clears the user's cart in 'cart'. If any step fails, performs rollback.
     *
     * @param order the Order header object
     * @param cartItems list of cart items purchased
     * @return true if order committed successfully, false if rolled back
     */
    public boolean createOrder(Order order, List<CartItem> cartItems) {
        Connection conn = null;
        String insertOrderSql = "INSERT INTO orders (id, user_id, total_amount, address, city, state, pincode, mobile, payment_method, status) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // START TRANSACTION

            // 1. Insert Order Header
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql)) {
                psOrder.setString(1, order.getId());
                psOrder.setInt(2, order.getUserId());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setString(4, order.getAddress());
                psOrder.setString(5, order.getCity());
                psOrder.setString(6, order.getState());
                psOrder.setString(7, order.getPincode());
                psOrder.setString(8, order.getMobile());
                psOrder.setString(9, order.getPaymentMethod());
                psOrder.setString(10, order.getStatus() != null ? order.getStatus() : "Pending");
                psOrder.executeUpdate();
            }

            // 2. Insert Order Items & Reduce Stock
            try (PreparedStatement psItem = conn.prepareStatement(insertItemSql)) {
                for (CartItem item : cartItems) {
                    // Insert Line Item
                    psItem.setString(1, order.getId());
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getEffectiveUnitPrice());
                    psItem.addBatch();

                    // Reduce Stock atomically
                    boolean stockReduced = productDAO.reduceStock(item.getProductId(), item.getQuantity(), conn);
                    if (!stockReduced) {
                        throw new SQLException("Insufficient stock for product ID: " + item.getProductId());
                    }
                }
                psItem.executeBatch();
            }

            // 3. Clear User's Cart
            cartDAO.clearCart(order.getUserId(), conn);

            conn.commit(); // COMMIT TRANSACTION
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // ROLLBACK ON ERROR
                    System.err.println("Transaction rolled back for order: " + order.getId());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Retrieves all orders placed by a specific user.
     * @param userId user ID
     * @return List of Order objects with their respective items
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single order by its ID with all ordered items.
     * @param orderId unique order string (e.g., "ORD-849201")
     * @return Order object or null
     */
    public Order getOrderById(String orderId) {
        String sql = "SELECT o.*, u.name AS customer_name, u.email AS customer_email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setCustomerName(rs.getString("customer_name"));
                    order.setCustomerEmail(rs.getString("customer_email"));
                    order.setItems(getOrderItems(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all line items for an order.
     * @param orderId order ID
     * @return List of OrderItem objects with product name and image
     */
    public List<OrderItem> getOrderItems(String orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name, p.image AS product_image " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getString("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setProductImage(rs.getString("product_image"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves all orders across the entire store for the Admin Panel.
     * @return List of all Orders
     */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS customer_name, u.email AS customer_email " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerEmail(rs.getString("customer_email"));
                order.setItems(getOrderItems(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Updates the status of an order (Admin feature).
     * @param orderId order ID
     * @param status new status ("Pending", "Confirmed", "Shipped", "Delivered", "Cancelled")
     * @return true if updated
     */
    public boolean updateOrderStatus(String orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets the total count of orders for Admin dashboard statistics.
     * @return total order count
     */
    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gets the total revenue/sales sum from all non-cancelled orders for Admin dashboard.
     * @return total sales in INR
     */
    public double getTotalSalesAmount() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Helper method to map ResultSet row to Order model
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getString("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setAddress(rs.getString("address"));
        o.setCity(rs.getString("city"));
        o.setState(rs.getString("state"));
        o.setPincode(rs.getString("pincode"));
        o.setMobile(rs.getString("mobile"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setStatus(rs.getString("status"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        return o;
    }
}
