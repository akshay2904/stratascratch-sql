-- ======================================================================
-- Customers Without Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon, Apple
-- Access     : Premium
-- ID         : 9896
-- URL        : https://platform.stratascratch.com/coding/9896-customers-without-orders
-- ======================================================================

/*
Find customers who have never made an order.
Output the first name of the customer.
*/

-- Tables:
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT c.first_name
FROM customers c
LEFT JOIN orders o ON c.id = o.cust_id
WHERE o.cust_id IS NULL;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT first_name
FROM customers
WHERE id NOT IN (
    SELECT cust_id
    FROM orders
    WHERE cust_id IS NOT NULL
);
