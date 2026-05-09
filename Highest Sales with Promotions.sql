-- ======================================================================
-- Highest Sales with Promotions
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2121
-- URL        : https://platform.stratascratch.com/coding/2121-highest-sales-with-promotions
-- ======================================================================

/*
The marketing department is assessing the success of their promotional campaigns.




You have been asked to find which products sold the most units for each promotion.




Your output should contain the promotion ID, product ID, and corresponding total units sold for the most successful product ID. In the case of a tie, output all results.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_sales AS (
    SELECT
        promotion_id,
        product_id,
        SUM(quantity_sold) AS total_units_sold,
        RANK() OVER (
            PARTITION BY promotion_id
            ORDER BY SUM(quantity_sold) DESC
        ) AS rnk
    FROM sales
    GROUP BY promotion_id, product_id
)
SELECT
    promotion_id,
    product_id,
    total_units_sold
FROM ranked_sales
WHERE rnk = 1
ORDER BY promotion_id, product_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH product_promo_sales AS (
    SELECT
        promotion_id,
        product_id,
        SUM(quantity_sold) AS total_units_sold
    FROM sales
    GROUP BY promotion_id, product_id
),
max_per_promo AS (
    SELECT
        promotion_id,
        MAX(total_units_sold) AS max_units
    FROM product_promo_sales
    GROUP BY promotion_id
)
SELECT
    pps.promotion_id,
    pps.product_id,
    pps.total_units_sold
FROM product_promo_sales pps
JOIN max_per_promo mpp
    ON pps.promotion_id = mpp.promotion_id
    AND pps.total_units_sold = mpp.max_units
ORDER BY pps.promotion_id, pps.product_id;
