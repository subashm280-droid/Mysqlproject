-- Sample Superstore SQL final project
-- Import the dataset into Samplesuperstore as a table named `superstore`
-- before running these queries. Column names follow the standard Sample
-- Superstore CSV headers.

USE Samplesuperstore;

-- 1. Display the Order ID, Customer Name, Segment, and Sales for all orders.
SELECT `Order ID`, `Customer Name`, Segment, Sales
FROM superstore;

-- 2. Display all orders arranged by Order Date from newest to oldest.
SELECT *
FROM superstore
ORDER BY `Order Date` DESC;

-- 3. Find all different Ship Modes available in the dataset.
SELECT DISTINCT `Ship Mode`
FROM superstore
ORDER BY `Ship Mode`;

-- 4. Find all orders belonging to the Corporate segment.
SELECT *
FROM superstore
WHERE Segment = 'Corporate';

-- 5. Find orders where Sales are between 100 and 500, inclusive.
SELECT *
FROM superstore
WHERE Sales BETWEEN 100 AND 500;

-- 6. Find orders where Discount is exactly 10%.
SELECT *
FROM superstore
WHERE Discount = 0.10;

-- 7. Find all orders that resulted in a loss.
SELECT *
FROM superstore
WHERE Profit < 0;

-- 8. Find orders shipped using First Class or Same Day.
SELECT *
FROM superstore
WHERE `Ship Mode` IN ('First Class', 'Same Day');

-- 9. Find customers whose names contain the word "Smith".
SELECT DISTINCT `Customer Name`
FROM superstore
WHERE `Customer Name` LIKE '%Smith%';

-- 10. Find orders where Quantity is greater than 5 and Discount is less than 20%.
SELECT *
FROM superstore
WHERE Quantity > 5
  AND Discount < 0.20;

-- 11. Calculate the total number of distinct orders and total quantity sold.
SELECT COUNT(DISTINCT `Order ID`) AS total_orders,
       SUM(Quantity) AS total_quantity_sold
FROM superstore;

-- 12. Find the minimum, maximum, and average Sales.
SELECT MIN(Sales) AS minimum_sales,
       MAX(Sales) AS maximum_sales,
       AVG(Sales) AS average_sales
FROM superstore;

-- 13. Calculate total Sales for each Ship Mode.
SELECT `Ship Mode`,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Ship Mode`
ORDER BY total_sales DESC;

-- 14. Calculate the number of distinct orders for each Customer Segment.
SELECT Segment,
       COUNT(DISTINCT `Order ID`) AS order_count
FROM superstore
GROUP BY Segment
ORDER BY order_count DESC;

-- 15. Find Categories having an average Profit greater than 50.
SELECT Category,
       AVG(Profit) AS average_profit
FROM superstore
GROUP BY Category
HAVING AVG(Profit) > 50
ORDER BY average_profit DESC;

-- 16. Find the 5 most profitable products by total Profit.
SELECT `Product Name`,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 5;

-- 17. Find the 10 least profitable orders by total Profit per Order ID.
SELECT `Order ID`,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Order ID`
ORDER BY total_profit ASC
LIMIT 10;

-- 18. Classify each row as High, Medium, or Low Sales.
-- Example bands: High >= 500; Medium >= 100 and < 500; Low < 100.
SELECT `Order ID`,
       Sales,
       CASE
           WHEN Sales >= 500 THEN 'High'
           WHEN Sales >= 100 THEN 'Medium'
           ELSE 'Low'
       END AS sales_category
FROM superstore;

-- 19. Calculate the average discount for each Category.
SELECT Category,
       AVG(Discount) AS average_discount
FROM superstore
GROUP BY Category
ORDER BY average_discount DESC;

-- 20. Find the State with the highest total Profit.
SELECT State,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY State
ORDER BY total_profit DESC
LIMIT 1;

-- 21. Use a CTE to display Regions with total Sales above 100,000.
WITH regional_sales AS (
    SELECT Region,
           SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Region
)
SELECT Region,
       total_sales
FROM regional_sales
WHERE total_sales > 100000
ORDER BY total_sales DESC;

-- 22. Rank Categories based on their total Sales.
WITH category_sales AS (
    SELECT Category,
           SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Category
)
SELECT Category,
       total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM category_sales;

-- 23. Calculate the percentage of total Profit contributed by each Region.
WITH regional_profit AS (
    SELECT Region,
           SUM(Profit) AS total_profit
    FROM superstore
    GROUP BY Region
)
SELECT Region,
       total_profit,
       ROUND(
           100.0 * total_profit
           / NULLIF(SUM(total_profit) OVER (), 0),
           2
       ) AS percent_of_total_profit
FROM regional_profit
ORDER BY total_profit DESC;

-- 24. Find the top 2 products by Sales within each Category (ties are included).
WITH product_category_sales AS (
    SELECT Category,
           `Product Name`,
           SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Category, `Product Name`
),
ranked_products AS (
    SELECT Category,
           `Product Name`,
           total_sales,
           RANK() OVER (
               PARTITION BY Category
               ORDER BY total_sales DESC
           ) AS sales_rank
    FROM product_category_sales
)
SELECT Category,
       `Product Name`,
       total_sales,
       sales_rank
FROM ranked_products
WHERE sales_rank <= 2
ORDER BY Category, sales_rank, `Product Name`;

-- 25. Find high-sales, loss-making Sub-Categories.
-- "High sales" means above the average total Sales across Sub-Categories.
WITH subcategory_performance AS (
    SELECT `Sub-Category`,
           SUM(Sales) AS total_sales,
           SUM(Profit) AS total_profit
    FROM superstore
    GROUP BY `Sub-Category`
),
performance_with_average AS (
    SELECT `Sub-Category`,
           total_sales,
           total_profit,
           AVG(total_sales) OVER () AS average_subcategory_sales
    FROM subcategory_performance
)
SELECT `Sub-Category`,
       total_sales,
       total_profit,
       average_subcategory_sales
FROM performance_with_average
WHERE total_sales > average_subcategory_sales
  AND total_profit < 0
ORDER BY total_sales DESC;
