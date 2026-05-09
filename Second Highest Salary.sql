-- ======================================================================
-- Second Highest Salary
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Dropbox, Amazon
-- Access     : Free
-- ID         : 9892
-- URL        : https://platform.stratascratch.com/coding/9892-second-highest-salary
-- ======================================================================

/*
Find the second highest salary of employees.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


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
SELECT salary AS second_highest_salary
FROM ranked_salaries
WHERE rnk = 2
LIMIT 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);
