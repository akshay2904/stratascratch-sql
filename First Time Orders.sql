-- ======================================================================
-- First Time Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2093
-- URL        : https://platform.stratascratch.com/coding/2093-first-time-orders
-- ======================================================================

/*
The company you work with wants to find out what merchants are most popular for new customers.




You have been asked to find how many orders and first-time orders each merchant has had.




First-time orders are meant from the perspective of a customer, and are the first order that a customer ever made. In order words, for how many customers was this the first-ever merchant they ordered with?




Note: Recently, new restaurants have been registered on the system; however, because they may not have received any orders yet, your answer should exclude restaurants that have not received any orders.




Your output should contain the name of the merchant, the total number of their orders, and the number of these orders that were first-time orders.
*/

-- Tables:
--   order_details(customer_id bigint, id bigint, merchant_id bigint, n_items bigint, order_timestamp timestamp without time zone, total_amount_earned double precision)
--   merchant_details(category text, id bigint, name text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_first_orders AS (
    SELECT
        customer_id,
        merchant_id,
        -- Rank each customer's orders by date to find their very first order
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
    FROM orders
),
merchant_stats AS (
    SELECT
        merchant_id,
        COUNT(*) AS total_orders,
        -- Count only orders where this was the customer's first-ever order
        SUM(CASE WHEN order_rank = 1 THEN 1 ELSE 0 END) AS first_time_orders
    FROM customer_first_orders
    GROUP BY merchant_id
)
SELECT
    m.name AS merchant_name,
    ms.total_orders,
    ms.first_time_orders
FROM merchant_stats ms
JOIN merchants m ON m.id = ms.merchant_id
ORDER BY ms.total_orders DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    m.name AS merchant_name,
    COUNT(o.id) AS total_orders,
    -- Count orders where this order's date matches the customer's earliest ever order date
    -- AND the merchant matches to confirm it was placed with this merchant
    SUM(
        CASE
            WHEN o.order_date = (
                SELECT MIN(o2.order_date)
                FROM orders o2
                WHERE o2.customer_id = o.customer_id
            )
            THEN 1
            ELSE 0
        END
    ) AS first_time_orders
FROM orders o
JOIN merchants m ON m.id = o.merchant_id
GROUP BY m.id, m.name
ORDER BY total_orders DESC;
