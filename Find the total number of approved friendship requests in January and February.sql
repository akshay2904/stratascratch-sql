-- ======================================================================
-- Find the total number of approved friendship requests in January and February
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9789
-- URL        : https://platform.stratascratch.com/coding/9789-find-the-total-number-of-approved-friendship-requests-in-january-and-february
-- ======================================================================

/*
Find the total number of approved friendship requests in January and February.
*/

-- Tables:
--   facebook_friendship_requests(date_approved date, date_sent date, receiver bigint, sender bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    COUNT(*) AS total_approved_requests
FROM friend_requests
WHERE status = 'approved'
  AND EXTRACT(MONTH FROM request_date) IN (1, 2);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    SUM(monthly_count) AS total_approved_requests
FROM (
    SELECT
        EXTRACT(MONTH FROM request_date) AS request_month,
        COUNT(*) AS monthly_count
    FROM friend_requests
    WHERE status = 'approved'
      AND EXTRACT(MONTH FROM request_date) IN (1, 2)
    GROUP BY EXTRACT(MONTH FROM request_date)
) AS monthly_totals;
