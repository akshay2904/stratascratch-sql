-- ======================================================================
-- Highest Cost Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Shopify, Amazon
-- Access     : Premium
-- ID         : 9915
-- URL        : https://platform.stratascratch.com/coding/9915-highest-cost-orders
-- ======================================================================

/*
Find the customers with the highest daily total order cost between 2019-02-01 and 2019-05-01. If a customer had more than one order on a certain day, sum the order costs on a daily basis. Output each customer's first name, total cost of their items, and the date. If multiple customers tie for the highest daily total on the same date, return all of them.




For simplicity, you can assume that every first name in the dataset is unique.
*/

-- Tables:
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)
--   orders(cust_id bigint, id bigint, order_date date, order_details text, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_totals AS (
    SELECT 
        c.first_name,
        SUM(o.total_order_cost) AS total_cost,
        o.order_date
    FROM orders o
    JOIN customers c ON o.cust_id = c.id
    WHERE o.order_date BETWEEN '2019-02-01' AND '2019-05-01'
    GROUP BY c.first_name, o.order_date
),
ranked AS (
    SELECT 
        first_name,
        total_cost,
        order_date,
        RANK() OVER (PARTITION BY order_date ORDER BY total_cost DESC) AS rnk
    FROM daily_totals
)
SELECT first_name, total_cost, order_date
FROM ranked
WHERE rnk = 1
ORDER BY order_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    c.first_name,
    SUM(o.total_order_cost) AS total_cost,
    o.order_date
FROM orders o
JOIN customers c ON o.cust_id = c.id
WHERE o.order_date BETWEEN '2019-02-01' AND '2019-05-01'
GROUP BY c.first_name, o.order_date
HAVING SUM(o.total_order_cost) = (
    -- for each date, find the maximum daily total among all customers
    SELECT MAX(day_total)
    FROM (
        SELECT 
            o2.order_date AS order_date2,
            SUM(o2.total_order_cost) AS day_total
        FROM orders o2
        WHERE o2.order_date BETWEEN '2019-02-01' AND '2019-05-01'
        GROUP BY o2.cust_id, o2.order_date
    ) sub
    WHERE sub.order_date2 = o.order_date
)
ORDER BY o.order_date;
