-- ======================================================================
-- Customer Consumable Sales Percentages
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2149
-- URL        : https://platform.stratascratch.com/coding/2149-customer-consumable-sales-percentages
-- ======================================================================

/*
Following a recent advertising campaign, you have been asked to compare the sales of consumable products across all brands.




A consumable product is defined as any product where product_family = 'CONSUMABLE'.




Do the comparison of the brands by finding the percentage of unique customers (among all customers in the dataset) who purchased consumable products of some brand and then do the calculation for each brand.




Your output should contain the brand_name and percentage_of_customers rounded to the nearest whole number and ordered in descending order.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS total
    FROM sales
),
brand_customers AS (
    SELECT 
        p.brand_name,
        COUNT(DISTINCT s.customer_id) AS unique_customers
    FROM sales s
    JOIN product p ON s.product_id = p.product_id
    WHERE p.product_family = 'CONSUMABLE'
    GROUP BY p.brand_name
)
SELECT 
    bc.brand_name,
    ROUND(bc.unique_customers * 100.0 / tc.total) AS percentage_of_customers
FROM brand_customers bc
CROSS JOIN total_customers tc
ORDER BY percentage_of_customers DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    p.brand_name,
    ROUND(
        COUNT(DISTINCT s.customer_id) * 100.0 / 
        (SELECT COUNT(DISTINCT customer_id) FROM sales)
    ) AS percentage_of_customers
FROM sales s
JOIN product p 
    ON s.product_id = p.product_id
WHERE p.product_family = 'CONSUMABLE'
GROUP BY p.brand_name
ORDER BY percentage_of_customers DESC;
