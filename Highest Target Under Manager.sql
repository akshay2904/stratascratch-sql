-- ======================================================================
-- Highest Target Under Manager
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Salesforce
-- Access     : Free
-- ID         : 9905
-- URL        : https://platform.stratascratch.com/coding/9905-highest-target-under-manager
-- ======================================================================

/*
Identify the employee(s) working under manager manager_id=13 who have achieved the highest target. Return each such employee’s first name alongside the target value. The goal is to display the maximum target among all employees under manager_id=13 and show which employee(s) reached that top value.
*/

-- Tables:
--   salesforce_employees(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        first_name,
        target,
        RANK() OVER (ORDER BY target DESC) AS rnk
    FROM employees
    WHERE manager_id = 13
)
SELECT first_name, target
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT first_name, target
FROM employees
WHERE manager_id = 13
  AND target = (
      SELECT MAX(target)
      FROM employees
      WHERE manager_id = 13
  );
