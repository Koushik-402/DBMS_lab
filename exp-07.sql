-- EXPERIMENT 07: VIEWS, AUTO_INCREMENT, INDEXES AND SAVEPOINTS
-- Case Study: Inventory and Warehouse Management System
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS WarehouseDB;
USE WarehouseDB;

-- Create Product table
CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(60) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Unit_Price DECIMAL(10,2) NOT NULL,
    Stock_Qty INT NOT NULL,
    Warehouse VARCHAR(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1001;

-- Insert eight sample products
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES
('Keyboard', 'Electronics', 800, 40, 'Chennai'),
('Mouse', 'Electronics', 450, 12, 'Chennai'),
('Office Chair', 'Furniture', 4500, 8, 'Bengaluru'),
('Desk', 'Furniture', 7200, 15, 'Chennai'),
('Notebook', 'Stationery', 60, 100, 'Hyderabad'),
('Pen Pack', 'Stationery', 120, 25, 'Hyderabad'),
('Monitor', 'Electronics', 12500, 6, 'Bengaluru'),
('Printer', 'Electronics', 9500, 4, 'Chennai');

-- Query 1: Create product catalog view
CREATE VIEW vw_product_catalog AS
SELECT Product_ID, Product_Name, Category, Unit_Price
FROM Product;

-- Query 2: Display product catalog
SELECT *
FROM vw_product_catalog
ORDER BY Product_ID;

-- Query 3: Create low-stock view
CREATE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Stock_Qty
FROM Product
WHERE Stock_Qty < 10;

-- Query 4: Display low-stock products
SELECT *
FROM vw_low_stock
ORDER BY Product_ID;

-- Query 5: Replace low-stock view
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Category, Stock_Qty
FROM Product
WHERE Stock_Qty <= 12;

-- Display updated low-stock view
SELECT *
FROM vw_low_stock
ORDER BY Product_ID;

-- Query 6: Insert a product with an automatic ID
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES ('Webcam', 'Electronics', 2200, 18, 'Chennai');

-- Display the generated ID
SELECT LAST_INSERT_ID() AS New_Product_ID;

-- Query 7: Create an index on Category
CREATE INDEX idx_product_category
ON Product(Category);

-- Query 8: Inspect indexes
SHOW INDEX FROM Product;

-- Query 9: Examine the query execution plan
EXPLAIN
SELECT *
FROM Product
WHERE Category = 'Electronics';

-- Query 10: Demonstrate SAVEPOINT
START TRANSACTION;

UPDATE Product
SET Stock_Qty = Stock_Qty - 5
WHERE Product_ID = 1001;

SAVEPOINT sp_after_keyboard;

UPDATE Product
SET Stock_Qty = Stock_Qty - 3
WHERE Product_ID = 1002;

-- Check stock before rollback
SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 11: Roll back to savepoint
ROLLBACK TO SAVEPOINT sp_after_keyboard;

-- Check stock after partial rollback
SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 12: Commit retained changes
COMMIT;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 13: Demonstrate full rollback
START TRANSACTION;

UPDATE Product
SET Stock_Qty = 0
WHERE Product_ID = 1003;

ROLLBACK;

-- Office Chair stock should remain 8
SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID = 1003;

-- Query 14: Drop the secondary index
DROP INDEX idx_product_category ON Product;

-- Verify indexes
SHOW INDEX FROM Product;

-- Final verification
SELECT COUNT(*) AS Total_Products
FROM Product;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002, 1003);

SHOW FULL TABLES IN WarehouseDB;

-- ==========================================
-- STUDENT PRACTICE EXERCISES
-- ==========================================

-- 1. Create a view for Electronics products
CREATE VIEW vw_electronics AS
SELECT *
FROM Product
WHERE Category = 'Electronics';

SELECT * FROM vw_electronics;

-- 2. Create a view showing total inventory value
CREATE VIEW vw_inventory_value AS
SELECT Product_ID, Product_Name,
       Unit_Price, Stock_Qty,
       Unit_Price * Stock_Qty AS Inventory_Value
FROM Product;

