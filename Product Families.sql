-- ======================================================================
-- Product Families
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2123
-- URL        : https://platform.stratascratch.com/coding/2123-product-families
-- ======================================================================

/*
The CMO is interested in understanding how the sales of different product families are affected by promotional campaigns. To do so, for each product family, show the total number of units sold, as well as the percentage of units sold that had a valid promotion among total units sold. If there are NULLS in the result, replace them with zeroes. Promotion is valid if it's not empty and it's contained inside promotions table.
*/

-- Tables:
--   facebook_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)
--   facebook_sales_promotions(cost bigint, end_date date, media_type text, promotion_id bigint, start_date date)
--   facebook_sales(cost_in_dollars bigint, customer_id bigint, date date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH promo_sales AS (
    SELECT
        p.product_family,
        SUM(s.units_sold) AS total_units_sold,
        SUM(
            CASE
                WHEN s.promotion_id IS NOT NULL
                     AND s.promotion_id != 0
                     AND pr.promotion_id IS NOT NULL
                THEN s.units_sold
                ELSE 0
            END
        ) AS promo_units_sold
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    LEFT JOIN promotions pr ON s.promotion_id = pr.promotion_id
    GROUP BY p.product_family
)
SELECT
    product_family,
    COALESCE(total_units_sold, 0) AS total_units_sold,
    COALESCE(
        ROUND(100.0 * promo_units_sold / NULLIF(total_units_sold, 0), 2),
        0
    ) AS promo_percentage
FROM promo_sales
ORDER BY product_family;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.product_family,
    COALESCE(SUM(s.units_sold), 0) AS total_units_sold,
    COALESCE(
        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN s.promotion_id IS NOT NULL
                         AND s.promotion_id != 0
                         AND s.promotion_id IN (SELECT promotion_id FROM promotions)
                    THEN s.units_sold
                    ELSE 0
                END
            )
            / NULLIF(SUM(s.units_sold), 0),
            2
        ),
        0
    ) AS promo_percentage
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_family
ORDER BY p.product_family;
