-- ======================================================================
-- Distinct Salaries
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Twitter
-- Access     : Premium
-- ID         : 9898
-- URL        : https://platform.stratascratch.com/coding/9898-unique-salaries
-- ======================================================================

/*
Find the top three distinct salaries for each department. Output the department name and the top 3 distinct salaries by each department. Order your results alphabetically by department and then by highest salary to lowest.
*/

-- Tables:
--   twitter_employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_salaries AS (
    SELECT
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employee
)
SELECT
    department,
    salary
FROM ranked_salaries
WHERE salary_rank <= 3
ORDER BY department ASC, salary DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e1.department,
    e1.salary
FROM (SELECT DISTINCT department, salary FROM employee) e1
WHERE (
    SELECT COUNT(DISTINCT e2.salary)
    FROM employee e2
    WHERE e2.department = e1.department
      AND e2.salary > e1.salary
) < 3
ORDER BY e1.department ASC, e1.salary DESC;
