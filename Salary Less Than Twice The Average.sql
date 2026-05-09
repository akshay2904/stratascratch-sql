-- ======================================================================
-- Salary Less Than Twice The Average
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Walmart, Best Buy, Amazon
-- Access     : Free
-- ID         : 2110
-- URL        : https://platform.stratascratch.com/coding/2110-salary-less-than-twice-the-average
-- ======================================================================

/*
Write a query to get the list of managers whose salary is less than twice the average salary of employees reporting to them. For these managers, output their ID, salary and the average salary of employees reporting to them.
*/

-- Tables:
--   map_employee_hierarchy(empl_id text, manager_empl_id text)
--   dim_employee(empl_city text, empl_dob date, empl_id text, empl_name text, empl_pin bigint, salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH employee_stats AS (
    SELECT
        manager_id,
        AVG(salary) AS avg_report_salary
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
)
SELECT
    m.employee_id        AS manager_id,
    m.salary             AS manager_salary,
    es.avg_report_salary AS avg_reportee_salary
FROM employees m
JOIN employee_stats es
    ON m.employee_id = es.manager_id
WHERE m.salary < 2 * es.avg_report_salary
ORDER BY m.employee_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    m.employee_id        AS manager_id,
    m.salary             AS manager_salary,
    AVG(e.salary)        AS avg_reportee_salary
FROM employees m
JOIN employees e
    ON e.manager_id = m.employee_id
GROUP BY
    m.employee_id,
    m.salary
HAVING m.salary < 2 * AVG(e.salary)
ORDER BY m.employee_id;
