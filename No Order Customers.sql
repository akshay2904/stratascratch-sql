-- ======================================================================
-- No Order Customers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Instacart, Amazon
-- Access     : Premium
-- ID         : 10142
-- URL        : https://platform.stratascratch.com/coding/10142-no-order-customers
-- ======================================================================

/*
Identify customers who did not place an order between 2019-02-01 and 2019-03-01.




Include:




•    Customers who placed orders only outside this date range.

•    Customers who never placed any orders.




Output the customers' first names.
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
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= '2019-02-01'
      AND o.order_date < '2019-03-01'
);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT c.first_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_date >= '2019-02-01'
    AND o.order_date < '2019-03-01'
WHERE o.order_id IS NULL;
