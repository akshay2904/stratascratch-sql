-- ======================================================================
-- Sales Evaluation on Media Formats
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2158
-- URL        : https://platform.stratascratch.com/coding/2158-sales-evaluation-on-media-formats
-- ======================================================================

/*
The marketing department is evaluating the most effective promotional strategies for each product family.




You have been asked to find the total sales by media type for each product family. Here, “total sales” refers to cost_in_dollars multiplied by units_sold. Each order is linked to a promotion, and the associated media type for that promotion should be used to categorize the sale. For example, the product family ELECTRONICS could be sold 57% through INTERNET and 43% through BROADCAST.




Your output should include the product family listed alphabetically, the media type, and the calculated percentage of sales rounded to the nearest whole number ordered from highest to lowest.
*/

-- Tables:
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)
--   online_sales_promotions(cost bigint, end_date date, media_type text, promotion_id bigint, start_date date)
--   online_products(brand_name text, is_low_fat text, is_recyclable text, product_category bigint, product_class text, product_family text, product_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH sales_by_family_media AS (
    SELECT
        p.product_family,
        pr.media_type,
        SUM(s.cost_in_dollars * s.units_sold) AS total_sales
    FROM sales_fact_1998 s
    JOIN product p ON s.product_id = p.product_id
    JOIN promotion pr ON s.promotion_id = pr.promotion_id
    GROUP BY p.product_family, pr.media_type
),
family_totals AS (
    SELECT
        product_family,
        media_type,
        total_sales,
        SUM(total_sales) OVER (PARTITION BY product_family) AS family_total_sales
    FROM sales_by_family_media
)
SELECT
    product_family,
    media_type,
    ROUND(100.0 * total_sales / family_total_sales) AS sales_percentage
FROM family_totals
ORDER BY product_family ASC, sales_percentage DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    smg.product_family,
    smg.media_type,
    ROUND(100.0 * smg.total_sales / ft.family_total) AS sales_percentage
FROM (
    SELECT
        p.product_family,
        pr.media_type,
        SUM(s.cost_in_dollars * s.units_sold) AS total_sales
    FROM sales_fact_1998 s
    JOIN product p ON s.product_id = p.product_id
    JOIN promotion pr ON s.promotion_id = pr.promotion_id
    GROUP BY p.product_family, pr.media_type
) smg
JOIN (
    SELECT
        p.product_family,
        SUM(s.cost_in_dollars * s.units_sold) AS family_total
    FROM sales_fact_1998 s
    JOIN product p ON s.product_id = p.product_id
    JOIN promotion pr ON s.promotion_id = pr.promotion_id
    GROUP BY p.product_family
) ft ON smg.product_family = ft.product_family
ORDER BY smg.product_family ASC, sales_percentage DESC;
