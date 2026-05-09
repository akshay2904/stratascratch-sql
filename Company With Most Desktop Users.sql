-- ======================================================================
-- Company With Most Desktop Users
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Linux, Microsoft
-- Access     : Premium
-- ID         : 2027
-- URL        : https://platform.stratascratch.com/coding/2027-top-company-where-users-use-desktop-only
-- ======================================================================

/*
Write a query that returns the customer_id of the company with the highest number of users who have exclusively used desktop. Users who may have used mobile at any point are ignored, but companies may still have mobile users.
*/

-- Tables:
--   fact_events(client_id text, customer_id text, event_id bigint, event_type text, id bigint, time_id date, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH desktop_only_users AS (
    -- Users who have NEVER used mobile
    SELECT user_id, company_id
    FROM users
    WHERE user_id NOT IN (
        SELECT DISTINCT user_id FROM events WHERE device_type = 'mobile'
    )
    AND user_id IN (
        SELECT DISTINCT user_id FROM events WHERE device_type = 'desktop'
    )
),
company_counts AS (
    SELECT
        company_id,
        COUNT(*) AS desktop_only_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM desktop_only_users
    GROUP BY company_id
)
SELECT company_id AS customer_id
FROM company_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT company_id AS customer_id
FROM users
WHERE
    -- User has used desktop at least once
    user_id IN (
        SELECT DISTINCT user_id FROM events WHERE device_type = 'desktop'
    )
    -- User has NEVER used mobile
    AND user_id NOT IN (
        SELECT DISTINCT user_id FROM events WHERE device_type = 'mobile'
    )
GROUP BY company_id
HAVING COUNT(*) = (
    -- Find the maximum count across all companies
    SELECT MAX(cnt)
    FROM (
        SELECT company_id, COUNT(*) AS cnt
        FROM users
        WHERE
            user_id IN (
                SELECT DISTINCT user_id FROM events WHERE device_type = 'desktop'
            )
            AND user_id NOT IN (
                SELECT DISTINCT user_id FROM events WHERE device_type = 'mobile'
            )
        GROUP BY company_id
    ) sub
);
