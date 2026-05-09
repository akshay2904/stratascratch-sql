-- ======================================================================
-- Blocked Users
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2084
-- URL        : https://platform.stratascratch.com/coding/2084-blocked-users
-- ======================================================================

/*
You are given a table of users who have been blocked from Facebook, together with the date, duration, and the reason for the blocking. The duration is expressed as the number of days after blocking date and if this field is empty, this means that a user is blocked permanently.

For each blocking reason, count how many users were blocked in December 2021. Include both the users who were blocked in December 2021 and those who were blocked before but remained blocked for at least a part of December 2021.
*/

-- Tables:
--   fb_blocked_users(block_date date, block_duration double precision, block_reason text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH december_blocked AS (
    SELECT
        blocking_reason,
        user_id,
        blocking_date,
        -- Compute unblock date; NULL means permanent (treat as infinity)
        CASE
            WHEN duration IS NULL THEN NULL
            ELSE blocking_date + duration
        END AS unblock_date
    FROM fb_blocked_users
    WHERE
        -- Block started before or during December 2021
        blocking_date < DATE '2022-01-01'
        AND (
            -- Block ends in or after December 2021, OR is permanent
            duration IS NULL
            OR blocking_date + duration >= DATE '2021-12-01'
        )
)
SELECT
    blocking_reason,
    COUNT(DISTINCT user_id) AS num_blocked_users
FROM december_blocked
GROUP BY blocking_reason
ORDER BY blocking_reason;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    blocking_reason,
    COUNT(DISTINCT user_id) AS num_blocked_users
FROM fb_blocked_users
WHERE
    -- User was blocked before end of December 2021
    blocking_date < '2022-01-01'
    AND (
        -- Block is permanent (duration is NULL)
        duration IS NULL
        OR
        -- Block ends on or after December 1, 2021
        (blocking_date + duration) >= '2021-12-01'
    )
GROUP BY blocking_reason
ORDER BY blocking_reason;
