-- ======================================================================
-- Average On-Time Order Value
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2153
-- URL        : https://platform.stratascratch.com/coding/2153-average-on-time-order-value
-- ======================================================================

/*
The ideal time between when a customer places an order and when the order is delivered is below or equal to 45 minutes.




You have been tasked with evaluating delivery driver performance by calculating the average order value for each delivery driver who has delivered at least once within this 45-minute period.




Your output should contain the driver ID along with their corresponding average order value.
*/

-- Tables:
--   delivery_details(consumer_id bigint, customer_placed_order_datetime timestamp without time zone, delivered_to_consumer_datetime timestamp without time zone, delivery_region text, discount_amount double precision, driver_at_restaurant_datetime timestamp without time zone, driver_id bigint, is_asap boolean, is_new boolean, order_total double precision, placed_order_with_restaurant_datetime timestamp without time zone, refunded_amount double precision, restaurant_id bigint, tip_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH qualifying_drivers AS (
    SELECT
        driver_id,
        AVG(order_total) AS avg_order_value
    FROM orders
    WHERE EXTRACT(EPOCH FROM (delivered_to_consumer_datetime - order_placed_time)) / 60 <= 45
    GROUP BY driver_id
)
SELECT
    driver_id,
    avg_order_value
FROM qualifying_drivers;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    driver_id,
    AVG(order_total) AS avg_order_value
FROM orders
WHERE driver_id IN (
    SELECT driver_id
    FROM orders
    WHERE EXTRACT(EPOCH FROM (delivered_to_consumer_datetime - order_placed_time)) / 60 <= 45
)
GROUP BY driver_id;
