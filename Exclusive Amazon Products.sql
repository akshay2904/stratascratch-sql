-- ======================================================================
-- Exclusive Amazon Products
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 9608
-- URL        : https://platform.stratascratch.com/coding/9608-exclusive-amazon-products
-- ======================================================================

/*
Find products which are exclusive to only Amazon and therefore not sold at Top Shop and Macy's. Your output should include the product name, brand name, price, and rating.




Two products are considered equal if they have the same product name and same maximum retail price (mrp column).
*/

-- Tables:
--   innerwear_macys_com(available_size text, brand_name text, color text, description text, mrp text, pdp_url text, price text, product_category text, product_name text, rating double precision, retailer text, review_count double precision, style_attributes text, total_sizes text)
--   innerwear_topshop_com(available_size text, brand_name text, color text, description text, mrp text, pdp_url text, price text, product_category text, product_name text, rating double precision, retailer text, review_count double precision, style_attributes text, total_sizes text)
--   innerwear_amazon_com(available_size text, brand_name text, color text, description text, mrp text, pdp_url text, price text, product_category text, product_name text, rating double precision, retailer text, review_count bigint, style_attributes text, total_sizes text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH amazon_products AS (
    SELECT DISTINCT product_name, mrp, brand_name, price, rating
    FROM products
    WHERE website = 'amazon'
),
other_store_products AS (
    SELECT DISTINCT product_name, mrp
    FROM products
    WHERE website IN ('topshop', 'macys')
)
SELECT ap.product_name, ap.brand_name, ap.price, ap.rating
FROM amazon_products ap
LEFT JOIN other_store_products osp
    ON ap.product_name = osp.product_name
    AND ap.mrp = osp.mrp
WHERE osp.product_name IS NULL;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    p.product_name,
    p.brand_name,
    p.price,
    p.rating
FROM products p
WHERE p.website = 'amazon'
  AND p.product_name NOT IN (
      SELECT product_name
      FROM products
      WHERE website IN ('topshop', 'macys')
        AND mrp IN (
            SELECT mrp
            FROM products p2
            WHERE p2.product_name = p.product_name
              AND p2.website = 'amazon'
        )
  );
