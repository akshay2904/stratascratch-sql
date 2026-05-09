-- ======================================================================
-- Second Highest Salary Without ORDER BY
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Instacart, Amazon
-- Access     : Premium
-- ID         : 9857
-- URL        : https://platform.stratascratch.com/coding/9857-find-the-second-highest-salary-without-using-order-by
-- ======================================================================

/*
Find the second highest salary without using ORDER BY.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_salaries AS (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT MAX(salary) AS second_highest_salary
FROM ranked_salaries
WHERE rnk = 2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Find the max salary that is strictly less than the overall max salary
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);
