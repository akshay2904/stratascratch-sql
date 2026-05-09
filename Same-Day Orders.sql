-- ======================================================================
-- Same-Day Orders
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Walmart
-- Access     : Premium
-- ID         : 10545
-- URL        : https://platform.stratascratch.com/coding/10545-same-day-orders
-- ======================================================================

/*
Identify users who started a session and placed an order on the same day.




For these users, return the total number of orders placed on that day and the total order value for that day.




Your output should include the user_id, the session_date, the total number of orders, and the total order value for that day.
*/

-- Tables:
--   sessions(session_date date, session_id bigint, user_id bigint)
--   order_summary(order_date date, order_id bigint, order_value bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH session_days AS (
    -- Distinct user/date combos where a session was started
    SELECT DISTINCT user_id, DATE(session_start) AS session_date
    FROM sessions
),
order_days AS (
    -- Aggregate orders per user per day
    SELECT
        user_id,
        DATE(order_date)          AS order_date,
        COUNT(*)                  AS total_orders,
        SUM(order_value)          AS total_order_value
    FROM orders
    GROUP BY user_id, DATE(order_date)
)
SELECT
    od.user_id,
    od.order_date        AS session_date,
    od.total_orders,
    od.total_order_value
FROM order_days od
INNER JOIN session_days sd
    ON od.user_id    = sd.user_id
   AND od.order_date = sd.session_date
ORDER BY od.user_id, od.order_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.user_id,
    DATE(o.order_date)   AS session_date,
    COUNT(o.order_id)    AS total_orders,
    SUM(o.order_value)   AS total_order_value
FROM orders o
WHERE EXISTS (
    -- Check that the user had a session on this same day
    SELECT 1
    FROM sessions s
    WHERE s.user_id = o.user_id
      AND DATE(s.session_start) = DATE(o.order_date)
)
GROUP BY o.user_id, DATE(o.order_date)
ORDER BY o.user_id, DATE(o.order_date);
