 create database Ecommerce; # Create a new database called 'Ecommerce' to store all related data for the online store
 
 
CREATE TABLE Customers # Create the "Customers" table to store customer information
(
    customer_id INT AUTO_INCREMENT PRIMARY KEY, # Unique ID for each customer, automatically increments
    first_name VARCHAR(50),# Customer's first name (maximum 50 characters)
    last_name VARCHAR(50),  #  Customer's last name (maximum 50 characters)
    email VARCHAR(100) UNIQUE,  # Customer's email address (must be unique)
    country VARCHAR(50),  # Country of the customer
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP  # Timestamp when the customer was added (set automatically)

);

CREATE TABLE Products #Create the "Products" table to store information about items for sale
(
    product_id INT AUTO_INCREMENT PRIMARY KEY,#Unique ID for each product, automatically increments 
    product_name VARCHAR(100),#Name of the product (maximum 100 characters)
    category VARCHAR(50),#Category the product belongs to (e.g., Electronics, Clothing)
    price DECIMAL(10,2),#Price of the product, with two decimal places (e.g., 19.99)
    stock_quantity INT#Number of items currently in stock
);

CREATE TABLE Orders #Create the "Orders" table to store customer purchase information
(
    order_id INT AUTO_INCREMENT PRIMARY KEY,#Unique ID for each order, automatically increments
    customer_id INT,#ID of the customer who placed the order (linked to Customers table)
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,#Date and time when the order was created (set automatically)
    shipping_country VARCHAR(50),#Country where the order will be shipped
    payment_method VARCHAR(50),#Payment method used for the order (e.g., Credit Card, PayPal)
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)#Foreign key linking this order to a specific customer
);



CREATE TABLE Order_Items #Create the "Order_Items" table to store the items of each order
(
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,#Unique ID for each order item, automatically increments
    order_id INT,#ID of the order this item belongs to (linked to Orders table)
    product_id INT,#ID of the product that was ordered (linked to Products table)
    quantity INT,#Quantity of the product ordered
    unit_price DECIMAL(10,2),#Unit price of the product at the time of the order
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),#Foreign key linking order_id to Orders table
    FOREIGN KEY (product_id) REFERENCES Products(product_id)#Foreign key linking product_id to Products table
);



CREATE TABLE Product_Reviews #Create the "Product_Reviews" table to store customer reviews for products
(
    review_id INT AUTO_INCREMENT PRIMARY KEY,#Unique ID for each review, automatically increments
    customer_id INT,#ID of the customer who wrote the review (linked to Customers table)
    product_id INT,#ID of the product being reviewed (linked to Products table)
    rating INT CHECK (rating BETWEEN 1 AND 5),#Rating given by the customer, must be between 1 and 5
    review_text TEXT,#Optional written feedback from the customer
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,#Date and time when the review was created (set automatically)
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),#Foreign key linking the review to a specific customer
    FOREIGN KEY (product_id) REFERENCES Products(product_id)#Foreign key linking the review to a specific product
);



# Insert sample customers into the Customers table
INSERT INTO Customers (first_name, last_name, email, country)
VALUES
  ('Ahmed', 'Hassan', 'ahmed.hassan@example.com', 'Egypt'),
  ('Lina', 'Khaled', 'lina.khaled@example.com', 'Jordan'),
  ('Omar', 'Ali', 'omar.ali@example.com', 'Saudi Arabia'),
  ('Sara', 'Ibrahim', 'sara.ibrahim@example.com', 'UAE'),
  ('Yousef', 'Tariq', 'yousef.tariq@example.com', 'Morocco');

# Insert sample products into the Products table
INSERT INTO Products (product_name, category, price, stock_quantity)
VALUES
  ('Wireless Mouse', 'Electronics', 19.99, 50),
  ('Bluetooth Speaker', 'Electronics', 39.99, 30),
  ('Yoga Mat', 'Fitness', 25.00, 20),
  ('Running Shoes', 'Footwear', 60.00, 15),
  ('Water Bottle', 'Fitness', 10.00, 100);

