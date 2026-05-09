-- ======================================================================
-- Highest Salaried Employees By Department
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Visa, Amazon
-- Access     : Premium
-- ID         : 9865
-- URL        : https://platform.stratascratch.com/coding/9865-highest-salaried-employees
-- ======================================================================

/*
You have been asked to find the employee with the highest salary in each department.




Output the department name, full name of the employee(s), and corresponding salary.
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
        d.name AS department_name,
        e.first_name || ' ' || e.last_name AS full_name,
        e.salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk
    FROM employee e
    JOIN department d ON e.department_id = d.id
)
SELECT
    department_name,
    full_name,
    salary
FROM ranked
WHERE rnk = 1
ORDER BY department_name, full_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.name AS department_name,
    e.first_name || ' ' || e.last_name AS full_name,
    e.salary
FROM employee e
JOIN department d ON e.department_id = d.id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employee e2
    WHERE e2.department_id = e.department_id
)
ORDER BY d.name, full_name;
