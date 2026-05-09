-- ======================================================================
-- Avg Earnings per Weekday and Hour
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2034
-- URL        : https://platform.stratascratch.com/coding/2034-avg-earnings-per-weekday-and-hour
-- ======================================================================

/*
You have been asked to calculate the average earnings per order segmented by a combination of weekday (all 7 days) and hour using the column customer_placed_order_datetime.




You have also been told that the column order_total represents the gross order total for each order. Therefore, you'll need to calculate the net order total.




The gross order total is the total of the order before adding the tip and deducting the discount and refund.




Note: In your output, the day of the week should be represented in text format (i.e., Monday). Also, round earnings to 2 decimals
*/

-- Tables:
--   doordash_delivery(consumer_id bigint, customer_placed_order_datetime timestamp without time zone, delivered_to_consumer_datetime timestamp without time zone, delivery_region text, discount_amount bigint, driver_at_restaurant_datetime timestamp without time zone, driver_id bigint, is_asap boolean, is_new boolean, order_total double precision, placed_order_with_restaurant_datetime timestamp without time zone, refunded_amount double precision, restaurant_id bigint, tip_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH net_orders AS (
    SELECT
        -- Extract weekday name and hour from the order datetime
        TO_CHAR(customer_placed_order_datetime, 'Day') AS day_of_week,
        EXTRACT(DOW FROM customer_placed_order_datetime) AS day_num, -- for sorting Sun=0..Sat=6
        EXTRACT(HOUR FROM customer_placed_order_datetime) AS hour_of_day,
        -- Net order total = gross + tip - discount - refund
        (order_total + tip_amount - discount_amount - refund_amount) AS net_order_total
    FROM orders
)
SELECT
    TRIM(day_of_week)   AS day_of_week,
    hour_of_day::INT    AS hour_of_day,
    ROUND(AVG(net_order_total)::NUMERIC, 2) AS avg_earnings_per_order
FROM net_orders
GROUP BY day_of_week, day_num, hour_of_day
ORDER BY day_num, hour_of_day;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    -- Convert numeric day-of-week to text label
    TRIM(TO_CHAR(customer_placed_order_datetime, 'Day')) AS day_of_week,
    EXTRACT(HOUR FROM customer_placed_order_datetime)::INT AS hour_of_day,
    -- Net = gross order total + tip - discount - refund, then average and round
    ROUND(
        AVG(order_total + tip_amount - discount_amount - refund_amount)::NUMERIC,
        2
    ) AS avg_earnings_per_order
FROM orders
GROUP BY
    TO_CHAR(customer_placed_order_datetime, 'Day'),
    EXTRACT(DOW FROM customer_placed_order_datetime),
    EXTRACT(HOUR FROM customer_placed_order_datetime)
ORDER BY
    EXTRACT(DOW FROM customer_placed_order_datetime),
    EXTRACT(HOUR FROM customer_placed_order_datetime);
