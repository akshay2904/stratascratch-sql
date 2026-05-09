-- ======================================================================
-- Top 10 Salaries
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana, Amazon
-- Access     : Premium
-- ID         : 9853
-- URL        : https://platform.stratascratch.com/coding/9853-find-the-top-5-highest-salaries
-- ======================================================================

/*
Find the top ten highest paid employees.




Your output should include the worker id,  salary and department.




Sort records based on the salary in descending order.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_employees AS (
    SELECT
        w.worker_id,
        w.salary,
        w.department,
        RANK() OVER (ORDER BY w.salary DESC) AS salary_rank
    FROM worker w
)
SELECT
    worker_id,
    salary,
    department
FROM ranked_employees
WHERE salary_rank <= 10
ORDER BY salary DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    worker_id,
    salary,
    department
FROM worker
ORDER BY salary DESC
LIMIT 10;
