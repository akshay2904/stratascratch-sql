-- ======================================================================
-- Recent Refinance Submissions
-- ======================================================================
-- Difficulty : Medium
-- Companies  : MetLife, Credit Karma
-- Access     : Premium
-- ID         : 2003
-- URL        : https://platform.stratascratch.com/coding/2003-recent-refinance-submissions
-- ======================================================================

/*
Write a query to return the total loan balance for each user based on their most recent "Refinance" submission. The submissions table joins to the loans table using loan_id from submissions and id from loans.
*/

-- Tables:
--   loans(created_at date, id bigint, status text, type text, user_id bigint)
--   submissions(balance double precision, id bigint, interest_rate double precision, loan_id bigint, rate_type text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_refinances AS (
    SELECT
        s.user_id,
        s.loan_id,
        s.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY s.user_id
            ORDER BY s.created_at DESC
        ) AS rn
    FROM submissions s
    WHERE s.type = 'Refinance'
),
most_recent AS (
    SELECT user_id, loan_id
    FROM ranked_refinances
    WHERE rn = 1
)
SELECT
    mr.user_id,
    SUM(l.balance) AS total_loan_balance
FROM most_recent mr
JOIN loans l ON l.id = mr.loan_id
GROUP BY mr.user_id
ORDER BY mr.user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.user_id,
    SUM(l.balance) AS total_loan_balance
FROM submissions s
JOIN loans l ON l.id = s.loan_id
WHERE s.type = 'Refinance'
  AND s.created_at = (
      -- Find the most recent Refinance submission date for this user
      SELECT MAX(s2.created_at)
      FROM submissions s2
      WHERE s2.user_id = s.user_id
        AND s2.type = 'Refinance'
  )
GROUP BY s.user_id
ORDER BY s.user_id;
