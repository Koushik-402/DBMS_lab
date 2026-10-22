-- EXPERIMENT 06: SQL Aggregate Functions, GROUP BY and HAVING
-- Case Study: Retail Sales Analysis
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS RetailSalesDB;
USE RetailSalesDB;

CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Product_Name VARCHAR(40) NOT NULL,
    Category VARCHAR(25) NOT NULL,
    Region VARCHAR(20) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Price DECIMAL(10,2) NOT NULL CHECK (Unit_Price >= 0)
);

-- Insert 12 sales records
INSERT INTO Sales VALUES
(1, 'Laptop', 'Electronics', 'South', 2, 45000),
(2, 'Mouse', 'Electronics', 'North', 10, 600),
(3, 'Chair', 'Furniture', 'South', 4, 3500),
(4, 'Desk', 'Furniture', 'East', 3, 8000),
(5, 'Notebook', 'Stationery', 'West', 20, 80),
(6, 'Pen', 'Stationery', 'North', 50, 20),
(7, 'Monitor', 'Electronics', 'East', 5, 12000),
(8, 'Chair', 'Furniture', 'North', 6, 3200),
(9, 'Notebook', 'Stationery', 'South', 30, 75),
(10, 'Keyboard', 'Electronics', 'West', 8, 1200),
(11, 'Desk', 'Furniture', 'West', 2, 8500),
(12, 'Pen', 'Stationery', 'East', 40, 25);

-- Query 1: Count total sales records
SELECT COUNT(*) AS Total_Records
FROM Sales;

-- Query 2: Total units sold
SELECT SUM(Quantity) AS Total_Units
FROM Sales;

-- Query 3: Total sales revenue
SELECT SUM(Quantity * Unit_Price) AS Total_Revenue
FROM Sales;

-- Query 4: Average unit price
SELECT ROUND(AVG(Unit_Price), 2) AS Avg_Price
FROM Sales;

-- Query 5: Lowest and highest unit prices
SELECT MIN(Unit_Price) AS Lowest_Price,
       MAX(Unit_Price) AS Highest_Price
FROM Sales;

-- Query 6: Count distinct categories
SELECT COUNT(DISTINCT Category) AS Categories
FROM Sales;

-- Query 7: Number of sales records per category
SELECT Category, COUNT(*) AS Sale_Records
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 8: Units sold per category
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 9: Revenue per category
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 10: Revenue per region
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
ORDER BY Revenue DESC, Region;

-- Query 11: Categories with more than 20 units sold
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
HAVING SUM(Quantity) > 20
ORDER BY Category;

-- Query 12: Regions with revenue above 30000
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- Query 13: WHERE and HAVING
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
WHERE Region IN ('North', 'South')
GROUP BY Category
HAVING SUM(Quantity) >= 10
ORDER BY Category;

-- Query 14: Group by category and region
SELECT Category, Region, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category, Region
ORDER BY Category, Region;

-- Query 15: Category with the highest revenue
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC, Category
LIMIT 1;

-- Query 16: Average quantity per category
SELECT Category, ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Verification query
SELECT COUNT(*) AS Transactions,
       SUM(Quantity) AS Units,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales;

-- PRACTICE EXERCISES

-- 1. Total sales records for North region
SELECT COUNT(*) AS North_Transactions
FROM Sales
WHERE Region = 'North';

-- 2. Total quantity of Furniture sold
SELECT SUM(Quantity) AS Furniture_Units
FROM Sales
WHERE Category = 'Furniture';

-- 3. Average unit price of Electronics
SELECT ROUND(AVG(Unit_Price), 2) AS Electronics_Avg_Price
FROM Sales
WHERE Category = 'Electronics';

-- 4. Minimum and maximum quantity sold
SELECT MIN(Quantity) AS Min_Quantity,
       MAX(Quantity) AS Max_Quantity
FROM Sales;

-- 5. Transaction count for each region
SELECT Region, COUNT(*) AS Transaction_Count
FROM Sales
GROUP BY Region
ORDER BY Region;

-- 6. Total revenue for each product
SELECT Product_Name,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Product_Name
ORDER BY Product_Name;

-- 7. Categories with revenue exceeding 30000
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- 8. Regions with more than 20 units sold
SELECT Region, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Region
HAVING SUM(Quantity) > 20
ORDER BY Region;

-- 9. Average quantity per region, highest first
SELECT Region, ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM Sales
GROUP BY Region
ORDER BY Avg_Quantity DESC;

-- 10. Two categories with the highest revenue
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC, Category
LIMIT 2;


-- EXPERIMENT 06: SQL Aggregate Functions, GROUP BY and HAVING
-- Case Study: Retail Sales Analysis
-- Oracle Database

CREATE TABLE Sales (
    Sale_ID NUMBER(10) PRIMARY KEY,
    Product_Name VARCHAR2(40) NOT NULL,
    Category VARCHAR2(25) NOT NULL,
    Region VARCHAR2(20) NOT NULL,
    Quantity NUMBER(10) NOT NULL CHECK (Quantity > 0),
    Unit_Price NUMBER(10,2) NOT NULL CHECK (Unit_Price >= 0)
);

