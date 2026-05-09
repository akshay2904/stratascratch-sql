-- ======================================================================
-- Stock Codes with Prices Above Average
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2164
-- URL        : https://platform.stratascratch.com/coding/2164-stock-codes-with-prices-above-average
-- ======================================================================

/*
You are given a dataset of online transactions, and your task is to identify product codes whose unit prices are greater than the average unit price of sold products.




•   The unit price should be the original price (i.e., the minimum unit price for each product code).

•   The average unit price should be computed based on the unique product codes and their original prices.




Your output should contain productcode and unitprice (the original price).
*/

-- Tables:
--   online_retails(invoicedate text, invoiceno bigint, productcode text, quantity bigint, unitprice double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH product_original_prices AS (
    -- Get the minimum (original) unit price for each product code
    SELECT 
        productcode,
        MIN(unitprice) AS unitprice
    FROM transactions
    GROUP BY productcode
),
avg_price AS (
    -- Compute average unit price across unique product codes and their original prices
    SELECT AVG(unitprice) AS avg_unit_price
    FROM product_original_prices
)
SELECT 
    p.productcode,
    p.unitprice
FROM product_original_prices p
CROSS JOIN avg_price a
WHERE p.unitprice > a.avg_unit_price
ORDER BY p.unitprice DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    productcode,
    MIN(unitprice) AS unitprice
FROM transactions
GROUP BY productcode
HAVING MIN(unitprice) > (
    -- Subquery: average of the minimum unit prices per product code
    SELECT AVG(min_price)
    FROM (
        SELECT 
            productcode,
            MIN(unitprice) AS min_price
        FROM transactions
        GROUP BY productcode
    ) AS product_min_prices
)
ORDER BY MIN(unitprice) DESC;
