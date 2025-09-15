# Project Overview

This repository hosts a sophisticated e-commerce web application, leveraging a robust and established Java-based architecture. The system is engineered to provide a foundational platform for a scalable online retail solution, adhering to best practices in technology integration and data management.

---

# Technology Stack

The project is built upon a standard enterprise-grade technology stack, ensuring stability, interoperability, and ease of maintenance.

- **Front-End Presentation Layer:** JavaServer Pages (JSP)  
- **Business and Controller Layer:** Java Servlets  
- **Object-Oriented Design:** Plain Old Java Objects (POJOs) for data modeling and transfer  
- **Application Server:** Apache Tomcat **8.5.81**  
- **Database Management System:** MySQL  
- **Database Connectivity:** MySQL Connector/J **8.0.31**  
- **Development Environment:** Apache NetBeans  

The architecture follows a clear separation of concerns, with servlets managing request handling and business logic, JSP pages handling dynamic content rendering, and POJOs facilitating clean data exchange.

---

# Deployment Guide

This guide provides a systematic approach to deploying and configuring the application in a local development environment.

## 1. Database Initialization

The first step is to provision the database schema and populate it with initial data. This is accomplished by executing the provided SQL script.

- Launch your preferred MySQL client (e.g., MySQL Workbench).  
- Open and execute the entire contents of the `database_schema.sql` file.  
- This script will automatically create the `ProjectDB` database, define all tables, and insert crucial sample data.

## 2. Dependency Management

Ensure the project has the correct JDBC driver. The application is dependent on MySQL Connector/J version **8.0.31**.

- Place the `mysql-connector-j-8.0.31.jar` file in the `web/WEB-INF/lib` directory to make it available to the application's classpath.

## 3. Configuration and Credentials

The database connection parameters must be updated to align with your local environment settings.

- Navigate to `src/java/util/DBConnection.java`.  
- Modify the `USER` and `PASSWORD` constants to match your MySQL server's credentials.

## 4. Project Structure

The project adheres to a conventional Java web application directory layout, making it easier to understand and extend.

## 5. Application Deployment

Once the prerequisites are met, the application is ready for deployment.

- Within Apache NetBeans, ensure your Tomcat **8.5.81** server is correctly configured.  
- Initiate the build and deployment process by right-clicking the project and selecting **Run**.  
- The application will be deployed to the specified Tomcat server and become accessible for testing.

---

# Project Directory Structure

The project follows a conventional Java web application layout with clear separation of configuration, source code, libraries, and deployment artifacts.

C:.
│ build.xml # Ant build configuration
│
├───build # Auto-generated build output
│ ├───empty
│ ├───generated-sources
│ │ └───ap-source-output
│ └───web # Compiled web resources
│ │ admin_dashboard.jsp
│ │ cart.jsp
│ │ checkout.jsp
│ │ edit-address.jsp
│ │ index.html
│ │ login.jsp
│ │ order_confirmation.jsp
│ │ products.jsp
│ │ register.jsp
│ │ user-profile.jsp
│ │
│ ├───META-INF
│ │ context.xml
│ │ MANIFEST.MF
│ │
│ └───WEB-INF
│ │ web.xml
│ │
│ ├───classes # Compiled Java classes
│ │ │ .netbeans_automatic_build
│ │ │ .netbeans_update_resources
│ │ │
│ │ ├───filter
│ │ │ LoginFilter.class
│ │ │
│ │ ├───servlet
│ │ │ AddressManagerServlet.class
│ │ │ AdminControllerServlet.class
│ │ │ CartServlet.class
│ │ │ CheckoutServlet.class
│ │ │ LoginServlet.class
│ │ │ LogoutServlet.class
│ │ │ ProfileManagerServlet.class
│ │ │ RegisterServlet.class
│ │ │
│ │ └───util
│ │ DBConnection.class
│ │
│ └───lib # External libraries
│ mysql-connector-j-8.0.31.jar
│
├───nbproject # NetBeans project metadata
│ │ ant-deploy.xml
│ │ build-impl.xml
│ │ genfiles.properties
│ │ project.properties
│ │ project.xml
│ │
│ └───private
│ private.properties
│ private.xml
│
├───src # Application source code
│ ├───conf
│ │ MANIFEST.MF
│ │
│ └───java
│ ├───filter
│ │ LoginFilter.java
│ │
│ ├───servlet
│ │ AddressManagerServlet.java
│ │ AdminControllerServlet.java
│ │ CartServlet.java
│ │ CheckoutServlet.java
│ │ LoginServlet.java
│ │ LogoutServlet.java
│ │ ProfileManagerServlet.java
│ │ RegisterServlet.java
│ │
│ └───util
│ DBConnection.java
│
├───test # Unit and integration tests
└───web # Web content (development view)
│ admin_dashboard.jsp
│ cart.jsp
│ checkout.jsp
│ edit-address.jsp
│ index.html
│ login.jsp
│ order_confirmation.jsp
│ products.jsp
│ register.jsp
│ user-profile.jsp
│
├───META-INF
│ context.xml
│
└───WEB-INF
web.xml

