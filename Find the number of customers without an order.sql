-- ======================================================================
-- Find the number of customers without an order
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Amazon
-- Access     : Premium
-- ID         : 10089
-- URL        : https://platform.stratascratch.com/coding/10089-find-the-number-of-customers-without-an-order
-- ======================================================================

/*
Find the number of customers without an order.
*/

-- Tables:
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT COUNT(*) AS customers_without_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(*) AS customers_without_order
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
);
