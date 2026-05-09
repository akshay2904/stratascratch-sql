-- ======================================================================
-- Super Managers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Walmart, PayPal
-- Access     : Premium
-- ID         : 9901
-- URL        : https://platform.stratascratch.com/coding/9901-super-managers
-- ======================================================================

/*
Find managers with at least 7 direct reporting employees. In situations where user is reporting to himself/herself, count that also.

Output first names of managers.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH direct_reports AS (
    SELECT 
        manager_id,
        COUNT(*) AS report_count
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
)
SELECT e.first_name
FROM direct_reports dr
JOIN employees e ON e.employee_id = dr.manager_id
WHERE dr.report_count >= 7;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT first_name
FROM employees
WHERE employee_id IN (
    SELECT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
    HAVING COUNT(*) >= 7
);
