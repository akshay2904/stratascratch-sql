-- ======================================================================
-- Extremely Late Delivery
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Yelp, DoorDash
-- Access     : Premium
-- ID         : 2113
-- URL        : https://platform.stratascratch.com/coding/2113-extremely-late-delivery
-- ======================================================================

/*
To remain competitive, the company you work with must reduce the number of extremely late deliveries.




A delivery is flagged as extremely late if the actual delivery time is more than 20 minutes (not inclusive) after the predicted delivery time.




You have been asked to calculate the percentage of orders that arrive extremely late each month.




Your output should include the month in the format 'YYYY-MM' and the percentage of extremely late orders as a percentage of all orders placed in that month.
*/

-- Tables:
--   delivery_orders(actual_delivery_time timestamp without time zone, consumer_id text, delivery_id text, delivery_rating double precision, driver_id text, order_placed_time timestamp without time zone, predicted_delivery_time timestamp without time zone, restaurant_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_stats AS (
    SELECT
        TO_CHAR(order_placed_time, 'YYYY-MM') AS month,
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (
            WHERE EXTRACT(EPOCH FROM (actual_delivery_time - predicted_delivery_time)) / 60.0 > 20
        ) AS extremely_late_orders
    FROM delivery_orders
    GROUP BY TO_CHAR(order_placed_time, 'YYYY-MM')
)
SELECT
    month,
    ROUND(
        100.0 * extremely_late_orders / NULLIF(total_orders, 0),
        2
    ) AS pct_extremely_late
FROM monthly_stats
ORDER BY month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TO_CHAR(order_placed_time, 'YYYY-MM') AS month,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN EXTRACT(EPOCH FROM (actual_delivery_time - predicted_delivery_time)) / 60.0 > 20
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS pct_extremely_late
FROM delivery_orders
GROUP BY TO_CHAR(order_placed_time, 'YYYY-MM')
ORDER BY month;
