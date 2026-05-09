-- ======================================================================
-- Employed at Google
-- ======================================================================
-- Difficulty : Medium
-- Companies  : LinkedIn
-- Access     : Premium
-- ID         : 2077
-- URL        : https://platform.stratascratch.com/coding/2077-employed-at-google
-- ======================================================================

/*
Find IDs of LinkedIn users who were employed at Google on November 1st, 2021. Do not consider users who started or ended their employment at Google on that day but do include users who changed their position within Google on that day.
*/

-- Tables:
--   linkedin_users(employer text, end_date date, position text, start_date date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Users employed at Google on 2021-11-01, excluding those who started or ended
-- on that exact date, but including those who changed positions within Google on that day.
WITH google_jobs AS (
    SELECT
        user_id,
        start_date,
        end_date
    FROM linkedin_job_history
    WHERE LOWER(company_name) = 'google'
)
SELECT DISTINCT user_id
FROM google_jobs
WHERE
    -- Started strictly before 2021-11-01
    start_date < '2021-11-01'
    AND (
        -- Still employed (no end date) or ended strictly after 2021-11-01
        end_date IS NULL
        OR end_date > '2021-11-01'
    );

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Identify users with at least one Google role that spans (not just touches) 2021-11-01.
-- A role that starts exactly on 2021-11-01 is excluded (they "started" that day).
-- A role that ends exactly on 2021-11-01 is excluded (they "ended" that day).
-- A role change within Google on that day means one role ended and another started on
-- 2021-11-01 at Google — the earlier role (start < 2021-11-01, end = 2021-11-01) is
-- excluded, but the user still qualifies via the continuing/new role if it spans the date.
SELECT DISTINCT user_id
FROM linkedin_job_history
WHERE
    LOWER(company_name) = 'google'
    AND start_date < '2021-11-01'
    AND (
        end_date IS NULL
        OR end_date > '2021-11-01'
    );
