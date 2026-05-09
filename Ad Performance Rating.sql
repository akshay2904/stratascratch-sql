-- ======================================================================
-- Ad Performance Rating
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Accenture
-- Access     : Premium
-- ID         : 2155
-- URL        : https://platform.stratascratch.com/coding/2155-ad-performance-rating
-- ======================================================================

/*
Following a recent advertising campaign, the marketing department wishes to classify its efforts based on the total number of units sold for each product.




You have been tasked with calculating the total number of units sold for each product and categorizing ad performance based on the following criteria for items sold:




Outstanding: 30+

Satisfactory: 20 - 29

Unsatisfactory: 10 - 19

Poor: 1 - 9




Your output should contain the product ID, total units sold in descending order, and its categorized ad performance.
*/

-- Tables:
--   marketing_campaign(created_at date, price bigint, product_id bigint, quantity bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH product_sales AS (
    SELECT
        product_id,
        SUM(units_sold) AS total_units_sold
    FROM sales
    GROUP BY product_id
)
SELECT
    product_id,
    total_units_sold,
    CASE
        WHEN total_units_sold >= 30 THEN 'Outstanding'
        WHEN total_units_sold >= 20 THEN 'Satisfactory'
        WHEN total_units_sold >= 10 THEN 'Unsatisfactory'
        WHEN total_units_sold >= 1  THEN 'Poor'
    END AS ad_performance
FROM product_sales
ORDER BY total_units_sold DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS total_units_sold,
    CASE
        WHEN SUM(units_sold) >= 30 THEN 'Outstanding'
        WHEN SUM(units_sold) >= 20 THEN 'Satisfactory'
        WHEN SUM(units_sold) >= 10 THEN 'Unsatisfactory'
        WHEN SUM(units_sold) >= 1  THEN 'Poor'
    END AS ad_performance
FROM sales
GROUP BY product_id
ORDER BY total_units_sold DESC;
