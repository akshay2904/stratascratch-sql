-- ======================================================================
-- Manager of the Largest Department
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Ebay, Shopify, Amazon
-- Access     : Premium
-- ID         : 2060
-- URL        : https://platform.stratascratch.com/coding/2060-manager-of-the-largest-department
-- ======================================================================

/*
Given a list of a company’s employees, find the first and last names of all employees whose position contains the word “manager” and who work in the largest department(s) — that is, departments with the highest number of employees. If multiple departments share the same largest size, return managers from all such departments.
*/

-- Tables:
--   az_employees(department_id bigint, department_name text, first_name text, id bigint, last_name text, position text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dept_sizes AS (
    SELECT
        department,
        COUNT(*) AS dept_count,
        MAX(COUNT(*)) OVER () AS max_dept_count
    FROM employees
    GROUP BY department
),
largest_depts AS (
    SELECT department
    FROM dept_sizes
    WHERE dept_count = max_dept_count
)
SELECT e.first_name, e.last_name
FROM employees e
JOIN largest_depts ld ON e.department = ld.department
WHERE LOWER(e.position) LIKE '%manager%';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT first_name, last_name
FROM employees
WHERE LOWER(position) LIKE '%manager%'
  AND department IN (
      -- departments whose size equals the maximum department size
      SELECT department
      FROM employees
      GROUP BY department
      HAVING COUNT(*) = (
          SELECT MAX(dept_count)
          FROM (
              SELECT COUNT(*) AS dept_count
              FROM employees
              GROUP BY department
          ) AS dept_counts
      )
  );
