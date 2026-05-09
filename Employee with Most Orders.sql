-- ======================================================================
-- Employee with Most Orders
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Shopify
-- Access     : Premium
-- ID         : 2117
-- URL        : https://platform.stratascratch.com/coding/2117-employee-with-most-orders
-- ======================================================================

/*
What is the last name of the employee or employees who are responsible for the most orders?
*/

-- Tables:
--   shopify_orders(carrier_id double precision, created_at timestamp without time zone, order_amount bigint, order_id bigint, payment_method text, resp_employee_id bigint, shop_id bigint, total_items bigint, user_id bigint)
--   shopify_employees(department text, first_name text, id bigint, last_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_counts AS (
    SELECT 
        employee_id,
        COUNT(*) AS order_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM orders
    GROUP BY employee_id
)
SELECT e.last_name
FROM employees e
JOIN order_counts oc ON e.employee_id = oc.employee_id
WHERE oc.rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT e.last_name
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.last_name
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY employee_id
    ) AS counts
);
