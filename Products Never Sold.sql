-- ======================================================================
-- Products Never Sold
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2122
-- URL        : https://platform.stratascratch.com/coding/2122-products-never-sold
-- ======================================================================

/*
The VP of Sales feels that some product categories don't sell and can be completely removed from the inventory.




As a first pass analysis, they want you to find what percentage of product categories have never been sold.
*/

-- Tables:
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)
--   online_product_categories(category_id bigint, category_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH category_sales AS (
    SELECT 
        c.category_id,
        COUNT(od.order_id) AS total_orders
    FROM categories c
    LEFT JOIN products p ON c.category_id = p.category_id
    LEFT JOIN order_details od ON p.product_id = od.product_id
    GROUP BY c.category_id
)
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN total_orders = 0 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_never_sold
FROM category_sales;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    ROUND(
        100.0 * (
            SELECT COUNT(*)
            FROM categories c
            WHERE c.category_id NOT IN (
                SELECT DISTINCT p.category_id
                FROM products p
                WHERE p.category_id IS NOT NULL
                  AND p.product_id IN (
                      SELECT product_id
                      FROM order_details
                  )
            )
        ) / (SELECT COUNT(*) FROM categories),
        2
    ) AS pct_never_sold;
