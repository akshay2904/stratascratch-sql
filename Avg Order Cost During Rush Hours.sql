-- ======================================================================
-- Avg Order Cost During Rush Hours
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2035
-- URL        : https://platform.stratascratch.com/coding/2035-avg-order-cost-during-rush-hours
-- ======================================================================

/*
The company you work for has asked you to look into the average order value per hour during rush hours in the San Jose area. Rush hour is from 15H - 17H59 inclusive.




You have also been told that the column order_total represents the gross order total for each order. Therefore, you'll need to calculate the net order total.




The gross order total is the total of the order before adding the tip and deducting the discount and refund.




Use the column customer_placed_order_datetime for your calculations.
*/

-- Tables:
--   delivery_details(consumer_id bigint, customer_placed_order_datetime timestamp without time zone, delivered_to_consumer_datetime timestamp without time zone, delivery_region text, discount_amount double precision, driver_at_restaurant_datetime timestamp without time zone, driver_id bigint, is_asap boolean, is_new boolean, order_total double precision, placed_order_with_restaurant_datetime timestamp without time zone, refunded_amount double precision, restaurant_id bigint, tip_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH rush_hour_orders AS (
    SELECT
        EXTRACT(HOUR FROM customer_placed_order_datetime) AS order_hour,
        -- Net order total = gross + tip - discount - refund
        (order_total + tip_amount - discount_amount - refund_amount) AS net_order_total
    FROM orders
    WHERE
        EXTRACT(HOUR FROM customer_placed_order_datetime) BETWEEN 15 AND 17
        AND city = 'San Jose'
)
SELECT
    order_hour,
    ROUND(AVG(net_order_total), 2) AS avg_net_order_value
FROM rush_hour_orders
GROUP BY order_hour
ORDER BY order_hour;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(HOUR FROM customer_placed_order_datetime) AS order_hour,
    ROUND(
        AVG(order_total + tip_amount - discount_amount - refund_amount),
        2
    ) AS avg_net_order_value
FROM orders
WHERE
    city = 'San Jose'
    AND EXTRACT(HOUR FROM customer_placed_order_datetime) >= 15
    AND EXTRACT(HOUR FROM customer_placed_order_datetime) <= 17
GROUP BY
    EXTRACT(HOUR FROM customer_placed_order_datetime)
ORDER BY
    order_hour;