---

# Database Schema

The following SQL script (`database_schema.sql`) sets up the minimal schema with all 14 core tables required for a basic e-commerce platform. It includes essential fields and relationships to support user accounts, products, orders, and more.

```sql
--
-- E-commerce Database Schema
-- The below queries can be executed in your MySQL client to create the database
-- and set up all the necessary tables with relationships for a basic e-commerce platform.
-- This script covers 14 core tables with only the essential fields to maintain data integrity.
--

CREATE DATABASE ProjectDB;
USE ProjectDB;

-- Table to store user information
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

-- Table for admin users
CREATE TABLE admins (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table for product categories
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Table to store product details
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Table to store images for each product
CREATE TABLE product_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Table for shopping carts
CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table for items within a shopping cart
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE (cart_id, product_id)
);

-- Table to store addresses for users
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table for customer orders
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (address_id) REFERENCES addresses(id)
);

-- Table for individual items in an order
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Table for payment transactions
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Table for discount coupons
CREATE TABLE coupons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_amount DECIMAL(10, 2) NOT NULL CHECK (discount_amount >= 0)
);

-- Table for product reviews and ratings
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table for logging administrative or system actions
CREATE TABLE audit_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    action_type VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (name, email, password_hash, phone) VALUES 
('John Doe', 'john.doe@example.com', 'hashed_password_1', '555-123-4567'),
('Jane Smith', 'jane.smith@example.com', 'hashed_password_2', '555-987-6543'),
('Admin', 'admin@access.com', '1', '0');

INSERT INTO admins (user_id) VALUES (1);
INSERT INTO admins (user_id) VALUES (5);

INSERT INTO categories (name) VALUES ('Phones'), ('Laptops'), ('Books');

INSERT INTO products (name, price, stock_quantity, category_id) VALUES 
('Galaxy S24', 1299.99, 50, 1),
('MacBook Pro', 2499.00, 25, 2),
('RTX 5090', 1999.00, 13, 3);

INSERT INTO product_images (product_id, image_url) VALUES 
(1, 'https://static.orangeromania.ro/webshop-images/hds_sam0101471/samsung_samsung_galaxy_s24_ultra_5g_512gb_dual_sim_titanium_black_l87885_24.png'),
(2, 'https://macfinder.co.uk/wp-content/uploads/2022/12/img-MacBook-Pro-Retina-14-Inch-23934.jpg'),
(3, 'https://files.pccasegear.com/images/ZT-B50900J-10P-thb.jpg'),
(4, 'https://www.mauvais-genres.com/32530-thickbox_default/the-great-gatsby-2013-original-movie-poster-15x21-in-2013-baz-luhrmann-leonardo-dicaprio.jpg');

INSERT INTO carts (user_id) VALUES (1);

INSERT INTO cart_items (cart_id, product_id, quantity) VALUES 
(1, 1, 1),
(1, 3, 2);

INSERT INTO addresses (user_id, street_address, city, postal_code) VALUES 
(1, '123 Main St', 'Anytown', '12345');

INSERT INTO orders (user_id, address_id, status, total_amount) VALUES 
(1, 1, 'Processing', 1330.99);

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES 
(1, 1, 1, 1299.99),
(1, 3, 2, 15.50);

INSERT INTO payments (order_id, amount) VALUES (1, 1330.99);

INSERT INTO coupons (code, discount_amount) VALUES ('SAVE20', 20.00);

INSERT INTO reviews (product_id, user_id, rating) VALUES (1, 1, 5);

INSERT INTO audit_logs (action_type) VALUES ('User registered'), ('Product updated');
