-- ======================================================================
-- Median Salary
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Walmart, The Honest Company, Twitter
-- Access     : Premium
-- ID         : 9900
-- URL        : https://platform.stratascratch.com/coding/9900-median-salary
-- ======================================================================

/*
Find the median employee salary of each department.
Output the department name along with the corresponding salary rounded to the nearest whole dollar.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        d.department_name,
        e.salary,
        COUNT(*) OVER (PARTITION BY e.department_id) AS total_count,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary) AS rn
    FROM employee e
    JOIN department d ON e.department_id = d.id
)
SELECT
    department_name,
    ROUND(AVG(salary)) AS salary
FROM ranked
WHERE rn IN (
    (total_count + 1) / 2,      -- lower middle for even counts
    (total_count + 2) / 2       -- upper middle for even counts (same as lower for odd)
)
GROUP BY department_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.department_name,
    ROUND(AVG(e1.salary)) AS salary
FROM employee e1
JOIN department d ON e1.department_id = d.id
WHERE e1.salary IN (
    -- Pick salaries that sit at the median position(s)
    SELECT e2.salary
    FROM employee e2
    WHERE e2.department_id = e1.department_id
    ORDER BY e2.salary
    LIMIT 2 OFFSET (
        SELECT (COUNT(*) - 1) / 2
        FROM employee e3
        WHERE e3.department_id = e1.department_id
    )
)
GROUP BY d.department_name;
