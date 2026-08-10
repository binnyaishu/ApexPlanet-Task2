-- ============================================================
-- ApexPlanet Data Analytics Internship — Task 2
-- SQL for Business Questions
-- Database: apexplanet_sales.db (SQLite)
-- Tables: customers, products, orders
-- ============================================================

-- Q1: What are the top 5 products by total revenue?
SELECT
    p.Product,
    p.Category,
    SUM(o.Total_Sales) AS Total_Revenue,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product, p.Category
ORDER BY Total_Revenue DESC
LIMIT 5;


-- Q2: What is the monthly revenue trend across the dataset period?
SELECT
    strftime('%Y-%m', o.Order_Date) AS Order_Month,
    SUM(o.Total_Sales) AS Monthly_Revenue,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
GROUP BY Order_Month
ORDER BY Order_Month;


-- Q3: Which city generates the highest average order value?
-- Note: City is captured per-order (order/delivery city), not a fixed customer
-- attribute — 46 customers in this dataset ordered from more than one city.
SELECT
    o.City,
    ROUND(AVG(o.Total_Sales), 2) AS Avg_Order_Value,
    SUM(o.Total_Sales) AS Total_Revenue,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
WHERE o.City != 'Unknown'
GROUP BY o.City
ORDER BY Avg_Order_Value DESC;


-- Q4: What percentage of total revenue comes from each product category?
SELECT
    p.Category,
    SUM(o.Total_Sales) AS Category_Revenue,
    ROUND(100.0 * SUM(o.Total_Sales) / (SELECT SUM(Total_Sales) FROM orders), 2) AS Pct_Of_Total_Revenue
FROM orders o
JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Category_Revenue DESC;


-- Q5: Who are the top 10 customers by total spend?
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(o.Order_ID) AS Num_Orders,
    COUNT(DISTINCT o.City) AS Num_Cities_Ordered_From,
    SUM(o.Total_Sales) AS Total_Spend
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Spend DESC
LIMIT 10;


-- Q6: What is the average order value by age group and gender?
SELECT
    CASE
        WHEN c.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN c.Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56-65'
    END AS Age_Group,
    c.Gender,
    ROUND(AVG(o.Total_Sales), 2) AS Avg_Order_Value,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY Age_Group, c.Gender
ORDER BY Age_Group, c.Gender;


-- Q7: Which quarter had the highest number of orders and total revenue?
SELECT
    CASE
        WHEN CAST(strftime('%m', o.Order_Date) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN CAST(strftime('%m', o.Order_Date) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN CAST(strftime('%m', o.Order_Date) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS Quarter,
    strftime('%Y', o.Order_Date) AS Year,
    COUNT(o.Order_ID) AS Num_Orders,
    SUM(o.Total_Sales) AS Total_Revenue
FROM orders o
GROUP BY Year, Quarter
ORDER BY Total_Revenue DESC;