SELECT * FROM vw_inventory_value;

-- 3. Display catalog in descending price order
SELECT *
FROM vw_product_catalog
ORDER BY Unit_Price DESC;

-- 4. Create a view for Chennai warehouse products
CREATE VIEW vw_chennai_products AS
SELECT *
FROM Product
WHERE Warehouse = 'Chennai';

SELECT * FROM vw_chennai_products;

-- 5. Insert a product without specifying Product_ID
INSERT INTO Product
(Product_Name, Category, Unit_Price, Stock_Qty, Warehouse)
VALUES ('USB Cable', 'Electronics', 250, 20, 'Chennai');

SELECT LAST_INSERT_ID() AS Generated_Product_ID;

-- 6. Create an index on Warehouse
CREATE INDEX idx_product_warehouse
ON Product(Warehouse);

SHOW INDEX FROM Product;

-- 7. Examine a query filtering by Warehouse
EXPLAIN
SELECT *
FROM Product
WHERE Warehouse = 'Chennai';

-- 8. Reduce Printer stock, save a point, then reduce Monitor stock
START TRANSACTION;

UPDATE Product
SET Stock_Qty = Stock_Qty - 1
WHERE Product_Name = 'Printer';

SAVEPOINT sp_after_printer;

UPDATE Product
SET Stock_Qty = Stock_Qty - 2
WHERE Product_Name = 'Monitor';

SELECT Product_Name, Stock_Qty
FROM Product
WHERE Product_Name IN ('Printer', 'Monitor');

-- 9. Roll back changes after the savepoint
ROLLBACK TO SAVEPOINT sp_after_printer;

SELECT Product_Name, Stock


-- EXPERIMENT 07: VIEWS, SEQUENCES, INDEXES AND SAVEPOINTS
-- Oracle Database

-- Create the product ID sequence
CREATE SEQUENCE product_seq
START WITH 1001
INCREMENT BY 1
NOCACHE;

-- Create Product table
CREATE TABLE Product (
    Product_ID NUMBER PRIMARY KEY,
    Product_Name VARCHAR2(60) NOT NULL,
    Category VARCHAR2(30) NOT NULL,
    Unit_Price NUMBER(10,2) NOT NULL,
    Stock_Qty NUMBER NOT NULL,
    Warehouse VARCHAR2(30) NOT NULL
);

-- Insert eight sample products using the sequence
INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Keyboard', 'Electronics', 800, 40, 'Chennai');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Mouse', 'Electronics', 450, 12, 'Chennai');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Office Chair', 'Furniture', 4500, 8, 'Bengaluru');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Desk', 'Furniture', 7200, 15, 'Chennai');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Notebook', 'Stationery', 60, 100, 'Hyderabad');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Pen Pack', 'Stationery', 120, 25, 'Hyderabad');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Monitor', 'Electronics', 12500, 6, 'Bengaluru');

INSERT INTO Product VALUES
(product_seq.NEXTVAL, 'Printer', 'Electronics', 9500, 4, 'Chennai');

COMMIT;

-- Query 1: Create product catalog view
CREATE VIEW vw_product_catalog AS
SELECT Product_ID, Product_Name, Category, Unit_Price
FROM Product;

-- Query 2: Retrieve data from the view
SELECT *
FROM vw_product_catalog
ORDER BY Product_ID;

-- Query 3: Create low-stock view
CREATE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Stock_Qty
FROM Product
WHERE Stock_Qty < 10;

-- Query 4: Display low-stock products
SELECT *
FROM vw_low_stock
ORDER BY Product_ID;

-- Query 5: Replace the view definition
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT Product_ID, Product_Name, Category, Stock_Qty
FROM Product
WHERE Stock_Qty <= 12;

SELECT *
FROM vw_low_stock
ORDER BY Product_ID;

-- Query 6: Insert a product using the sequence
INSERT INTO Product
VALUES (product_seq.NEXTVAL, 'Webcam', 'Electronics',
        2200, 18, 'Chennai');

COMMIT;

SELECT Product_ID, Product_Name
FROM Product
WHERE Product_Name = 'Webcam';

