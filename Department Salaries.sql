-- ======================================================================
-- Department Salaries
-- ======================================================================
-- Difficulty : Medium
-- Companies  : LinkedIn, Glassdoor, Apple
-- Access     : Premium
-- ID         : 9921
-- URL        : https://platform.stratascratch.com/coding/9921-department-salaries
-- ======================================================================

/*
Find the number of male and female employees per department and also their corresponding total salaries.

Output department names along with the corresponding number of female employees, the total salary of female employees, the number of male employees, and the total salary of male employees.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    d.dept_name,
    COUNT(CASE WHEN e.gender = 'F' THEN 1 END)      AS female_count,
    SUM(CASE WHEN e.gender = 'F' THEN s.salary END)  AS female_total_salary,
    COUNT(CASE WHEN e.gender = 'M' THEN 1 END)       AS male_count,
    SUM(CASE WHEN e.gender = 'M' THEN s.salary END)  AS male_total_salary
FROM departments d
JOIN dept_emp de
    ON d.dept_no = de.dept_no
JOIN employees e
    ON de.emp_no = e.emp_no
JOIN salaries s
    ON e.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY d.dept_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.dept_name,
    COALESCE(f.female_count, 0)        AS female_count,
    COALESCE(f.female_total_salary, 0) AS female_total_salary,
    COALESCE(m.male_count, 0)          AS male_count,
    COALESCE(m.male_total_salary, 0)   AS male_total_salary
FROM departments d
-- Subquery for female stats per department
LEFT JOIN (
    SELECT
        de.dept_no,
        COUNT(e.emp_no)  AS female_count,
        SUM(s.salary)    AS female_total_salary
    FROM dept_emp de
    JOIN employees e ON de.emp_no = e.emp_no AND e.gender = 'F'
    JOIN salaries  s ON e.emp_no = s.emp_no
    GROUP BY de.dept_no
) f ON d.dept_no = f.dept_no
-- Subquery for male stats per department
LEFT JOIN (
    SELECT
        de.dept_no,
        COUNT(e.emp_no)  AS male_count,
        SUM(s.salary)    AS male_total_salary
    FROM dept_emp de
    JOIN employees e ON de.emp_no = e.emp_no AND e.gender = 'M'
    JOIN salaries  s ON e.emp_no = s.emp_no
    GROUP BY de.dept_no
) m ON d.dept_no = m.dept_no
ORDER BY d.dept_name;
