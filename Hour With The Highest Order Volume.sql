-- ======================================================================
-- Hour With The Highest Order Volume
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Postmates
-- Access     : Premium
-- ID         : 2014
-- URL        : https://platform.stratascratch.com/coding/2014-hour-with-the-highest-order-volume
-- ======================================================================

/*
Which hour of the day has the highest average number of orders across all recorded days? Your output should include the hour that satisfies this condition and the corresponding average number of orders per hour. The "order volume" refers to the count of orders placed within each hour of the day.
*/

-- Tables:
--   postmates_orders(amount double precision, city_id bigint, courier_id bigint, customer_id bigint, id bigint, order_timestamp_utc timestamp without time zone, seller_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH hourly_counts AS (
    -- Count orders per day per hour
    SELECT
        DATE(order_purchase_timestamp)        AS order_date,
        EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
        COUNT(*)                              AS order_count
    FROM orders
    GROUP BY order_date, hour_of_day
),
hourly_averages AS (
    SELECT
        hour_of_day,
        AVG(order_count) AS avg_orders
    FROM hourly_counts
    GROUP BY hour_of_day
),
ranked AS (
    SELECT
        hour_of_day,
        avg_orders,
        RANK() OVER (ORDER BY avg_orders DESC) AS rnk
    FROM hourly_averages
)
SELECT
    hour_of_day,
    avg_orders
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    hour_of_day,
    avg_orders
FROM (
    SELECT
        hour_of_day,
        AVG(order_count) AS avg_orders
    FROM (
        -- Step 1: count orders per day per hour
        SELECT
            DATE(order_purchase_timestamp)            AS order_date,
            EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
            COUNT(*)                                  AS order_count
        FROM orders
        GROUP BY
            DATE(order_purchase_timestamp),
            EXTRACT(HOUR FROM order_purchase_timestamp)
    ) daily_hourly
    GROUP BY hour_of_day
) hourly_avg
WHERE avg_orders = (
    -- Step 2: find the maximum average across all hours
    SELECT MAX(avg_orders)
    FROM (
        SELECT
            AVG(order_count) AS avg_orders
        FROM (
            SELECT
                DATE(order_purchase_timestamp)            AS order_date,
                EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
                COUNT(*)                                  AS order_count
            FROM orders
            GROUP BY
                DATE(order_purchase_timestamp),
                EXTRACT(HOUR FROM order_purchase_timestamp)
        ) daily_hourly2
        GROUP BY hour_of_day
    ) all_hour_avgs
);
