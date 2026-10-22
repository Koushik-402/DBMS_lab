-- EXPERIMENT 4: DATABASE CONSTRAINTS
-- DBMS Laboratory | MySQL 8.0.16+
-- Case Study: Online Retail Order Management

-- 1. Create and select database
CREATE DATABASE IF NOT EXISTS RetailConstraintDB;
USE RetailConstraintDB;

-- 2. Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60) NOT NULL,
    email VARCHAR(80) NOT NULL UNIQUE,
    city VARCHAR(40) DEFAULT 'Chennai'
) ENGINE=InnoDB;

-- 3. Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(60) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

-- 4. Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(12) NOT NULL DEFAULT 'Pending',
    order_date DATE NOT NULL DEFAULT (CURRENT_DATE),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT fk_order_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    CONSTRAINT chk_quantity CHECK (quantity > 0),

    CONSTRAINT chk_status CHECK (
        order_status IN ('Pending', 'Confirmed', 'Cancelled')
    )
) ENGINE=InnoDB;

-- 5. Insert Customers
INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES
(201, 'Asha', 'asha@example.com', 'Chennai'),
(202, 'Bala', 'bala@example.com', 'Hyderabad'),
(203, 'Charu', 'charu@example.com', 'Bengaluru');

-- 6. Insert Products
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES
(301, 'KB-01', 'Keyboard', 850, 25),
(302, 'MS-02', 'Mouse', 450, 40),
(303, 'HD-03', 'Hard Drive', 4200, 10);

-- 7. Insert Orders
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES
(401, 201, 301, 2, 'Pending'),
(402, 202, 302, 3, 'Confirmed'),
(403, 203, 303, 1, 'Pending');

-- 8. Test DEFAULT city
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (204, 'Deepa', 'deepa@example.com');

SELECT customer_id, customer_name, city
FROM Customers
WHERE customer_id = 204;

-- 9. Test PRIMARY KEY violation
-- Expected to fail: duplicate customer_id.
-- Run separately:
-- INSERT INTO Customers
-- VALUES (201, 'Duplicate', 'duplicate@example.com', 'Delhi');

-- 10. Test UNIQUE violation
-- Expected to fail: duplicate email.
-- INSERT INTO Customers
-- VALUES (205, 'Esha', 'asha@example.com', 'Mumbai');

-- 11. Test NOT NULL violation
-- Expected to fail: customer_name cannot be NULL.
-- INSERT INTO Customers (customer_id, customer_name, email)
-- VALUES (205, NULL, 'esha@example.com');

-- 12. Test CHECK price violation
-- Expected to fail: price must be positive.
-- INSERT INTO Products
-- VALUES (304, 'BAD-04', 'Invalid Product', -10, 5);

-- 13. Test CHECK quantity violation
-- Expected to fail: quantity must be positive.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity)
-- VALUES (404, 201, 301, 0);

-- 14. Test FOREIGN KEY violation
-- Expected to fail: customer 999 does not exist.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity)
-- VALUES (404, 999, 301, 1);

-- 15. Test CHECK status violation
-- Expected to fail: Shipped is not an approved status.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity, order_status)
-- VALUES (404, 201, 301, 1, 'Shipped');

-- 16. Display Customers
SELECT customer_id, customer_name, email, city
FROM Customers
ORDER BY customer_id;

-- 17. Display Products
SELECT * FROM Products
ORDER BY product_id;

-- 18. Display Orders
SELECT order_id, customer_id, product_id,
       quantity, order_status, order_date
FROM Orders
ORDER BY order_id;

-- 19. Display Orders with Customer Names
SELECT O.order_id, C.customer_name,
       P.product_name, O.quantity, O.order_status
FROM Orders O
JOIN Customers C ON O.customer_id = C.customer_id
JOIN Products P ON O.product_id = P.product_id
ORDER BY O.order_id;

-- 20. Inspect table constraints
SHOW CREATE TABLE Orders;

-- 21. Verify record counts
SELECT COUNT(*) AS Total_Customers FROM Customers;
SELECT COUNT(*) AS Total_Products FROM Products;


SELECT COUNT(*) AS Total_Orders FROM Orders;






-- EXPERIMENT 4: DATABASE CONSTRAINTS
-- DBMS Laboratory | Oracle Database
-- Case Study: Online Retail Order Management

-- Connect to your Oracle schema first.
-- Oracle does not use CREATE DATABASE like MySQL.

-- 1. Create Customers table
CREATE TABLE Customers (
    customer_id NUMBER(10) PRIMARY KEY,
    customer_name VARCHAR2(60) NOT NULL,
    email VARCHAR2(80) NOT NULL UNIQUE,
    city VARCHAR2(40) DEFAULT 'Chennai'
);

