-- ======================================================================
-- Most Senior & Junior Employee
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2044
-- URL        : https://platform.stratascratch.com/coding/2044-most-senior-junior-employee
-- ======================================================================

/*
Write a query to find the number of days between the longest and least tenured employee still working for the company. Your output should include the number of employees with the longest-tenure, the number of employees with the least-tenure, and the number of days between both the longest-tenured and least-tenured hiring dates.
*/

-- Tables:
--   uber_employees(first_name text, hire_date date, id bigint, last_name text, salary bigint, termination_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH tenure_bounds AS (
    SELECT
        MIN(hire_date) AS earliest_hire,
        MAX(hire_date) AS latest_hire
    FROM employees
    WHERE termination_date IS NULL  -- still working
),
counts AS (
    SELECT
        SUM(CASE WHEN e.hire_date = tb.earliest_hire THEN 1 ELSE 0 END) AS longest_tenure_count,
        SUM(CASE WHEN e.hire_date = tb.latest_hire   THEN 1 ELSE 0 END) AS least_tenure_count,
        (tb.latest_hire - tb.earliest_hire) AS days_between
    FROM employees e
    CROSS JOIN tenure_bounds tb
    WHERE e.termination_date IS NULL
)
SELECT
    longest_tenure_count,
    least_tenure_count,
    days_between
FROM counts;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (
        SELECT COUNT(*)
        FROM employees
        WHERE termination_date IS NULL
          AND hire_date = (SELECT MIN(hire_date) FROM employees WHERE termination_date IS NULL)
    ) AS longest_tenure_count,
    (
        SELECT COUNT(*)
        FROM employees
        WHERE termination_date IS NULL
          AND hire_date = (SELECT MAX(hire_date) FROM employees WHERE termination_date IS NULL)
    ) AS least_tenure_count,
    (
        SELECT MAX(hire_date) - MIN(hire_date)
        FROM employees
        WHERE termination_date IS NULL
    ) AS days_between;
