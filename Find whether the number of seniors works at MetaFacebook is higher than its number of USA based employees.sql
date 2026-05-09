-- ======================================================================
-- Find whether the number of seniors works at Meta/Facebook is higher than its number of USA based employees
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10065
-- URL        : https://platform.stratascratch.com/coding/10065-find-whether-the-number-of-seniors-works-at-facebook-is-higher-than-its-number-of-usa-based-employees
-- ======================================================================

/*
Find whether the number of senior workers (i.e., more experienced) at Meta/Facebook is higher than number of USA-based employees at Facebook/Meta.

If the number of senior workers is higher then output as 'More seniors'. Otherwise, output as 'More USA-based'.
*/

-- Tables:
--   facebook_employees(age bigint, gender text, id bigint, is_senior boolean, location text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH counts AS (
    SELECT
        COUNT(*) FILTER (WHERE lower(employer) LIKE '%facebook%' OR lower(employer) LIKE '%meta%') 
            AS total_employees,
        COUNT(*) FILTER (
            (WHERE lower(employer) LIKE '%facebook%' OR lower(employer) LIKE '%meta%')
            AND lower(seniority) IN ('senior', 'lead', 'principal', 'staff', 'manager', 'director', 'vp', 'executive')
        ) AS senior_count,
        COUNT(*) FILTER (
            (WHERE lower(employer) LIKE '%facebook%' OR lower(employer) LIKE '%meta%')
            AND lower(location) LIKE '%united states%' OR lower(location) LIKE '%usa%'
        ) AS usa_count
    FROM linkedin_salary
)
SELECT
    CASE 
        WHEN senior_count > usa_count THEN 'More seniors'
        ELSE 'More USA-based'
    END AS result
FROM counts;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    CASE
        WHEN (
            SELECT COUNT(*)
            FROM linkedin_salary
            WHERE (lower(employer) LIKE '%facebook%' OR lower(employer) LIKE '%meta%')
              AND lower(seniority) IN ('senior', 'lead', 'principal', 'staff', 'manager', 'director', 'vp', 'executive')
        ) > (
            SELECT COUNT(*)
            FROM linkedin_salary
            WHERE (lower(employer) LIKE '%facebook%' OR lower(employer) LIKE '%meta%')
              AND (lower(location) LIKE '%united states%' OR lower(location) LIKE '%usa%')
        )
        THEN 'More seniors'
        ELSE 'More USA-based'
    END AS result;
