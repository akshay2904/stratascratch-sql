-- ======================================================================
-- More Than 100 Dollars
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Salesforce, DoorDash
-- Access     : Premium
-- ID         : 2115
-- URL        : https://platform.stratascratch.com/coding/2115-more-than-100-dollars
-- ======================================================================

/*
The company for which you work is reviewing its 2021 monthly sales.




For each month of 2021, calculate what percentage of restaurants have reached at least 100$ or more in monthly sales.




Remember that if an order has a blank value for actual_delivery_time, it has been canceled and therefore does not count towards monthly sales.
*/

-- Tables:
--   delivery_orders(actual_delivery_time timestamp without time zone, consumer_id text, delivery_id text, delivery_rating double precision, driver_id text, order_placed_time timestamp without time zone, predicted_delivery_time timestamp without time zone, restaurant_id text)
--   order_value(delivery_id text, sales_amount double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    -- Calculate total sales per restaurant per month, excluding canceled orders
    SELECT
        restaurant_id,
        DATE_TRUNC('month', order_placed_time) AS sales_month,
        SUM(order_total) AS total_sales
    FROM orders
    WHERE actual_delivery_time IS NOT NULL
      AND EXTRACT(YEAR FROM order_placed_time) = 2021
    GROUP BY restaurant_id, DATE_TRUNC('month', order_placed_time)
),
month_stats AS (
    -- For each month, count restaurants with >= $100 and total distinct restaurants
    SELECT
        sales_month,
        COUNT(*) FILTER (WHERE total_sales >= 100) AS restaurants_above_100,
        COUNT(*) AS total_restaurants
    FROM monthly_sales
    GROUP BY sales_month
)
SELECT
    TO_CHAR(sales_month, 'YYYY-MM') AS month,
    restaurants_above_100,
    total_restaurants,
    ROUND(
        100.0 * restaurants_above_100 / NULLIF(total_restaurants, 0), 2
    ) AS pct_restaurants_above_100
FROM month_stats
ORDER BY sales_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TO_CHAR(sub.sales_month, 'YYYY-MM') AS month,
    SUM(CASE WHEN sub.total_sales >= 100 THEN 1 ELSE 0 END) AS restaurants_above_100,
    COUNT(*) AS total_restaurants,
    ROUND(
        100.0 * SUM(CASE WHEN sub.total_sales >= 100 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0), 2
    ) AS pct_restaurants_above_100
FROM (
    -- Subquery: monthly sales per restaurant, excluding canceled orders
    SELECT
        restaurant_id,
        DATE_TRUNC('month', order_placed_time) AS sales_month,
        SUM(order_total) AS total_sales
    FROM orders
    WHERE actual_delivery_time IS NOT NULL
      AND EXTRACT(YEAR FROM order_placed_time) = 2021
    GROUP BY
        restaurant_id,
        DATE_TRUNC('month', order_placed_time)
) sub
GROUP BY sub.sales_month
ORDER BY sub.sales_month;
