-- ======================================================================
-- New And Existing Users
-- ======================================================================
-- Difficulty : Hard
-- Companies  : IBM, Apple, Microsoft
-- Access     : Premium
-- ID         : 2028
-- URL        : https://platform.stratascratch.com/coding/2028-new-and-existing-users
-- ======================================================================

/*
Calculate the share of new and existing users for each month in the table. Output the month, share of new users, and share of existing users as a ratio.




New users are defined as users who started using services in the current month (there is no usage history in previous months). Existing users are users who used services in the current month, and who also used services in any prior month of 2020.




Assume that the dates are all from the year 2020 and that users are contained in user_id column.
*/

-- Tables:
--   fact_events(client_id text, customer_id text, event_id bigint, event_type text, id bigint, time_id date, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_users AS (
    -- Get distinct user-month combinations
    SELECT DISTINCT
        user_id,
        DATE_TRUNC('month', time_id)::DATE AS month
    FROM fact_events
),
user_first_month AS (
    -- Determine the first month each user appeared
    SELECT
        user_id,
        MIN(month) AS first_month
    FROM monthly_users
    GROUP BY user_id
),
monthly_stats AS (
    SELECT
        mu.month,
        COUNT(DISTINCT mu.user_id) AS total_users,
        -- New users: their first month equals the current month
        COUNT(DISTINCT CASE WHEN uf.first_month = mu.month THEN mu.user_id END) AS new_users,
        -- Existing users: they appeared before this month
        COUNT(DISTINCT CASE WHEN uf.first_month < mu.month THEN mu.user_id END) AS existing_users
    FROM monthly_users mu
    JOIN user_first_month uf ON mu.user_id = uf.user_id
    GROUP BY mu.month
)
SELECT
    month,
    ROUND(new_users::NUMERIC      / total_users, 2) AS share_new_users,
    ROUND(existing_users::NUMERIC / total_users, 2) AS share_existing_users
FROM monthly_stats
ORDER BY month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    month,
    ROUND(new_users::NUMERIC      / total_users, 2) AS share_new_users,
    ROUND(existing_users::NUMERIC / total_users, 2) AS share_existing_users
FROM (
    SELECT
        DATE_TRUNC('month', e.time_id)::DATE AS month,
        COUNT(DISTINCT e.user_id) AS total_users,
        -- New users: no activity in any prior month
        COUNT(DISTINCT CASE
            WHEN NOT EXISTS (
                SELECT 1
                FROM fact_events e2
                WHERE e2.user_id = e.user_id
                  AND DATE_TRUNC('month', e2.time_id) < DATE_TRUNC('month', e.time_id)
            ) THEN e.user_id
        END) AS new_users,
        -- Existing users: had activity in at least one prior month
        COUNT(DISTINCT CASE
            WHEN EXISTS (
                SELECT 1
                FROM fact_events e2
                WHERE e2.user_id = e.user_id
                  AND DATE_TRUNC('month', e2.time_id) < DATE_TRUNC('month', e.time_id)
            ) THEN e.user_id
        END) AS existing_users
    FROM fact_events e
    GROUP BY DATE_TRUNC('month', e.time_id)::DATE
) sub
ORDER BY month;
