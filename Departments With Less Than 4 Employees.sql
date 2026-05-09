-- ======================================================================
-- Departments With Less Than 4 Employees
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 9860
-- URL        : https://platform.stratascratch.com/coding/9860-find-departments-with-less-than-4-employees
-- ======================================================================

/*
Find departments with less than 4 employees.




Output the department along with the corresponding number of workers.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dept_counts AS (
    SELECT
        department,
        COUNT(*) AS num_employees,
        COUNT(*) OVER (PARTITION BY department) AS dept_total
    FROM employees
    GROUP BY department
)
SELECT
    department,
    num_employees
FROM dept_counts
WHERE num_employees < 4
ORDER BY department;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    department,
    COUNT(*) AS num_employees
FROM employees
GROUP BY department
HAVING COUNT(*) < 4
ORDER BY department;