#Insert sample orders into the Orders table
INSERT INTO Orders (customer_id, order_date, shipping_country, payment_method)
VALUES
  (1, '2025-07-01 10:15:00', 'Egypt', 'Credit Card'),      # Ahmed's first order
  (2, '2025-07-02 14:20:00', 'Jordan', 'PayPal'),          # Lina's order
  (3, '2025-07-03 09:10:00', 'Saudi Arabia', 'Credit Card'), # Omar's order
  (1, '2025-07-05 16:45:00', 'Egypt', 'Cash on Delivery'), # Ahmed's second order
  (4, '2025-07-06 11:30:00', 'UAE', 'Apple Pay');          # Sara's order

#Insert sample order items into the Order_Items table
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 2, 19.99),   # Ahmed bought 2 Wireless Mice in order #1
  (1, 2, 1, 39.99),   # Ahmed bought 1 Bluetooth Speaker in order #1
  (2, 3, 1, 25.00),   # Lina bought 1 Yoga Mat in order #2
  (3, 4, 2, 60.00),   # Omar bought 2 Running Shoes in order #3
  (4, 5, 5, 10.00),   # Ahmed bought 5 Water Bottles in order #4
  (5, 3, 1, 25.00);   # Sara bought 1 Yoga Mat in order #5

#Insert sample product reviews into the Product_Reviews table
INSERT INTO Product_Reviews (customer_id, product_id, rating, review_text, review_date)
VALUES
  (1, 1, 5, 'Excellent mouse, very responsive.', '2025-07-02 12:00:00'), # Ahmed's review of Wireless Mouse
  (2, 3, 4, 'Good quality, but a bit slippery.', '2025-07-03 16:00:00'), # Lina's review of Yoga Mat
  (3, 4, 5, 'Super comfortable and stylish.', '2025-07-04 10:00:00'),    # Omar's review of Running Shoes
  (4, 3, 3, 'It’s okay, but not the best.', '2025-07-06 12:00:00'),      # Sara's review of Yoga Mat
  (1, 5, 4, 'Keeps my water cold!', '2025-07-07 08:00:00');              # Ahmed's review of Water Bottle




SELECT * FROM Customers;
  SELECT * FROM Products;
  SELECT * FROM Orders;
  SELECT * FROM Order_Items;
  SELECT * FROM Product_Reviews;
  


# Shows each product with the total quantity sold, sorted from best-selling to least
 SELECT 
    P.product_name,
    SUM(OI.quantity) AS total_sold
FROM 
    Order_Items OI
JOIN 
    Products P ON OI.product_id = P.product_id
GROUP BY 
    P.product_name
ORDER BY 
    total_sold DESC;


# Counts the total number of orders placed in July 2025
SELECT 
    COUNT(*) AS total_orders
FROM 
    Orders
WHERE 
    order_date BETWEEN '2025-07-01' AND '2025-07-31';
    
    
    
 #  Finds the customer who spent the most by summing all their order item costs
  SELECT 
    C.first_name,
    C.last_name,
    SUM(OI.unit_price * OI.quantity) AS total_spent
FROM 
    Customers C
JOIN 
    Orders O ON C.customer_id = O.customer_id
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
GROUP BY 
    C.customer_id
ORDER BY 
    total_spent DESC
LIMIT 1;  






# Lists products with their average review rating, sorted from highest to lowest
SELECT 
    P.product_name,
    ROUND(AVG(PR.rating), 2) AS average_rating
FROM 
    Product_Reviews PR
JOIN 
    Products P ON PR.product_id = P.product_id
GROUP BY 
    P.product_name
ORDER BY 
    average_rating DESC;
    
    
    # Counts and lists the number of customers per country, ordered from highest to lowest
    SELECT 
    country,
    COUNT(*) AS customer_count
FROM 
    Customers
GROUP BY 
    country
ORDER BY 
    customer_count DESC;
    
    
    
    
    
    # Calculates total monthly revenue by summing order item sales, grouped and ordered by year-month
     SELECT 
    DATE_FORMAT(O.order_date, '%Y-%m') AS month,
    ROUND(SUM(OI.unit_price * OI.quantity), 2) AS total_revenue
FROM 
    Orders O
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
GROUP BY 
    DATE_FORMAT(O.order_date, '%Y-%m')
ORDER BY 
    month;
    
    
    
    
    # Lists customers who placed more than one order, showing their order count sorted from highest to lowest
     SELECT 
    C.first_name,
    C.last_name,
    COUNT(O.order_id) AS order_count
FROM 
    Customers C
JOIN 
    Orders O ON C.customer_id = O.customer_id
