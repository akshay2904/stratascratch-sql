-- ======================================================================
-- Date of Highest User Activity
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tiktok
-- Access     : Premium
-- ID         : 2145
-- URL        : https://platform.stratascratch.com/coding/2145-date-of-highest-user-activity
-- ======================================================================

/*
Tiktok want to find out what were the top two most active user days during an advertising campaign they ran in the first week of August 2022 (between the 1st to the 7th).




Identify the two days with the highest user activity during the advertising campaign.

They've also specified that user activity must be measured in terms of unique users.

Output the day, date, and number of users. Be careful that some function can add a padding (whitespaces) around the string, for a solution to be correct you should trim the extra padding.
*/

-- Tables:
--   user_streaks(date_visited date, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_activity AS (
    SELECT
        TRIM(TO_CHAR(activity_date, 'Day')) AS day,
        activity_date,
        COUNT(DISTINCT user_id) AS num_users,
        RANK() OVER (ORDER BY COUNT(DISTINCT user_id) DESC) AS rnk
    FROM user_activity
    WHERE activity_date BETWEEN '2022-08-01' AND '2022-08-07'
    GROUP BY activity_date
)
SELECT
    day,
    activity_date,
    num_users
FROM daily_activity
WHERE rnk <= 2
ORDER BY num_users DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TRIM(TO_CHAR(activity_date, 'Day')) AS day,
    activity_date,
    COUNT(DISTINCT user_id) AS num_users
FROM user_activity
WHERE activity_date BETWEEN '2022-08-01' AND '2022-08-07'
GROUP BY activity_date
ORDER BY num_users DESC
LIMIT 2;
