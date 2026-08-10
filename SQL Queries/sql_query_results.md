# SQL Query Results — ApexPlanet Sales Analysis

Database: `apexplanet_sales.db` (SQLite) — tables: `orders`, `customers`, `products`


## Q1: What are the top 5 products by total revenue?

```sql
SELECT
    p.Product,
    p.Category,
    SUM(o.Total_Sales) AS Total_Revenue,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product, p.Category
ORDER BY Total_Revenue DESC
LIMIT 5
```

| Product   | Category    |   Total_Revenue |   Num_Orders |
|:----------|:------------|----------------:|-------------:|
| Laptop    | Electronics |     2.5443e+07  |          170 |
| Mobile    | Electronics |     2.53356e+07 |          184 |
| Book      | Education   |     2.50317e+07 |          178 |
| Rice      | Grocery     |     2.22317e+07 |          153 |
| Chair     | Furniture   |     2.15216e+07 |          159 |



## Q2: What is the monthly revenue trend across the dataset period?

```sql
SELECT
    strftime('%Y-%m', o.Order_Date) AS Order_Month,
    SUM(o.Total_Sales) AS Monthly_Revenue,
    COUNT(o.Order_ID) AS Num_Orders
FROM orders o
GROUP BY Order_Month
ORDER BY Order_Month
```

| Order_Month   |   Monthly_Revenue |   Num_Orders |
|:--------------|------------------:|-------------:|
| 2025-01       |       1.00962e+07 |           76 |
| 2025-02       |       1.15112e+07 |           86 |
| 2025-03       |       1.30599e+07 |           89 |
| 2025-04       |       1.22227e+07 |           80 |
| 2025-05       |       1.09847e+07 |           85 |
| 2025-06       |       1.29123e+07 |           83 |
| 2025-07       |       1.17462e+07 |           83 |
| 2025-08       |       9.44847e+06 |           75 |
| 2025-09       |       9.1799e+06  |           79 |
| 2025-10       |       1.25009e+07 |           84 |
| 2025-11       |       1.26276e+07 |           77 |
| 2025-12       |       1.22999e+07 |           98 |
| 2026-01       |  809390           |            5 |



## Q3: Which city generates the highest average order value?

```sql
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
ORDER BY Avg_Order_Value DESC
```

| City      |   Avg_Order_Value |   Total_Revenue |   Num_Orders |
|:----------|------------------:|----------------:|-------------:|
| Bengaluru |            153882 |     1.87736e+07 |          122 |
| Pune      |            146598 |     1.45132e+07 |           99 |
| Mumbai    |            143184 |     1.87571e+07 |          131 |
| Patna     |            142859 |     1.9286e+07  |          135 |
| Kolkata   |            141988 |     1.88843e+07 |          133 |
| Hyderabad |            137334 |     1.71668e+07 |          125 |
| Delhi     |            128777 |     1.60971e+07 |          125 |
| Gaya      |            122913 |     1.43809e+07 |          117 |



## Q4: What percentage of total revenue comes from each product category?

```sql
SELECT
    p.Category,
    SUM(o.Total_Sales) AS Category_Revenue,
    ROUND(100.0 * SUM(o.Total_Sales) / (SELECT SUM(Total_Sales) FROM orders), 2) AS Pct_Of_Total_Revenue
FROM orders o
JOIN products p ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Category_Revenue DESC
```

| Category    |   Category_Revenue |   Pct_Of_Total_Revenue |
|:------------|-------------------:|-----------------------:|
| Electronics |        5.07786e+07 |                  36.43 |
| Education   |        2.50317e+07 |                  17.96 |
| Grocery     |        2.22317e+07 |                  15.95 |
| Furniture   |        2.15216e+07 |                  15.44 |
| Fashion     |        1.98359e+07 |                  14.23 |



## Q5: Who are the top 10 customers by total spend?

```sql
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
LIMIT 10
```

| Customer_ID   | Customer_Name   |   Num_Orders |   Num_Cities_Ordered_From |   Total_Spend |
|:--------------|:----------------|-------------:|--------------------------:|--------------:|
| CUST9510      | Customer_345    |            2 |                         2 |        867333 |
| CUST6845      | Customer_337    |            2 |                         2 |        769480 |
| CUST6532      | Customer_348    |            2 |                         2 |        610982 |
| CUST6082      | Customer_301    |            2 |                         1 |        548416 |
| CUST3689      | Customer_179    |            2 |                         2 |        542484 |
| CUST3730      | Customer_273    |            2 |                         2 |        538634 |
| CUST4706      | Customer_34     |            2 |                         2 |        528036 |
| CUST9693      | Customer_343    |            2 |                         2 |        511422 |
| CUST7374      | Customer_375    |            2 |                         2 |        511309 |
| CUST2062      | Customer_254    |            1 |                         1 |        493678 |



## Q6: What is the average order value by age group and gender?

```sql
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
ORDER BY Age_Group, c.Gender
```

| Age_Group   | Gender   |   Avg_Order_Value |   Num_Orders |
|:------------|:---------|------------------:|-------------:|
| 18-25       | Female   |            159505 |           75 |
| 18-25       | Male     |            129677 |           83 |
| 26-35       | Female   |            111512 |           99 |
| 26-35       | Male     |            152953 |          123 |
| 36-45       | Female   |            139234 |          123 |
| 36-45       | Male     |            148508 |          101 |
| 46-55       | Female   |            137482 |           88 |
| 46-55       | Male     |            132194 |          110 |
| 56-65       | Female   |            138730 |          106 |
| 56-65       | Male     |            145111 |           92 |



## Q7: Which quarter had the highest number of orders and total revenue?

```sql
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
ORDER BY Total_Revenue DESC
```

| Quarter   |   Year |   Num_Orders |    Total_Revenue |
|:----------|-------:|-------------:|-----------------:|
| Q4        |   2025 |          259 |      3.74285e+07 |
| Q2        |   2025 |          248 |      3.61197e+07 |
| Q1        |   2025 |          251 |      3.46673e+07 |
| Q3        |   2025 |          237 |      3.03746e+07 |
| Q1        |   2026 |            5 | 809390           |

