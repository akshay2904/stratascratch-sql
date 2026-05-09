-- ======================================================================
-- Fifth Highest Salary Without TOP or LIMIT
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana, Amazon
-- Access     : Premium
-- ID         : 9855
-- URL        : https://platform.stratascratch.com/coding/9855-find-the-5th-highest-salary-without-using-top-or-limit
-- ======================================================================

/*
You have been asked to find the fifth highest salary without using TOP or LIMIT.




Note: Duplicate salaries should not be removed.
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
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT salary
FROM ranked
WHERE rnk = 5;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Count how many distinct salaries are greater than the current salary;
-- if exactly 4 salaries are greater, this is the 5th highest distinct salary
SELECT DISTINCT salary
FROM employees e1
WHERE (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary > e1.salary
) = 4;
