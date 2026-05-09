-- ======================================================================
-- Pizza Partners
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Postmates
-- Access     : Premium
-- ID         : 2016
-- URL        : https://platform.stratascratch.com/coding/2016-pizza-partners
-- ======================================================================

/*
Which partners have ‘pizza’ in their name and are located in Boston? And what is the average order amount? Output the partner name and the average order amount.
*/

-- Tables:
--   postmates_orders(amount double precision, city_id bigint, courier_id bigint, customer_id bigint, id bigint, order_timestamp_utc timestamp without time zone, seller_id bigint)
--   postmates_markets(id bigint, name text, timezone text)
--   postmates_partners(category text, id bigint, name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH pizza_boston_partners AS (
    SELECT partner_id, partner_name
    FROM partners
    WHERE LOWER(partner_name) LIKE '%pizza%'
      AND LOWER(city) = 'boston'
),
order_averages AS (
    SELECT
        p.partner_name,
        AVG(o.order_amount) AS avg_order_amount
    FROM pizza_boston_partners p
    LEFT JOIN orders o ON p.partner_id = o.partner_id
    GROUP BY p.partner_name
)
SELECT partner_name, avg_order_amount
FROM order_averages
ORDER BY partner_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.partner_name,
    AVG(o.order_amount) AS avg_order_amount
FROM partners p
LEFT JOIN orders o ON p.partner_id = o.partner_id
WHERE LOWER(p.partner_name) LIKE '%pizza%'
  AND LOWER(p.city) = 'boston'
GROUP BY p.partner_name
ORDER BY p.partner_name;
