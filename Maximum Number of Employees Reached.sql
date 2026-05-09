-- ======================================================================
-- Maximum Number of Employees Reached
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2046
-- URL        : https://platform.stratascratch.com/coding/2046-maximum-number-of-employees-reached
-- ======================================================================

/*
Write a query that returns every employee that has ever worked for the company. For each employee, calculate the greatest number of employees that worked for the company during their tenure and the first date that number was reached. The termination date of an employee should not be counted as a working day.




Your output should have the employee ID, greatest number of employees that worked for the company during the employee's tenure, and first date that number was reached.
*/

-- Tables:
--   uber_employees(first_name text, hire_date date, id bigint, last_name text, salary bigint, termination_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH employee_events AS (
    -- Build a timeline of headcount changes
    -- Each hire adds +1, each termination adds -1
    SELECT
        hire_date AS event_date,
        1 AS change
    FROM employees
    UNION ALL
    SELECT
        termination_date AS event_date,
        -1 AS change
    FROM employees
    WHERE termination_date IS NOT NULL
),
daily_headcount AS (
    -- Sum changes per day, then compute running headcount
    SELECT
        event_date,
        SUM(SUM(change)) OVER (ORDER BY event_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS headcount
    FROM employee_events
    GROUP BY event_date
),
employee_tenure AS (
    -- For each employee, find the max headcount during their tenure
    -- Tenure: [hire_date, termination_date) — termination date excluded
    SELECT
        e.employee_id,
        MAX(d.headcount) AS max_headcount
    FROM employees e
    JOIN daily_headcount d
        ON d.event_date >= e.hire_date
        AND (e.termination_date IS NULL OR d.event_date < e.termination_date)
    GROUP BY e.employee_id
),
first_date_reached AS (
    -- Find the first date the max headcount was reached during each employee's tenure
    SELECT
        e.employee_id,
        et.max_headcount,
        MIN(d.event_date) AS first_date
    FROM employees e
    JOIN employee_tenure et ON et.employee_id = e.employee_id
    JOIN daily_headcount d
        ON d.event_date >= e.hire_date
        AND (e.termination_date IS NULL OR d.event_date < e.termination_date)
        AND d.headcount = et.max_headcount
    GROUP BY e.employee_id, et.max_headcount
)
SELECT
    employee_id,
    max_headcount,
    first_date
FROM first_date_reached
ORDER BY employee_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH all_dates AS (
    -- Collect every date on which a headcount change occurs
    SELECT hire_date AS event_date FROM employees
    UNION
    SELECT termination_date FROM employees WHERE termination_date IS NOT NULL
),
daily_headcount AS (
    -- For each event date, count how many employees were actively working
    -- (hired on or before the date, and either not terminated or terminated after the date)
    SELECT
        ad.event_date,
        COUNT(e.employee_id) AS headcount
    FROM all_dates ad
    JOIN employees e
        ON e.hire_date <= ad.event_date
        AND (e.termination_date IS NULL OR e.termination_date > ad.event_date)
    GROUP BY ad.event_date
),
employee_max AS (
    -- For each employee, find the max headcount across dates in their tenure
    SELECT
        e.employee_id,
        MAX(d.headcount) AS max_headcount
    FROM employees e
    JOIN daily_headcount d
        ON d.event_date >= e.hire_date
        AND (e.termination_date IS NULL OR d.event_date < e.termination_date)
    GROUP BY e.employee_id
)
SELECT
    em.employee_id,
    em.max_headcount,
    MIN(d.event_date) AS first_date
FROM employee_max em
JOIN employees e ON e.employee_id = em.employee_id
JOIN daily_headcount d
    ON d.event_date >= e.hire_date
    AND (e.termination_date IS NULL OR d.event_date < e.termination_date)
    AND d.headcount = em.max_headcount
GROUP BY em.employee_id, em.max_headcount
ORDER BY em.employee_id;
