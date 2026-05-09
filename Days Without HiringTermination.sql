-- ======================================================================
-- Days Without Hiring/Termination
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2045
-- URL        : https://platform.stratascratch.com/coding/2045-days-without-hiringtermination
-- ======================================================================

/*
Write a query to calculate the longest period (in days) that the company has gone without hiring anyone. Also, calculate the longest period without firing anyone. Limit yourself to dates inside the table (last hiring/termination date should be the latest hiring /termination date from table), don't go into future.
*/

-- Tables:
--   uber_employees(first_name text, hire_date date, id bigint, last_name text, salary bigint, termination_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH hire_gaps AS (
    SELECT
        hire_date,
        LAG(hire_date) OVER (ORDER BY hire_date) AS prev_hire_date,
        hire_date - LAG(hire_date) OVER (ORDER BY hire_date) AS gap_days
    FROM employees
),
termination_gaps AS (
    SELECT
        termination_date,
        LAG(termination_date) OVER (ORDER BY termination_date) AS prev_term_date,
        termination_date - LAG(termination_date) OVER (ORDER BY termination_date) AS gap_days
    FROM employees
    WHERE termination_date IS NOT NULL
)
SELECT
    MAX(h.gap_days) AS longest_period_without_hiring,
    MAX(t.gap_days) AS longest_period_without_firing
FROM hire_gaps h
CROSS JOIN termination_gaps t;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (
        -- For each hire date, find the minimum gap to the next hire date
        SELECT MAX(gap)
        FROM (
            SELECT
                e1.hire_date,
                MIN(e2.hire_date) - e1.hire_date AS gap
            FROM employees e1
            JOIN employees e2
                ON e2.hire_date > e1.hire_date
            GROUP BY e1.hire_date
        ) hire_gaps
    ) AS longest_period_without_hiring,
    (
        SELECT MAX(gap)
        FROM (
            SELECT
                e1.termination_date,
                MIN(e2.termination_date) - e1.termination_date AS gap
            FROM employees e1
            JOIN employees e2
                ON e2.termination_date > e1.termination_date
            WHERE e1.termination_date IS NOT NULL
              AND e2.termination_date IS NOT NULL
            GROUP BY e1.termination_date
        ) term_gaps
    ) AS longest_period_without_firing;
