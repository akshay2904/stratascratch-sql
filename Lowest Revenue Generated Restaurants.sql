-- ======================================================================
-- Lowest Revenue Generated Restaurants
-- ======================================================================
-- Difficulty : Hard
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2036
-- URL        : https://platform.stratascratch.com/coding/2036-lowest-revenue-generated-restaurants
-- ======================================================================

/*
Write a query that returns a list of the bottom 2% revenue generating restaurants. Return a list of restaurant IDs and their total revenue from when customers placed orders in May 2020.




You can calculate the total revenue by summing the order_total column. And you should calculate the bottom 2% by partitioning the total revenue into evenly distributed buckets.
*/

-- Tables:
--   doordash_delivery(consumer_id bigint, customer_placed_order_datetime timestamp without time zone, delivered_to_consumer_datetime timestamp without time zone, delivery_region text, discount_amount bigint, driver_at_restaurant_datetime timestamp without time zone, driver_id bigint, is_asap boolean, is_new boolean, order_total double precision, placed_order_with_restaurant_datetime timestamp without time zone, refunded_amount double precision, restaurant_id bigint, tip_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH revenue_by_restaurant AS (
    SELECT
        restaurant_id,
        SUM(order_total) AS total_revenue
    FROM orders
    WHERE order_date >= '2020-05-01'
      AND order_date < '2020-06-01'
    GROUP BY restaurant_id
),
percentile_ranked AS (
    SELECT
        restaurant_id,
        total_revenue,
        -- NTILE(100) splits into 100 evenly distributed buckets (each = 1%)
        NTILE(100) OVER (ORDER BY total_revenue ASC) AS percentile_bucket
    FROM revenue_by_restaurant
)
SELECT
    restaurant_id,
    total_revenue
FROM percentile_ranked
WHERE percentile_bucket <= 2  -- bottom 2%
ORDER BY total_revenue ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    restaurant_id,
    total_revenue
FROM (
    SELECT
        restaurant_id,
        SUM(order_total) AS total_revenue
    FROM orders
    WHERE order_date >= '2020-05-01'
      AND order_date < '2020-06-01'
    GROUP BY restaurant_id
) AS restaurant_revenue
WHERE total_revenue <= (
    -- Find the revenue value at the 2nd percentile cutoff
    SELECT PERCENTILE_CONT(0.02) WITHIN GROUP (ORDER BY total_revenue ASC)
    FROM (
        SELECT
            restaurant_id,
            SUM(order_total) AS total_revenue
        FROM orders
        WHERE order_date >= '2020-05-01'
          AND order_date < '2020-06-01'
        GROUP BY restaurant_id
    ) AS sub
)
ORDER BY total_revenue ASC;