GROUP BY 
    C.customer_id
HAVING 
    order_count > 1
ORDER BY 
    order_count DESC;
    
    
    
    
    
    # Shows each product's total quantity sold and the date it was last sold, ordered by total sales descending
    SELECT 
    P.product_name,
    SUM(OI.quantity) AS total_sold,
    MAX(O.order_date) AS last_sold_date
FROM 
    Order_Items OI
JOIN 
    Products P ON OI.product_id = P.product_id
JOIN 
    Orders O ON OI.order_id = O.order_id
GROUP BY 
    P.product_id
ORDER BY 
    total_sold DESC;
    


# Lists products with their categories and average ratings, sorted from highest to lowest average rating
SELECT 
    P.category,
    P.product_name,
    ROUND(AVG(R.rating), 2) AS avg_rating
FROM 
    Products P
JOIN 
    Product_Reviews R ON P.product_id = R.product_id
GROUP BY 
    P.product_id
ORDER BY 
    avg_rating DESC;
    
    
    
    # Calculates total revenue per product category, sorted from highest to lowest revenue
    SELECT 
    P.category,
    ROUND(SUM(OI.unit_price * OI.quantity), 2) AS category_revenue
FROM 
    Order_Items OI
JOIN 
    Products P ON OI.product_id = P.product_id
GROUP BY 
    P.category
ORDER BY 
    category_revenue DESC;
    
    
    
    
   # Shows total orders and total revenue grouped by shipping country, ordered by revenue descending
    SELECT 
    O.shipping_country,
    COUNT(O.order_id) AS total_orders,
    ROUND(SUM(OI.unit_price * OI.quantity), 2) AS total_revenue
FROM 
    Orders O
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
GROUP BY 
    O.shipping_country
ORDER BY 
    total_revenue DESC;
    
    
    
    
    
    #  Creates a view named Order_Summary that consolidates order details with customer and product info, including total price per item
     CREATE VIEW Order_Summary AS
SELECT 
    O.order_id,
    C.first_name,
    C.last_name,
    O.order_date,
    P.product_name,
    OI.quantity,
    OI.unit_price,
    (OI.quantity * OI.unit_price) AS total_price
FROM 
    Orders O
JOIN 
    Customers C ON O.customer_id = C.customer_id
JOIN 
    Order_Items OI ON O.order_id = OI.order_id
JOIN 
    Products P ON OI.product_id = P.product_id;
    
    
 SELECT * FROM Order_Summary WHERE first_name = 'Ahmed'; # Retrieves all order summary records for customers named 'Ahmed'
 
 
 
 # Defines a stored procedure 'GetProductSales' that returns total quantity sold and revenue for a given product ID
     DELIMITER $$

CREATE PROCEDURE GetProductSales(IN prod_id INT)
BEGIN
    SELECT 
        P.product_name,
        SUM(OI.quantity) AS total_quantity_sold,
        ROUND(SUM(OI.quantity * OI.unit_price), 2) AS total_revenue
    FROM 
        Order_Items OI
    JOIN 
        Products P ON OI.product_id = P.product_id
    WHERE 
        P.product_id = prod_id
    GROUP BY 
        P.product_name;
END $$

DELIMITER ;


CALL GetProductSales(1); # Calls the stored procedure to get sales summary for the product with product_id = 1






# Creates a trigger that automatically decreases product stock quantity after a new order item is inserted
DELIMITER $$

CREATE TRIGGER AfterOrderItemInsert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END $$

DELIMITER ;




CREATE INDEX idx_customer_email ON Customers(email);#Creates an index on Customers' email to speed up searches by email
CREATE INDEX idx_order_date ON Orders(order_date);#Creates an index on Orders' order_date to speed up queries filtering by order date


#Creates a view 'Product_Performance' summarizing each product’s total sales, average rating, and total revenue
SELECT
    P.product_name,
    P.category,
    SUM(OI.quantity) AS total_sold,
    ROUND(AVG(PR.rating), 2) AS avg_rating,
    ROUND(SUM(OI.quantity * OI.unit_price), 2) AS total_revenue
FROM
    Products P
LEFT JOIN Order_Items OI ON P.product_id = OI.product_id
LEFT JOIN Product_Reviews PR ON P.product_id = PR.product_id
GROUP BY
    P.product_id;




