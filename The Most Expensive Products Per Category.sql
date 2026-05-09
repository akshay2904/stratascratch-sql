-- ======================================================================
-- The Most Expensive Products Per Category
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 9607
-- URL        : https://platform.stratascratch.com/coding/9607-the-most-expensive-products-per-category
-- ======================================================================

/*
Find the most expensive products on Amazon for each product category. Output category, product name and the price (as a number)
*/

-- Tables:
--   innerwear_amazon_com(available_size text, brand_name text, color text, description text, mrp text, pdp_url text, price text, product_category text, product_name text, rating double precision, retailer text, review_count bigint, style_attributes text, total_sizes text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_products AS (
    SELECT
        category,
        product_name,
        -- Remove dollar sign and cast to numeric for proper price comparison
        CAST(REPLACE(price, '$', '') AS NUMERIC) AS price_num,
        RANK() OVER (
            PARTITION BY category
            ORDER BY CAST(REPLACE(price, '$', '') AS NUMERIC) DESC
        ) AS rnk
    FROM amazon_products
)
SELECT
    category,
    product_name,
    price_num AS price
FROM ranked_products
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ap.category,
    ap.product_name,
    CAST(REPLACE(ap.price, '$', '') AS NUMERIC) AS price
FROM amazon_products ap
INNER JOIN (
    SELECT
        category,
        MAX(CAST(REPLACE(price, '$', '') AS NUMERIC)) AS max_price
    FROM amazon_products
    GROUP BY category
) cat_max
    ON ap.category = cat_max.category
    AND CAST(REPLACE(ap.price, '$', '') AS NUMERIC) = cat_max.max_price;
