-- ========================================================
-- QuickCart - MySQL Database DDL & Seed Data Script
-- Project: QuickCart Full Stack Java Mini Project
-- Database Name: quickkart
-- ========================================================

DROP DATABASE IF EXISTS quickkart;
CREATE DATABASE quickcart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quickcart;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS TABLE
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    mobile VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. PRODUCTS TABLE
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount INT DEFAULT 0,
    stock INT NOT NULL DEFAULT 50,
    image VARCHAR(255) NOT NULL,
    rating DECIMAL(2, 1) DEFAULT 4.5,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB;

-- 3. CART TABLE
DROP TABLE IF EXISTS cart;
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    UNIQUE KEY uq_user_product (user_id, product_id),
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. ORDERS TABLE
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. ORDER_ITEMS TABLE
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================================
-- SEED DATA INSERTION
-- ========================================================

-- Insert Initial Users (Passwords: 'admin123' and 'user123')
INSERT INTO users (id, name, email, mobile, password, role) VALUES
(1, 'Store Administrator', 'admin@quickcart.com', '9876543210', 'admin123', 'ADMIN'),
(2, 'Lalesh Rathod', 'lalesh@gmail.com', '9123456780', 'user123', 'USER');

-- Insert Initial Catalog across QuickCart's 8 Categories
INSERT INTO products (id, name, category, description, price, discount, stock, image, rating) VALUES
(1, 'Redmi Note 13 5G (8GB/128GB)', 'Mobiles', '108MP Super-clear Camera, 120Hz AMOLED, 33W Fast Charge.', 16999.00, 19, 45, 'images/products/redmi_13_5g_black_diamond_1788083687064.jpg', 4.6),
(2, 'Sony WH-1000XM5 Wireless ANC Headphones', 'Electronics', 'Industry leading noise cancellation, 30h battery life, crystal clear calling.', 26990.00, 23, 20, 'images/products/boat_power_bank_20000_1788082497862.jpg', 4.8),
(3, 'Men Premium Linen Regular Fit Shirt', 'Fashion', '100% Breathable pure European flax linen casual shirt in sky blue.', 1299.00, 48, 60, 'images/products/black_distress_baggy_jeans_streetwear_1788085772228.jpg', 4.4),
(4, 'The Derma Co 1% Hyaluronic Sunscreen Aqua Gel', 'Beauty', 'SPF 50 PA++++ lightweight sunscreen for glowing skin with zero white cast.', 449.00, 10, 100, 'images/products/black_chunky_sunglasses_1788107407110.jpg', 4.7),
(5, 'Philips Digital Air Fryer HD9252', 'Appliances', 'Touch screen with 7 presets, Rapid Air technology with up to 90% less oil.', 6499.00, 41, 25, 'images/products/casio_fx991cw_calc_1788081506457.jpg', 4.6),
(6, 'Amul Taaza Homogenised Toned Milk (1 Litre)', 'Food & Health', 'Fresh pure pasteurized milk with zero preservatives. Ready to drink.', 72.00, 4, 150, 'images/products/amul_taaza_milk_1788078901781.jpg', 4.9),
(7, 'Classmate Pulse 6-Subject Spiral Notebook (300 pgs)', 'Stationery', 'High quality smooth white paper with color-coded multi-subject dividers.', 185.00, 16, 80, 'images/products/impulse_grey_laptop_backpack_1788108087290.jpg', 4.7),
(8, 'Prestige Electric Kettle PKOSS 1.5L', 'Home', '1500 Watt stainless steel kettle with automatic cut-off and 360-degree swivel base.', 799.00, 35, 40, 'images/products/fortune_sunlite_oil_1788080169293.jpg', 4.5);
