-- ======================================================================
-- Start Dates Of Top Drivers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 10083
-- URL        : https://platform.stratascratch.com/coding/10083-start-dates-of-top-drivers
-- ======================================================================

/*
Find contract starting dates of the top 5 most paid Lyft drivers. Consider only drivers who are still working with Lyft.
*/

-- Tables:
--   lyft_drivers(end_date date, index bigint, start_date date, yearly_salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_drivers AS (
    SELECT
        d.start_date,
        d.yearly_salary,
        ROW_NUMBER() OVER (ORDER BY d.yearly_salary DESC) AS salary_rank
    FROM lyft_drivers d
    WHERE d.end_date IS NULL  -- still working with Lyft
)
SELECT start_date
FROM ranked_drivers
WHERE salary_rank <= 5;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT start_date
FROM lyft_drivers
WHERE end_date IS NULL  -- still working with Lyft
ORDER BY yearly_salary DESC
LIMIT 5;
