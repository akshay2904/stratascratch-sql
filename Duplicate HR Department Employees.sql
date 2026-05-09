-- ======================================================================
-- Duplicate HR Department Employees
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Free
-- ID         : 9858
-- URL        : https://platform.stratascratch.com/coding/9858-find-employees-in-the-hr-department-and-output-the-result-with-one-duplicate
-- ======================================================================

/*
Generate a list of employees who work in the HR department, including only their first names and department in the output. Each employee should appear twice in the list, meaning their first name and department should be duplicated in the output.
*/

-- Tables:
--   worker(department text, first_name text, joining_date date, last_name text, salary bigint, worker_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH hr_employees AS (
    SELECT e.first_name, d.department_name
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = 'HR'
),
duplicator AS (
    SELECT 1 AS dup UNION ALL SELECT 2
)
SELECT h.first_name, h.department_name
FROM hr_employees h
CROSS JOIN duplicator
ORDER BY h.first_name, dup;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT e.first_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR'

UNION ALL

SELECT e.first_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'HR'

ORDER BY first_name;
