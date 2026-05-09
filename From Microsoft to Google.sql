-- ======================================================================
-- From Microsoft to Google
-- ======================================================================
-- Difficulty : Hard
-- Companies  : LinkedIn
-- Access     : Premium
-- ID         : 2078
-- URL        : https://platform.stratascratch.com/coding/2078-from-microsoft-to-google
-- ======================================================================

/*
Consider all LinkedIn users who, at some point, worked at Microsoft. For how many of them was Google their next employer right after Microsoft (no employers in between)?
*/

-- Tables:
--   linkedin_users(employer text, end_date date, position text, start_date date, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ms_jobs AS (
    SELECT
        user_id,
        end_date,
        LEAD(employer) OVER (PARTITION BY user_id ORDER BY start_date) AS next_employer
    FROM linkedin_jobs
    WHERE employer = 'Microsoft'
)
SELECT COUNT(DISTINCT user_id) AS num_users
FROM ms_jobs
WHERE next_employer = 'Google';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(DISTINCT ms.user_id) AS num_users
FROM linkedin_jobs ms
JOIN linkedin_jobs g
  ON ms.user_id = g.user_id
 AND g.employer = 'Google'
 AND g.start_date > ms.start_date   -- Google job starts after Microsoft job
WHERE ms.employer = 'Microsoft'
  -- No other job exists between the Microsoft and Google positions
  AND NOT EXISTS (
      SELECT 1
      FROM linkedin_jobs mid
      WHERE mid.user_id = ms.user_id
        AND mid.start_date > ms.start_date
        AND mid.start_date < g.start_date
        AND mid.employer NOT IN ('Microsoft', 'Google')
  );
