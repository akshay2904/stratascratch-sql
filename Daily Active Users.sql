-- ======================================================================
-- Daily Active Users
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Workday, Salesforce
-- Access     : Premium
-- ID         : 2050
-- URL        : https://platform.stratascratch.com/coding/2050-daily-active-users
-- ======================================================================

/*
Find the average daily active users for January 2021 for each account. Your output should have account_id and the average daily count for that account.
*/

-- Tables:
--   sf_events(account_id character varying, record_date date, user_id character varying)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_counts AS (
    SELECT
        account_id,
        DATE(date) AS activity_date,
        COUNT(DISTINCT user_id) AS daily_active_users
    FROM sf_events
    WHERE DATE(date) >= '2021-01-01'
      AND DATE(date) < '2021-02-01'
    GROUP BY account_id, DATE(date)
)
SELECT
    account_id,
    AVG(daily_active_users) AS avg_daily_active_users
FROM daily_counts
GROUP BY account_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    account_id,
    AVG(daily_user_count) AS avg_daily_active_users
FROM (
    SELECT
        account_id,
        DATE(date) AS activity_date,
        COUNT(DISTINCT user_id) AS daily_user_count
    FROM sf_events
    WHERE EXTRACT(YEAR FROM date) = 2021
      AND EXTRACT(MONTH FROM date) = 1
    GROUP BY account_id, DATE(date)
) AS daily_counts
GROUP BY account_id;
