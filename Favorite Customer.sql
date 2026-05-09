-- ======================================================================
-- Favorite Customer
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Ebay, Shopify, Amazon
-- Access     : Premium
-- ID         : 9910
-- URL        : https://platform.stratascratch.com/coding/9910-favorite-customer
-- ======================================================================

/*
Find "favorite" customers based on the order count and the total cost of orders.
A customer is considered as a favorite if he or she has placed more than 3 orders and with the total cost of orders more than $100.




Output the customer's first name, city, number of orders, and total cost of orders.
*/

-- Tables:
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_stats AS (
    SELECT
        c.first_name,
        c.city,
        COUNT(o.id)        AS order_count,
        SUM(o.cost)        AS total_cost
    FROM customers c
    JOIN orders o ON c.id = o.cust_id
    GROUP BY c.id, c.first_name, c.city
    HAVING COUNT(o.id) > 3
       AND SUM(o.cost) > 100
)
SELECT
    first_name,
    city,
    order_count,
    total_cost
FROM customer_stats;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.first_name,
    c.city,
    (SELECT COUNT(*) FROM orders o WHERE o.cust_id = c.id)    AS order_count,
    (SELECT SUM(o.cost) FROM orders o WHERE o.cust_id = c.id) AS total_cost
FROM customers c
WHERE (SELECT COUNT(*) FROM orders o WHERE o.cust_id = c.id) > 3
  AND (SELECT SUM(o.cost) FROM orders o WHERE o.cust_id = c.id) > 100;
