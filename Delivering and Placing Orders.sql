-- ======================================================================
-- Delivering and Placing Orders
-- ======================================================================
-- Difficulty : Hard
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2037
-- URL        : https://platform.stratascratch.com/coding/2037-delivering-and-placing-orders
-- ======================================================================

/*
You have been asked to investigate whether there is a correlation between the average total order value and the average time in minutes between placing an order and having it delivered per restaurant.




You have also been told that the column order_total represents the gross order total for each order. Therefore, you'll need to calculate the net order total. This is done by adding the tip_amount and subtracting both the discount_amount and refunded_amount from the order_total.




Make sure correlation is rounded to 2 decimals.
*/

-- Tables:
--   delivery_details(consumer_id bigint, customer_placed_order_datetime timestamp without time zone, delivered_to_consumer_datetime timestamp without time zone, delivery_region text, discount_amount double precision, driver_at_restaurant_datetime timestamp without time zone, driver_id bigint, is_asap boolean, is_new boolean, order_total double precision, placed_order_with_restaurant_datetime timestamp without time zone, refunded_amount double precision, restaurant_id bigint, tip_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH restaurant_metrics AS (
    SELECT
        restaurant_id,
        AVG(
            order_total + tip_amount - discount_amount - refunded_amount
        ) AS avg_net_order_total,
        AVG(
            EXTRACT(EPOCH FROM (delivered_at - placed_at)) / 60.0
        ) AS avg_delivery_minutes
    FROM orders
    GROUP BY restaurant_id
)
SELECT
    ROUND(
        CORR(avg_net_order_total, avg_delivery_minutes)::NUMERIC,
        2
    ) AS correlation
FROM restaurant_metrics;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        CORR(avg_net_order_total, avg_delivery_minutes)::NUMERIC,
        2
    ) AS correlation
FROM (
    SELECT
        restaurant_id,
        AVG(order_total + tip_amount - discount_amount - refunded_amount) AS avg_net_order_total,
        AVG(
            (EXTRACT(EPOCH FROM delivered_at) - EXTRACT(EPOCH FROM placed_at)) / 60.0
        ) AS avg_delivery_minutes
    FROM orders
    GROUP BY restaurant_id
) AS restaurant_averages;
