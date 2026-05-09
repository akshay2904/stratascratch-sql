-- ======================================================================
-- Proportion Of Total Spend
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Etsy, Amazon
-- Access     : Premium
-- ID         : 9899
-- URL        : https://platform.stratascratch.com/coding/9899-percentage-of-total-spend
-- ======================================================================

/*
Calculate the ratio of the total spend a customer spent on each order. Output the customer’s first name, order details, and ratio of the order cost to their total spend across all orders.




Assume each customer has a unique first name (i.e., there is only 1 customer named Karen in the dataset) and that customers place at most only 1 order a day.




Percentages should be represented as decimals.
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
    c.first_name,
    o.order_date,
    o.order_details,
    o.total_order_cost,
    -- ratio of this order's cost to the customer's total spend
    o.total_order_cost::NUMERIC / SUM(o.total_order_cost) OVER (PARTITION BY c.id) AS spend_ratio
FROM customers c
JOIN orders o ON c.id = o.cust_id
ORDER BY c.first_name, o.order_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.first_name,
    o.order_date,
    o.order_details,
    o.total_order_cost,
    o.total_order_cost::NUMERIC / cust_totals.total_spend AS spend_ratio
FROM customers c
JOIN orders o ON c.id = o.cust_id
-- subquery to get each customer's total spend across all orders
JOIN (
    SELECT
        cust_id,
        SUM(total_order_cost) AS total_spend
    FROM orders
    GROUP BY cust_id
) cust_totals ON o.cust_id = cust_totals.cust_id
ORDER BY c.first_name, o.order_date;
