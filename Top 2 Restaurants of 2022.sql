-- ======================================================================
-- Top 2 Restaurants of 2022
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2138
-- URL        : https://platform.stratascratch.com/coding/2138-top-3-restaurants-of-2022
-- ======================================================================

/*
Christmas is quickly approaching, and your team anticipates an increase in sales. To predict the busiest restaurants, they wanted to identify the top two restaurants by ID in terms of sales in 2022.




The output should include the restaurant IDs and their corresponding sales.




Note: Please remember that if an order has a blank value for actual_delivery_time, it has been canceled and therefore does not count towards monthly sales.
*/

-- Tables:
--   order_value(delivery_id text, sales_amount double precision)
--   delivery_orders(actual_delivery_time timestamp without time zone, consumer_id text, delivery_id text, delivery_rating double precision, driver_id text, order_placed_time timestamp without time zone, predicted_delivery_time timestamp without time zone, restaurant_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_restaurants AS (
    SELECT
        restaurant_id,
        SUM(sales_amount) AS total_sales,
        RANK() OVER (ORDER BY SUM(sales_amount) DESC) AS rnk
    FROM delivery_orders
    WHERE
        EXTRACT(YEAR FROM order_placed_time) = 2022
        AND actual_delivery_time IS NOT NULL  -- exclude canceled orders
    GROUP BY restaurant_id
)
SELECT
    restaurant_id,
    total_sales
FROM ranked_restaurants
WHERE rnk <= 2
ORDER BY total_sales DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    restaurant_id,
    SUM(sales_amount) AS total_sales
FROM delivery_orders
WHERE
    EXTRACT(YEAR FROM order_placed_time) = 2022
    AND actual_delivery_time IS NOT NULL  -- exclude canceled orders
GROUP BY restaurant_id
ORDER BY total_sales DESC
LIMIT 2;
