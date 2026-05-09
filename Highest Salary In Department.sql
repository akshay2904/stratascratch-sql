-- ======================================================================
-- Highest Salary In Department
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana, Twitter
-- Access     : Free
-- ID         : 9897
-- URL        : https://platform.stratascratch.com/coding/9897-highest-salary-in-department
-- ======================================================================

/*
Find the employee with the highest salary per department.

Output the department name, employee's first name along with the corresponding salary.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_employees AS (
    SELECT
        d.dept_name,
        e.first_name,
        e.salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
    FROM employees e
    JOIN departments d ON e.department_id = d.id
)
SELECT
    dept_name,
    first_name,
    salary
FROM ranked_employees
WHERE salary_rank = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.dept_name,
    e.first_name,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
