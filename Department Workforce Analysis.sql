-- ======================================================================
-- Department Workforce Analysis
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Microsoft, Oracle
-- Access     : Free
-- ID         : 2170
-- URL        : https://platform.stratascratch.com/coding/2170-department-workforce-analysis
-- ======================================================================

/*
The workforce planning team is analyzing department growth since the company's expansion, focusing on teams that have grown substantially.




For each department with 5 or more employees hired after 2020, return the name, headcount, total payroll, and average salary.
*/

-- Tables:
--   techcorp_workforce(department text, first_name text, id bigint, joining_date date, last_name text, phone_number text, salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dept_stats AS (
    SELECT
        d.department_name,
        COUNT(e.employee_id)        AS headcount,
        SUM(e.salary)               AS total_payroll,
        ROUND(AVG(e.salary), 2)     AS avg_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE EXTRACT(YEAR FROM e.hire_date) > 2020
    GROUP BY d.department_name
    HAVING COUNT(e.employee_id) >= 5
)
SELECT
    department_name,
    headcount,
    total_payroll,
    avg_salary
FROM dept_stats
ORDER BY headcount DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.department_name,
    COUNT(e.employee_id)            AS headcount,
    SUM(e.salary)                   AS total_payroll,
    ROUND(AVG(e.salary), 2)         AS avg_salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
WHERE e.hire_date > '2020-12-31'
GROUP BY d.department_name
HAVING COUNT(e.employee_id) >= 5
ORDER BY headcount DESC;
