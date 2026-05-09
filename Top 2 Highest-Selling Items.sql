-- ======================================================================
-- Top 2 Highest-Selling Items
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10555
-- URL        : https://platform.stratascratch.com/coding/10555-top-2-highest-selling-items
-- ======================================================================

/*
Management wants to identify the most popular products within each category to optimize inventory and marketing strategies. Find the top 2 products with the highest total quantity sold in each category. If products within a category have the same total quantity, order them alphabetically by product name and assign consecutive ranks (1, 2, 3, etc.).




For example, if two products in the Electronics category both sold 15 units, then iPad Pro would get rank 1 (alphabetically first) and iPhone 14 would get rank 2 (alphabetically second).




Return the category, product name, total quantity sold, and rank within category. You should expect maximum 2 products per category in your results, though some categories might only have 1 product available.
*/

-- Tables:
--   ecommerce_transactions(category text, customer_id text, price double precision, product_name text, quantity bigint, txn_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH product_sales AS (
    -- Aggregate total quantity sold per product and category
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    -- Assign rank within each category ordered by quantity desc, then name asc
    SELECT
        category,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_quantity DESC, product_name ASC
        ) AS rank_within_category
    FROM product_sales
)
SELECT
    category,
    product_name,
    total_quantity,
    rank_within_category AS rank
FROM ranked_products
WHERE rank_within_category <= 2
ORDER BY category, rank_within_category;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ps.category,
    ps.product_name,
    ps.total_quantity,
    -- Count how many products in the same category rank above this one
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT
                p2.category,
                p2.product_name,
                SUM(oi2.quantity) AS total_quantity
            FROM products p2
            JOIN order_items oi2 ON p2.product_id = oi2.product_id
            GROUP BY p2.category, p2.product_name
        ) AS other_sales
        WHERE other_sales.category = ps.category
          AND (
              -- Ranks above if higher quantity, or same quantity but alphabetically before
              other_sales.total_quantity > ps.total_quantity
              OR (
                  other_sales.total_quantity = ps.total_quantity
                  AND other_sales.product_name < ps.product_name
              )
          )
    ) AS rank
FROM (
    -- Aggregate total quantity per product and category
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
) AS ps
WHERE (
    -- Keep only products where fewer than 2 others outrank them
    SELECT COUNT(*) + 1
    FROM (
        SELECT
            p2.category,
            p2.product_name,
            SUM(oi2.quantity) AS total_quantity
        FROM products p2
        JOIN order_items oi2 ON p2.product_id = oi2.product_id
        GROUP BY p2.category, p2.product_name
    ) AS other_sales
    WHERE other_sales.category = ps.category
      AND (
          other_sales.total_quantity > ps.total_quantity
          OR (
              other_sales.total_quantity = ps.total_quantity
              AND other_sales.product_name < ps.product_name
          )
      )
) <= 2
ORDER BY ps.category, rank;
