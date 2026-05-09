-- ======================================================================
-- SMS Confirmations From Users
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10291
-- URL        : https://platform.stratascratch.com/coding/10291-sms-confirmations-from-users
-- ======================================================================

/*
Meta/Facebook sends SMS texts when users attempt 2FA (two-factor authentication) to log in. The fb_sms_sends table logs all SMS texts sent by the system.




However, due to an ETL issue, this table contains some invalid entries, specifically, rows where type = 'confirmation' or other unrelated message types (like friend requests). These records should be ignored.




Only rows with type = 'message' represent actual 2FA texts that were sent to users.




Use the fb_confirmers table to identify which of these messages were successfully confirmed by users.




Calculate the percentage of confirmed SMS 2FA messages (where type = 'message') sent on August 4, 2020.
*/

-- Tables:
--   fb_sms_sends(carrier text, country text, ds date, phone_number bigint, type text)
--   fb_confirmers(date date, phone_number bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH valid_sends AS (
    -- Filter only actual 2FA SMS messages sent on Aug 4, 2020
    SELECT ds, phone_number
    FROM fb_sms_sends
    WHERE type = 'message'
      AND ds = '2020-08-04'
),
confirmed AS (
    -- Get confirmed messages on Aug 4, 2020
    SELECT phone_number
    FROM fb_confirmers
    WHERE ds = '2020-08-04'
)
SELECT
    ROUND(
        100.0 * COUNT(c.phone_number) / COUNT(vs.phone_number),
        2
    ) AS confirmation_rate
FROM valid_sends vs
LEFT JOIN confirmed c
    ON vs.phone_number = c.phone_number;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        100.0 *
        (
            SELECT COUNT(*)
            FROM fb_sms_sends s
            INNER JOIN fb_confirmers c
                ON s.phone_number = c.phone_number
                AND c.ds = '2020-08-04'
            WHERE s.type = 'message'
              AND s.ds = '2020-08-04'
        )
        /
        (
            SELECT COUNT(*)
            FROM fb_sms_sends
            WHERE type = 'message'
              AND ds = '2020-08-04'
        ),
        2
    ) AS confirmation_rate;
