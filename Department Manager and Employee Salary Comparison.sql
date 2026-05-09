-- ======================================================================
-- Department Manager and Employee Salary Comparison
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Oracle
-- Access     : Premium
-- ID         : 2146
-- URL        : https://platform.stratascratch.com/coding/2146-department-manager-and-employee-salary-comparison
-- ======================================================================

/*
Oracle is comparing the monthly wages of their employees in each department to those of their managers and co-workers.




You have been tasked with creating a table that compares an employee's salary to that of their manager and to the average salary of their department.




It is expected that the department manager's salary and the average salary of employee's from that department are in their own separate column.




Order the employee's salary from highest to lowest based on their department.

Your output should contain the department, employee id, salary of that employee, salary of that employee's manager and the average salary from employee's within that department rounded to the nearest whole number.




Note: Oracle have requested that you not include the department manager's salary in the average salary for that department in order to avoid skewing the results. Managers of each department do not report to anyone higher up; they are their own manager.
*/

-- Tables:
--   employee_o(age bigint, department text, employee_title text, first_name text, gender text, id bigint, last_name text, manager_id bigint, salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dept_avg AS (
    -- Calculate average salary excluding managers (those who are their own manager)
    SELECT 
        department_id,
        ROUND(AVG(salary)) AS avg_dept_salary
    FROM employees
    WHERE employee_id != manager_id  -- exclude department managers
    GROUP BY department_id
),
manager_info AS (
    -- Get manager salaries
    SELECT 
        employee_id AS mgr_id,
        salary AS manager_salary
    FROM employees
    WHERE employee_id = manager_id  -- only managers
)
SELECT 
    e.department_id,
    e.employee_id,
    e.salary,
    m.manager_salary,
    da.avg_dept_salary
FROM employees e
JOIN manager_info m 
    ON m.mgr_id = e.manager_id
JOIN dept_avg da 
    ON da.department_id = e.department_id
WHERE e.employee_id != e.manager_id  -- exclude managers from output
ORDER BY e.department_id, e.salary DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.department_id,
    e.employee_id,
    e.salary,
    (
        -- Subquery to get manager's salary for this employee
        SELECT mgr.salary
        FROM employees mgr
        WHERE mgr.employee_id = e.manager_id
    ) AS manager_salary,
    (
        -- Subquery to get avg dept salary excluding managers
        SELECT ROUND(AVG(sub.salary))
        FROM employees sub
        WHERE sub.department_id = e.department_id
          AND sub.employee_id != sub.manager_id  -- exclude managers from avg
    ) AS avg_dept_salary
FROM employees e
WHERE e.employee_id != e.manager_id  -- exclude managers from main result
ORDER BY e.department_id, e.salary DESC;
