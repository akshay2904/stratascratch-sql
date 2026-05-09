-- ======================================================================
-- Customers with Large Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Netflix, Uber, DoorDash
-- Access     : Free
-- ID         : 2172
-- URL        : https://platform.stratascratch.com/coding/2172-customers-with-large-orders
-- ======================================================================

/*
The marketing team wants to identify high-value customers for a premium loyalty program. Find all customers who have placed at least one order over $100. Return customer ID and name.
*/

-- Tables:
--   online_store_customers(customer_id bigint, customer_name text)
--   online_store_orders(amount double precision, customer_id bigint, order_id bigint, status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Using EXISTS for efficient early termination once a qualifying order is found
SELECT DISTINCT
    c.customer_id,
    c.name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_total > 100
);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Using JOIN + GROUP BY to filter customers with qualifying orders
SELECT
    c.customer_id,
    c.name
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_total > 100
GROUP BY c.customer_id, c.name;
