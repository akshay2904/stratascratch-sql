-- ======================================================================
-- Apple Product Counts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Apple, Google
-- Access     : Premium
-- ID         : 10141
-- URL        : https://platform.stratascratch.com/coding/10141-apple-product-counts
-- ======================================================================

/*
We’re analyzing user data to understand how popular Apple devices are among users who have performed at least one event on the platform. Specifically, we want to measure this popularity across different languages. Count the number of distinct users using Apple devices —limited to "macbook pro", "iphone 5s", and "ipad air" — and compare it to the total number of users per language.




Present the results with the language, the number of Apple users, and the total number of users for each language. Finally, sort the results so that languages with the highest total user count appear first.
*/

-- Tables:
--   playbook_events(device text, event_name text, event_type text, location text, occurred_at timestamp without time zone, user_id bigint)
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH active_users AS (
    -- Get distinct users who have performed at least one event
    SELECT DISTINCT user_id
    FROM events
),
user_base AS (
    SELECT
        u.language,
        u.user_id,
        -- Flag users with Apple devices of interest
        CASE
            WHEN LOWER(u.device) IN ('macbook pro', 'iphone 5s', 'ipad air') THEN 1
            ELSE 0
        END AS is_apple_user
    FROM users u
    INNER JOIN active_users au ON u.user_id = au.user_id
)
SELECT
    language,
    COUNT(DISTINCT CASE WHEN is_apple_user = 1 THEN user_id END) AS apple_users,
    COUNT(DISTINCT user_id)                                        AS total_users
FROM user_base
GROUP BY language
ORDER BY total_users DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.language,
    -- Count distinct Apple device users per language
    COUNT(DISTINCT CASE
        WHEN LOWER(u.device) IN ('macbook pro', 'iphone 5s', 'ipad air') THEN u.user_id
    END) AS apple_users,
    -- Count all distinct active users per language
    COUNT(DISTINCT u.user_id) AS total_users
FROM users u
WHERE u.user_id IN (
    -- Only users who have performed at least one event
    SELECT DISTINCT user_id
    FROM events
)
GROUP BY u.language
ORDER BY total_users DESC;
