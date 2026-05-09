-- ======================================================================
-- First Ever Ratings
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2114
-- URL        : https://platform.stratascratch.com/coding/2114-first-ever-ratings
-- ======================================================================

/*
The company you work for is looking at their delivery drivers' first-ever delivery with the company.




You have been tasked with finding what percentage of drivers' first-ever completed orders have a rating of 0.




Note: Please remember that if an order has a blank value for actual_delivery_time, it has been canceled and therefore does not count as a completed delivery.
*/

-- Tables:
--   delivery_orders(actual_delivery_time timestamp without time zone, consumer_id text, delivery_id text, delivery_rating double precision, driver_id text, order_placed_time timestamp without time zone, predicted_delivery_time timestamp without time zone, restaurant_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH first_deliveries AS (
    SELECT
        driver_id,
        rating,
        ROW_NUMBER() OVER (
            PARTITION BY driver_id
            ORDER BY created_at
        ) AS rn
    FROM delivery_orders
    WHERE actual_delivery_time IS NOT NULL  -- only completed deliveries
)
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN rating = 0 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_first_delivery_zero_rating
FROM first_deliveries
WHERE rn = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN d.rating = 0 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_first_delivery_zero_rating
FROM delivery_orders d
INNER JOIN (
    -- Get the earliest completed delivery timestamp per driver
    SELECT
        driver_id,
        MIN(created_at) AS first_delivery_time
    FROM delivery_orders
    WHERE actual_delivery_time IS NOT NULL
    GROUP BY driver_id
) first_orders
    ON d.driver_id = first_orders.driver_id
    AND d.created_at = first_orders.first_delivery_time
WHERE d.actual_delivery_time IS NOT NULL;
