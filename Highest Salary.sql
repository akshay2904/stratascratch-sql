-- ======================================================================
-- Highest Salary
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Siemens, Amazon
-- Access     : Premium
-- ID         : 9870
-- URL        : https://platform.stratascratch.com/coding/9870-highest-salary
-- ======================================================================

/*
You have been asked to find the employee with the highest salary. Output the worker or worker's first name, as well as the salary.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        first_name,
        salary,
        RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM worker
)
SELECT first_name, salary
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT first_name, salary
FROM worker
WHERE salary = (
    SELECT MAX(salary)
    FROM worker
);
