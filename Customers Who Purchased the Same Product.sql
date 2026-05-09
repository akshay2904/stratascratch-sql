-- ======================================================================
-- Customers Who Purchased the Same Product
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2150
-- URL        : https://platform.stratascratch.com/coding/2150-customers-who-purchased-the-same-product
-- ======================================================================

/*
In order to improve customer segmentation efforts for users interested in purchasing furniture, you have been asked to find customers who have purchased the same items of furniture.




Output the product_id, brand_name, unique customer ID's who purchased that product, and the count of unique customer ID's who purchased that product. Arrange the output in descending order with the highest count at the top.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH furniture_purchases AS (
    SELECT DISTINCT
        oi.product_id,
        p.brand_name,
        oi.user_id
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    WHERE LOWER(p.department) = 'furniture'
),
aggregated AS (
    SELECT
        product_id,
        brand_name,
        ARRAY_AGG(user_id ORDER BY user_id) AS customer_ids,  -- unique user_ids per product
        COUNT(user_id) AS customer_count
    FROM furniture_purchases
    GROUP BY product_id, brand_name
    HAVING COUNT(user_id) > 1  -- only products purchased by more than one unique customer
)
SELECT
    product_id,
    brand_name,
    customer_ids,
    customer_count
FROM aggregated
ORDER BY customer_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    oi.product_id,
    p.brand_name,
    ARRAY_AGG(DISTINCT oi.user_id ORDER BY oi.user_id) AS customer_ids,
    COUNT(DISTINCT oi.user_id) AS customer_count
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE LOWER(p.department) = 'furniture'
GROUP BY oi.product_id, p.brand_name
HAVING COUNT(DISTINCT oi.user_id) > 1  -- only products shared by multiple customers
ORDER BY customer_count DESC;
