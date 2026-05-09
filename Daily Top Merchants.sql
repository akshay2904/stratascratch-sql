-- ======================================================================
-- Daily Top Merchants
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2092
-- URL        : https://platform.stratascratch.com/coding/2092-daily-top-merchants
-- ======================================================================

/*
You have been asked to find the top 3 merchants for each day with the highest number of orders on that day.




In the event of a tie, multiple merchants may share the same spot, but each day at least one merchant must be in first, second, and third place.




Your output should include the date in the format YYYY-MM-DD, the name of the merchant, and their place in the daily ranking.
*/

-- Tables:
--   order_details(customer_id bigint, id bigint, merchant_id bigint, n_items bigint, order_timestamp timestamp without time zone, total_amount_earned double precision)
--   merchant_details(category text, id bigint, name text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_merchant_orders AS (
    SELECT
        DATE(order_placed_time) AS order_date,
        merchant_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY DATE(order_placed_time), merchant_id
),
ranked AS (
    SELECT
        order_date,
        merchant_id,
        order_count,
        DENSE_RANK() OVER (PARTITION BY order_date ORDER BY order_count DESC) AS place
    FROM daily_merchant_orders
)
SELECT
    TO_CHAR(r.order_date, 'YYYY-MM-DD') AS order_date,
    m.merchant_name,
    r.place
FROM ranked r
JOIN merchants m ON r.merchant_id = m.id
WHERE r.place <= 3
ORDER BY r.order_date, r.place;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TO_CHAR(DATE(o.order_placed_time), 'YYYY-MM-DD') AS order_date,
    m.merchant_name,
    -- Calculate place by counting how many distinct order counts are strictly greater
    (
        SELECT COUNT(DISTINCT sub2.order_count) + 1
        FROM (
            SELECT COUNT(*) AS order_count
            FROM orders o2
            WHERE DATE(o2.order_placed_time) = DATE(o.order_placed_time)
            GROUP BY o2.merchant_id
        ) sub2
        WHERE sub2.order_count > COUNT(o.id)
    ) AS place
FROM orders o
JOIN merchants m ON o.merchant_id = m.id
GROUP BY DATE(o.order_placed_time), o.merchant_id, m.merchant_name
HAVING (
    -- Only include if place <= 3, i.e., fewer than 3 distinct counts beat this one
    SELECT COUNT(DISTINCT sub2.order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders o2
        WHERE DATE(o2.order_placed_time) = DATE(o.order_placed_time)
        GROUP BY o2.merchant_id
    ) sub2
    WHERE sub2.order_count > COUNT(o.id)
) < 3
ORDER BY DATE(o.order_placed_time), place;
