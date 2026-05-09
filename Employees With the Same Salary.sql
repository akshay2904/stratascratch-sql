-- ======================================================================
-- Employees With the Same Salary
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Free
-- ID         : 9856
-- URL        : https://platform.stratascratch.com/coding/9856-find-employees-with-the-same-salary
-- ======================================================================

/*
Find employees who earn the same salary.




Output the worker id along with the first name and the salary in descending order.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH salary_counts AS (
    SELECT 
        worker_id,
        first_name,
        salary,
        COUNT(*) OVER (PARTITION BY salary) AS cnt
    FROM worker
)
SELECT 
    worker_id,
    first_name,
    salary
FROM salary_counts
WHERE cnt > 1
ORDER BY salary DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    worker_id,
    first_name,
    salary
FROM worker
WHERE salary IN (
    SELECT salary
    FROM worker
    GROUP BY salary
    HAVING COUNT(*) > 1
)
ORDER BY salary DESC;
