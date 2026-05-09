-- ======================================================================
-- Find the percentage of shipable orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Amazon
-- Access     : Free
-- ID         : 10090
-- URL        : https://platform.stratascratch.com/coding/10090-find-the-percentage-of-shipable-orders
-- ======================================================================

/*
Find the percentage of shipable orders.

Consider an order is shipable if the customer's address is known.
*/

-- Tables:
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    ROUND(
        100.0 * COUNT(CASE WHEN c.address IS NOT NULL THEN 1 END) / NULLIF(COUNT(*), 0),
        2
    ) AS shipable_orders_percentage
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        100.0 *
        (SELECT COUNT(*)
         FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         WHERE c.address IS NOT NULL)
        /
        NULLIF(
            (SELECT COUNT(*) FROM orders),
            0
        ),
        2
    ) AS shipable_orders_percentage;
