-- ======================================================================
-- Multi-Status Order Tracking by Week
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 10563
-- URL        : https://platform.stratascratch.com/coding/10563-multi-status-order-tracking-by-week
-- ======================================================================

/*
Amazon tracks orders through multiple stages from placement to delivery. Each order has three key dates: when it was ordered, when it was shipped, and when it was received by the customer.




Create a weekly report showing how many orders are in their latest new status for that week, with weeks starting on Monday. An order should be counted from its order week through its delivery week only. Before shipment it counts as pending; after shipment and before delivery it counts as shipped; in the week it is received it counts as delivered. Do not continue counting delivered orders in subsequent weeks.




Output the week_start_date, count of pending_orders, count of shipped_orders, and count of delivered_orders.
*/

-- Tables:
--   shipment_tracking(delivered_date date, order_amount double precision, order_id bigint, ordered_date date, shipped_date date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Sample table assumption:
-- orders(order_id, order_date, ship_date, delivery_date)

WITH
-- Generate all relevant weeks from min order date to max delivery date
date_bounds AS (
    SELECT
        date_trunc('week', MIN(order_date))::date    AS min_week,
        date_trunc('week', MAX(delivery_date))::date AS max_week
    FROM orders
),
week_series AS (
    SELECT generate_series(min_week, max_week, INTERVAL '1 week')::date AS week_start
    FROM date_bounds
),
-- For each order, compute its order_week, ship_week, delivery_week
order_weeks AS (
    SELECT
        order_id,
        date_trunc('week', order_date)::date    AS order_week,
        date_trunc('week', ship_date)::date     AS ship_week,
        date_trunc('week', delivery_date)::date AS delivery_week
    FROM orders
),
-- Cross join weeks with orders, keeping only weeks where order is active
order_week_status AS (
    SELECT
        ws.week_start,
        ow.order_id,
        CASE
            -- In the delivery week: delivered
            WHEN ws.week_start = ow.delivery_week THEN 'delivered'
            -- After ship week but before delivery week: shipped
            WHEN ws.week_start >= ow.ship_week AND ws.week_start < ow.delivery_week THEN 'shipped'
            -- From order week up to (but not including) ship week: pending
            WHEN ws.week_start >= ow.order_week AND ws.week_start < ow.ship_week THEN 'pending'
        END AS status
    FROM week_series ws
    JOIN order_weeks ow
        ON ws.week_start >= ow.order_week
        AND ws.week_start <= ow.delivery_week  -- stop counting after delivery week
)
SELECT
    week_start                                                         AS week_start_date,
    COUNT(*) FILTER (WHERE status = 'pending')                         AS pending_orders,
    COUNT(*) FILTER (WHERE status = 'shipped')                         AS shipped_orders,
    COUNT(*) FILTER (WHERE status = 'delivered')                       AS delivered_orders
FROM order_week_status
WHERE status IS NOT NULL
GROUP BY week_start
ORDER BY week_start;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ws.week_start                                                      AS week_start_date,
    SUM(CASE
        WHEN ws.week_start >= date_trunc('week', o.order_date)::date
         AND ws.week_start <  date_trunc('week', o.ship_date)::date
        THEN 1 ELSE 0
    END)                                                               AS pending_orders,
    SUM(CASE
        WHEN ws.week_start >= date_trunc('week', o.ship_date)::date
         AND ws.week_start <  date_trunc('week', o.delivery_date)::date
        THEN 1 ELSE 0
    END)                                                               AS shipped_orders,
    SUM(CASE
        WHEN ws.week_start = date_trunc('week', o.delivery_date)::date
        THEN 1 ELSE 0
    END)                                                               AS delivered_orders
FROM (
    -- Generate all weeks between global min order date and max delivery date
    SELECT generate_series(
        (SELECT date_trunc('week', MIN(order_date))::date FROM orders),
        (SELECT date_trunc('week', MAX(delivery_date))::date FROM orders),
        INTERVAL '1 week'
    )::date AS week_start
) ws
JOIN orders o
    ON ws.week_start >= date_trunc('week', o.order_date)::date
    AND ws.week_start <= date_trunc('week', o.delivery_date)::date  -- only include weeks up to delivery
GROUP BY ws.week_start
ORDER BY ws.week_start;
