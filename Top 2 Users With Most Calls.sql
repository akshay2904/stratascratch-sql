-- ======================================================================
-- Top 2 Users With Most Calls
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Ring Central
-- Access     : Premium
-- ID         : 2019
-- URL        : https://platform.stratascratch.com/coding/2019-top-2-users-with-most-calls
-- ======================================================================

/*
Return the top 2 users in each company that called the most. Output the company_id, user_id, and the user's rank. If there are multiple users in the same rank, keep all of them.
*/

-- Tables:
--   rc_calls(call_date timestamp without time zone, call_id bigint, user_id bigint)
--   rc_users(company_id bigint, status text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH call_counts AS (
    SELECT
        company_id,
        user_id,
        COUNT(*) AS total_calls,
        DENSE_RANK() OVER (PARTITION BY company_id ORDER BY COUNT(*) DESC) AS rnk
    FROM calls
    GROUP BY company_id, user_id
)
SELECT
    company_id,
    user_id,
    rnk AS rank
FROM call_counts
WHERE rnk <= 2
ORDER BY company_id, rnk;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c1.company_id,
    c1.user_id,
    -- Count how many distinct call totals are strictly greater than this user's total (within same company)
    -- +1 gives the rank
    (
        SELECT COUNT(DISTINCT c2.total_calls)
        FROM (
            SELECT company_id, user_id, COUNT(*) AS total_calls
            FROM calls
            GROUP BY company_id, user_id
        ) c2
        WHERE c2.company_id = c1.company_id
          AND c2.total_calls > c1.total_calls
    ) + 1 AS rank
FROM (
    SELECT company_id, user_id, COUNT(*) AS total_calls
    FROM calls
    GROUP BY company_id, user_id
) c1
WHERE (
    -- Keep only users whose rank is <= 2
    SELECT COUNT(DISTINCT c2.total_calls)
    FROM (
        SELECT company_id, user_id, COUNT(*) AS total_calls
        FROM calls
        GROUP BY company_id, user_id
    ) c2
    WHERE c2.company_id = c1.company_id
      AND c2.total_calls > c1.total_calls
) + 1 <= 2
ORDER BY c1.company_id,
         rank;
