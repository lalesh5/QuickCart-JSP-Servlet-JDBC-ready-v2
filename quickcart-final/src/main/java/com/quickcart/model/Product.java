package com.quickcart.model;

import java.sql.Timestamp;

/**
 * Model class representing a Product in the QuickCart catalog.
 */
public class Product {
    private int id;
    private String name;
    private String category;
    private String description;
    private double price;
    private int discount; // percentage, e.g., 20
    private int stock;
    private String image;
    private double rating;
    private Timestamp createdAt;

    public Product() {
    }

    public Product(int id, String name, String category, String description, double price, int discount, int stock, String image, double rating, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.description = description;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.image = image;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    public Product(String name, String category, String description, double price, int discount, int stock, String image, double rating) {
        this.name = name;
        this.category = category;
        this.description = description;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.image = image;
        this.rating = rating;
    }

    // Helper method to get the final price after discount
    public double getDiscountedPrice() {
        if (discount > 0) {
            return price - (price * discount / 100.0);
        }
        return price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
