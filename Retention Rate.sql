-- ======================================================================
-- Retention Rate
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta, Salesforce
-- Access     : Premium
-- ID         : 2053
-- URL        : https://platform.stratascratch.com/coding/2053-retention-rate
-- ======================================================================

/*
You are given a dataset that tracks user activity. The dataset includes information about the date of user activity, the account_id associated with the activity, and the user_id of the user performing the activity. Each row in the dataset represents a user’s activity on a specific date for a particular account_id.




Your task is to calculate the monthly retention rate for users for each account_id for December 2020 and January 2021. The retention rate is defined as the percentage of users active in a given month who have activity in any future month.




For instance, a user is considered retained for December 2020 if they have activity in December 2020 and any subsequent month (e.g., January 2021 or later). Similarly, a user is retained for January 2021 if they have activity in January 2021 and any later month (e.g., February 2021 or later).




The final output should include the account_id and the ratio of the retention rate in January 2021 to the retention rate in December 2020 for each account_id. If there are no users retained in December 2020, the retention rate ratio should be set to 0.
*/

-- Tables:
--   sf_events(account_id character varying, record_date date, user_id character varying)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_months AS (
    -- Get distinct user-month combinations
    SELECT DISTINCT
        account_id,
        user_id,
        DATE_TRUNC('month', date) AS activity_month
    FROM user_activity
),
future_activity AS (
    -- For each user/account, find if they have activity in any future month
    SELECT
        um.account_id,
        um.user_id,
        um.activity_month,
        -- Check if user has any activity after current month
        MAX(CASE WHEN um2.activity_month > um.activity_month THEN 1 ELSE 0 END) AS has_future_activity
    FROM user_months um
    LEFT JOIN user_months um2
        ON um.account_id = um2.account_id
        AND um.user_id = um2.user_id
        AND um2.activity_month > um.activity_month
    WHERE um.activity_month IN (
        DATE_TRUNC('month', DATE '2020-12-01'),
        DATE_TRUNC('month', DATE '2021-01-01')
    )
    GROUP BY um.account_id, um.user_id, um.activity_month
),
monthly_retention AS (
    SELECT
        account_id,
        activity_month,
        -- Retention rate = retained users / total active users
        SUM(has_future_activity)::FLOAT / NULLIF(COUNT(*), 0) AS retention_rate
    FROM future_activity
    GROUP BY account_id, activity_month
)
SELECT
    dec_data.account_id,
    CASE
        WHEN COALESCE(dec_data.retention_rate, 0) = 0 THEN 0
        ELSE ROUND(
            (COALESCE(jan_data.retention_rate, 0) / dec_data.retention_rate)::NUMERIC, 4
        )
    END AS retention_rate_ratio
FROM
    (SELECT account_id, retention_rate FROM monthly_retention
     WHERE activity_month = DATE_TRUNC('month', DATE '2020-12-01')) dec_data
LEFT JOIN
    (SELECT account_id, retention_rate FROM monthly_retention
     WHERE activity_month = DATE_TRUNC('month', DATE '2021-01-01')) jan_data
    ON dec_data.account_id = jan_data.account_id
ORDER BY dec_data.account_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    dec_stats.account_id,
    CASE
        WHEN dec_stats.total_users = 0 OR dec_stats.retained_users = 0 THEN 0
        ELSE ROUND(
            (
                COALESCE(jan_stats.retained_users, 0)::FLOAT
                / NULLIF(jan_stats.total_users, 0)
            )
            /
            (
                dec_stats.retained_users::FLOAT
                / dec_stats.total_users
            )::NUMERIC, 4
        )
    END AS retention_rate_ratio
FROM
    (
        -- December 2020 retention stats
        SELECT
            account_id,
            COUNT(DISTINCT user_id) AS total_users,
            COUNT(DISTINCT CASE
                WHEN user_id IN (
                    -- Users with activity after December 2020
                    SELECT DISTINCT user_id
                    FROM user_activity
                    WHERE DATE_TRUNC('month', date) > DATE_TRUNC('month', DATE '2020-12-01')
                      AND account_id = dec_active.account_id
                ) THEN user_id
            END) AS retained_users
        FROM (
            SELECT DISTINCT account_id, user_id
            FROM user_activity
            WHERE DATE_TRUNC('month', date) = DATE_TRUNC('month', DATE '2020-12-01')
        ) dec_active
        GROUP BY account_id
    ) dec_stats
LEFT JOIN
    (
        -- January 2021 retention stats
        SELECT
            account_id,
            COUNT(DISTINCT user_id) AS total_users,
            COUNT(DISTINCT CASE
                WHEN user_id IN (
                    -- Users with activity after January 2021
                    SELECT DISTINCT user_id
                    FROM user_activity
                    WHERE DATE_TRUNC('month', date) > DATE_TRUNC('month', DATE '2021-01-01')
                      AND account_id = jan_active.account_id
                ) THEN user_id
            END) AS retained_users
        FROM (
            SELECT DISTINCT account_id, user_id
            FROM user_activity
            WHERE DATE_TRUNC('month', date) = DATE_TRUNC('month', DATE '2021-01-01')
        ) jan_active
        GROUP BY account_id
    ) jan_stats
    ON dec_stats.account_id = jan_stats.account_id
ORDER BY dec_stats.account_id;
