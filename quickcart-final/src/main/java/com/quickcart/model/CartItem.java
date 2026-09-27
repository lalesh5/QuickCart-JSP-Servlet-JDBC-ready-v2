package com.quickcart.model;

/**
 * Model class representing an item inside the user's shopping cart.
 * Combines cart record information with joined product details for JSP rendering.
 */
public class CartItem {
    private int id;
    private int userId;
    private int productId;
    private int quantity;

    // Joined Product Details for easy display
    private String productName;
    private String productCategory;
    private double productPrice;
    private int productDiscount;
    private String productImage;
    private int productStock;

    public CartItem() {
    }

    public CartItem(int id, int userId, int productId, int quantity) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public double getEffectiveUnitPrice() {
        if (productDiscount > 0) {
            return productPrice - (productPrice * productDiscount / 100.0);
        }
        return productPrice;
    }

    public double getTotalPrice() {
        return getEffectiveUnitPrice() * quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public int getProductDiscount() {
        return productDiscount;
    }

    public void setProductDiscount(int productDiscount) {
        this.productDiscount = productDiscount;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public int getProductStock() {
        return productStock;
    }

    public void setProductStock(int productStock) {
        this.productStock = productStock;
    }
}
