-- ======================================================================
-- Successful Lower Priced Product
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2068
-- URL        : https://platform.stratascratch.com/coding/2068-find-products
-- ======================================================================

/*
The sales department wants to identify lower-priced products that still sell well.




Find product IDs that meet both of the following criteria:

⦁    The product has been sold at least twice (i.e., appeared in at least two different purchases).

⦁    The unit-weighted average sale price (cost_in_dollars) for that product is at least $3. A unit-weighted average sales price is defined as the total revenue for the product divided by the total number of units sold.




Return a list containing product IDs along with their corresponding brand name.
*/

-- Tables:
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH product_stats AS (
    SELECT
        product_id,
        COUNT(*)                                        AS num_purchases,
        SUM(cost_in_dollars * units_sold)::NUMERIC
            / NULLIF(SUM(units_sold), 0)                AS weighted_avg_price
    FROM purchases
    GROUP BY product_id
)
SELECT
    ps.product_id,
    p.brand
FROM product_stats ps
JOIN products p
    ON ps.product_id = p.id
WHERE ps.num_purchases >= 2
  AND ps.weighted_avg_price >= 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    pur.product_id,
    pro.brand
FROM purchases pur
JOIN products pro
    ON pur.product_id = pro.id
GROUP BY pur.product_id, pro.brand
HAVING COUNT(*) >= 2
   AND (SUM(pur.cost_in_dollars * pur.units_sold) / SUM(pur.units_sold)) >= 3;