-- Insert 12 sales records
INSERT ALL
    INTO Sales VALUES (1, 'Laptop', 'Electronics', 'South', 2, 45000)
    INTO Sales VALUES (2, 'Mouse', 'Electronics', 'North', 10, 600)
    INTO Sales VALUES (3, 'Chair', 'Furniture', 'South', 4, 3500)
    INTO Sales VALUES (4, 'Desk', 'Furniture', 'East', 3, 8000)
    INTO Sales VALUES (5, 'Notebook', 'Stationery', 'West', 20, 80)
    INTO Sales VALUES (6, 'Pen', 'Stationery', 'North', 50, 20)
    INTO Sales VALUES (7, 'Monitor', 'Electronics', 'East', 5, 12000)
    INTO Sales VALUES (8, 'Chair', 'Furniture', 'North', 6, 3200)
    INTO Sales VALUES (9, 'Notebook', 'Stationery', 'South', 30, 75)
    INTO Sales VALUES (10, 'Keyboard', 'Electronics', 'West', 8, 1200)
    INTO Sales VALUES (11, 'Desk', 'Furniture', 'West', 2, 8500)
    INTO Sales VALUES (12, 'Pen', 'Stationery', 'East', 40, 25)
SELECT 1 FROM DUAL;

COMMIT;

-- Query 1: Count total sales records
SELECT COUNT(*) AS Total_Records
FROM Sales;

-- Query 2: Total units sold
SELECT SUM(Quantity) AS Total_Units
FROM Sales;

-- Query 3: Total sales revenue
SELECT SUM(Quantity * Unit_Price) AS Total_Revenue
FROM Sales;

-- Query 4: Average unit price
SELECT ROUND(AVG(Unit_Price), 2) AS Avg_Price
FROM Sales;

-- Query 5: Lowest and highest unit prices
SELECT MIN(Unit_Price) AS Lowest_Price,
       MAX(Unit_Price) AS Highest_Price
FROM Sales;

-- Query 6: Count distinct categories
SELECT COUNT(DISTINCT Category) AS Categories
FROM Sales;

-- Query 7: Number of sales records per category
SELECT Category, COUNT(*) AS Sale_Records
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 8: Units sold per category
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 9: Revenue per category
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Query 10: Revenue per region
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
ORDER BY Revenue DESC, Region;

-- Query 11: Categories with more than 20 units sold
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category
HAVING SUM(Quantity) > 20
ORDER BY Category;

-- Query 12: Regions with revenue above 30000
SELECT Region, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Region
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- Query 13: WHERE and HAVING
SELECT Category, SUM(Quantity) AS Units_Sold
FROM Sales
WHERE Region IN ('North', 'South')
GROUP BY Category
HAVING SUM(Quantity) >= 10
ORDER BY Category;

-- Query 14: Group by category and region
SELECT Category, Region, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Category, Region
ORDER BY Category, Region;

-- Query 15: Category with the highest revenue
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC, Category
FETCH FIRST 1 ROW ONLY;

-- Query 16: Average quantity per category
SELECT Category, ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM Sales
GROUP BY Category
ORDER BY Category;

-- Verification query
SELECT COUNT(*) AS Transactions,
       SUM(Quantity) AS Units,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales;

-- PRACTICE EXERCISES

-- 1. Total sales records for North region
SELECT COUNT(*) AS North_Transactions
FROM Sales
WHERE Region = 'North';

-- 2. Total quantity of Furniture sold
SELECT SUM(Quantity) AS Furniture_Units
FROM Sales
WHERE Category = 'Furniture';

-- 3. Average unit price of Electronics
SELECT ROUND(AVG(Unit_Price), 2) AS Electronics_Avg_Price
FROM Sales
WHERE Category = 'Electronics';

-- 4. Minimum and maximum quantity sold
SELECT MIN(Quantity) AS Min_Quantity,
       MAX(Quantity) AS Max_Quantity
FROM Sales;

-- 5. Transaction count for each region
SELECT Region, COUNT(*) AS Transaction_Count
FROM Sales
GROUP BY Region
ORDER BY Region;

-- 6. Total revenue for each product
SELECT Product_Name,
       SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Product_Name
ORDER BY Product_Name;

-- 7. Categories with revenue exceeding 30000
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
HAVING SUM(Quantity * Unit_Price) > 30000
ORDER BY Revenue DESC;

-- 8. Regions with more than 20 units sold
SELECT Region, SUM(Quantity) AS Units_Sold
FROM Sales
GROUP BY Region
HAVING SUM(Quantity) > 20
ORDER BY Region;

-- 9. Average quantity per region, highest first
SELECT Region, ROUND(AVG(Quantity), 2) AS Avg_Quantity
FROM Sales
GROUP BY Region
ORDER BY Avg_Quantity DESC;

-- 10. Two categories with the highest revenue
SELECT Category, SUM(Quantity * Unit_Price) AS Revenue
FROM Sales
GROUP BY Category
ORDER BY Revenue DESC, Category
FETCH FIRST 2 ROWS ONLY;
