-- ======================================================================
-- Customer Orders and Details
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Ebay, Amazon
-- Access     : Premium
-- ID         : 9908
-- URL        : https://platform.stratascratch.com/coding/9908-customer-orders-and-details
-- ======================================================================

/*
Find the number of orders, the number of customers, and the total cost of orders for each city. Only include cities that have made at least 5 orders and count all customers in each city even if they did not place an order.




Output each calculation along with the corresponding city name.
*/

-- Tables:
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_orders AS (
    -- Aggregate order stats per city using orders joined to customers
    SELECT
        c.city,
        COUNT(o.order_id)       AS number_of_orders,
        SUM(o.cost)             AS total_cost
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.city
    HAVING COUNT(o.order_id) >= 5
),
city_customers AS (
    -- Count ALL customers per city regardless of orders
    SELECT
        city,
        COUNT(customer_id) AS number_of_customers
    FROM customers
    GROUP BY city
)
SELECT
    co.city,
    co.number_of_orders,
    cc.number_of_customers,
    co.total_cost
FROM city_orders co
JOIN city_customers cc ON co.city = cc.city
ORDER BY co.city;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.city,
    COUNT(o.order_id)                        AS number_of_orders,
    (SELECT COUNT(*)
     FROM customers c2
     WHERE c2.city = c.city)                 AS number_of_customers,
    SUM(o.cost)                              AS total_cost
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) >= 5
ORDER BY c.city;