-- Query 7: Create an index on Category
CREATE INDEX idx_product_category
ON Product(Category);

-- Query 8: Inspect indexes
SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'PRODUCT';

-- Query 9: Examine the query execution plan
EXPLAIN PLAN FOR
SELECT *
FROM Product
WHERE Category = 'Electronics';

SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Query 10: Demonstrate SAVEPOINT
SAVEPOINT sp_start;

UPDATE Product
SET Stock_Qty = Stock_Qty - 5
WHERE Product_ID = 1001;

SAVEPOINT sp_after_keyboard;

UPDATE Product
SET Stock_Qty = Stock_Qty - 3
WHERE Product_ID = 1002;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 11: Roll back to savepoint
ROLLBACK TO sp_after_keyboard;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 12: Commit retained changes
COMMIT;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002)
ORDER BY Product_ID;

-- Query 13: Demonstrate full rollback
SAVEPOINT sp_full_rollback;

UPDATE Product
SET Stock_Qty = 0
WHERE Product_ID = 1003;

ROLLBACK TO sp_full_rollback;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID = 1003;

-- Query 14: Drop the secondary index
DROP INDEX idx_product_category;

SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'PRODUCT';

-- Final verification
SELECT COUNT(*) AS Total_Products
FROM Product;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID IN (1001, 1002, 1003);

-- ==========================================
-- STUDENT PRACTICE EXERCISES
-- ==========================================

-- 1. Create a view for Electronics products
CREATE VIEW vw_electronics AS
SELECT *
FROM Product
WHERE Category = 'Electronics';

SELECT * FROM vw_electronics;

-- 2. Create a view showing inventory value
CREATE VIEW vw_inventory_value AS
SELECT Product_ID, Product_Name, Unit_Price,
       Stock_Qty, Unit_Price * Stock_Qty AS Inventory_Value
FROM Product;

SELECT * FROM vw_inventory_value;

-- 3. Display catalog in descending price order
SELECT *
FROM vw_product_catalog
ORDER BY Unit_Price DESC;

-- 4. Create a view for Chennai warehouse products
CREATE VIEW vw_chennai_products AS
SELECT *
FROM Product
WHERE Warehouse = 'Chennai';

SELECT * FROM vw_chennai_products;

-- 5. Insert a product without manually specifying its ID
INSERT INTO Product
VALUES (product_seq.NEXTVAL, 'USB Cable', 'Electronics',
        250, 20, 'Chennai');

COMMIT;

SELECT Product_ID, Product_Name
FROM Product
WHERE Product_Name = 'USB Cable';

-- 6. Create an index on Warehouse
CREATE INDEX idx_product_warehouse
ON Product(Warehouse);

SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'PRODUCT';

-- 7. Examine a query filtering by Warehouse
EXPLAIN PLAN FOR
SELECT *
FROM Product
WHERE Warehouse = 'Chennai';

SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY);

-- 8. Reduce Printer stock, save a point, then reduce Monitor stock
SAVEPOINT sp_practice_start;

UPDATE Product
SET Stock_Qty = Stock_Qty - 1
WHERE Product_Name = 'Printer';

SAVEPOINT sp_after_printer;

UPDATE Product
SET Stock_Qty = Stock_Qty - 2
WHERE Product_Name = 'Monitor';

SELECT Product_Name, Stock_Qty
FROM Product
WHERE Product_Name IN ('Printer', 'Monitor');

-- 9. Roll back changes after the savepoint
ROLLBACK TO sp_after_printer;

SELECT Product_Name, Stock_Qty
FROM Product
WHERE Product_Name IN ('Printer', 'Monitor');

COMMIT;

-- 10. Perform a full rollback of an uncommitted stock change
SAVEPOINT sp_before_full_rollback;

UPDATE Product
SET Stock_Qty = Stock_Qty + 10
WHERE Product_ID = 1001;

ROLLBACK TO sp_before_full_rollback;

SELECT Product_ID, Stock_Qty
FROM Product
WHERE Product_ID = 1001;