-- 2. Create Products table
CREATE TABLE Products (
    product_id NUMBER(10) PRIMARY KEY,
    sku VARCHAR2(20) NOT NULL UNIQUE,
    product_name VARCHAR2(60) NOT NULL,
    price NUMBER(10,2) NOT NULL,
    stock NUMBER(10) DEFAULT 0 NOT NULL,

    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
);

-- 3. Create Orders table
CREATE TABLE Orders (
    order_id NUMBER(10) PRIMARY KEY,
    customer_id NUMBER(10) NOT NULL,
    product_id NUMBER(10) NOT NULL,
    quantity NUMBER(10) NOT NULL,
    order_status VARCHAR2(12) DEFAULT 'Pending' NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT fk_order_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id),

    CONSTRAINT chk_quantity CHECK (quantity > 0),

    CONSTRAINT chk_status CHECK (
        order_status IN ('Pending', 'Confirmed', 'Cancelled')
    )
);

-- 4. Insert Customers
INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES (201, 'Asha', 'asha@example.com', 'Chennai');

INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES (202, 'Bala', 'bala@example.com', 'Hyderabad');

INSERT INTO Customers
(customer_id, customer_name, email, city)
VALUES (203, 'Charu', 'charu@example.com', 'Bengaluru');

-- 5. Insert Products
INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES (301, 'KB-01', 'Keyboard', 850, 25);

INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES (302, 'MS-02', 'Mouse', 450, 40);

INSERT INTO Products
(product_id, sku, product_name, price, stock)
VALUES (303, 'HD-03', 'Hard Drive', 4200, 10);

-- 6. Insert Orders
INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES (401, 201, 301, 2, 'Pending');

INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES (402, 202, 302, 3, 'Confirmed');

INSERT INTO Orders
(order_id, customer_id, product_id, quantity, order_status)
VALUES (403, 203, 303, 1, 'Pending');

COMMIT;

-- 7. Test DEFAULT city
INSERT INTO Customers (customer_id, customer_name, email)
VALUES (204, 'Deepa', 'deepa@example.com');

SELECT customer_id, customer_name, city
FROM Customers
WHERE customer_id = 204;

COMMIT;

-- 8. Test PRIMARY KEY violation
-- Expected to fail: duplicate customer_id.
-- Run separately:
-- INSERT INTO Customers
-- VALUES (201, 'Duplicate', 'duplicate@example.com', 'Delhi');

-- 9. Test UNIQUE violation
-- Expected to fail: duplicate email.
-- INSERT INTO Customers
-- VALUES (205, 'Esha', 'asha@example.com', 'Mumbai');

-- 10. Test NOT NULL violation
-- Expected to fail: customer_name cannot be NULL.
-- INSERT INTO Customers (customer_id, customer_name, email)
-- VALUES (205, NULL, 'esha@example.com');

-- 11. Test CHECK price violation
-- Expected to fail: price must be positive.
-- INSERT INTO Products
-- VALUES (304, 'BAD-04', 'Invalid Product', -10, 5);

-- 12. Test CHECK quantity violation
-- Expected to fail: quantity must be positive.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity)
-- VALUES (404, 201, 301, 0);

-- 13. Test FOREIGN KEY violation
-- Expected to fail: customer 999 does not exist.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity)
-- VALUES (404, 999, 301, 1);

-- 14. Test CHECK status violation
-- Expected to fail: Shipped is not an approved status.
-- INSERT INTO Orders
-- (order_id, customer_id, product_id, quantity, order_status)
-- VALUES (404, 201, 301, 1, 'Shipped');

-- 15. Display Customers
SELECT customer_id, customer_name, email, city
FROM Customers
ORDER BY customer_id;

-- 16. Display Products
SELECT * FROM Products
ORDER BY product_id;

-- 17. Display Orders
SELECT order_id, customer_id, product_id,
       quantity, order_status, order_date
FROM Orders
ORDER BY order_id;

-- 18. Display Orders with Customer Names
SELECT O.order_id, C.customer_name,
       P.product_name, O.quantity, O.order_status
FROM Orders O
JOIN Customers C ON O.customer_id = C.customer_id
JOIN Products P ON O.product_id = P.product_id
ORDER BY O.order_id;

-- 19. Inspect table structures
DESC Customers;
DESC Products;
DESC Orders;

-- 20. Verify record counts
SELECT COUNT(*) AS Total_Customers FROM Customers;
SELECT COUNT(*) AS Total_Products FROM Products;
SELECT COUNT(*) AS Total_Orders FROM Orders;
