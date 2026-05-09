-- ======================================================================
-- Caller History
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Etsy, Amazon
-- Access     : Premium
-- ID         : 2132
-- URL        : https://platform.stratascratch.com/coding/2132-caller-history
-- ======================================================================

/*
Given a phone log table that has information about callers' call history, find out the callers whose first and last calls were to the same person on a given day. Output the caller ID, recipient ID, and the date called.
*/

-- Tables:
--   caller_history(caller_id bigint, date_called timestamp without time zone, recipient_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_calls AS (
    SELECT
        caller_id,
        recipient_id,
        DATE(date_called) AS call_date,
        ROW_NUMBER() OVER (PARTITION BY caller_id, DATE(date_called) ORDER BY date_called ASC)  AS rn_first,
        ROW_NUMBER() OVER (PARTITION BY caller_id, DATE(date_called) ORDER BY date_called DESC) AS rn_last
    FROM phone_log
)
SELECT DISTINCT
    f.caller_id,
    f.recipient_id,
    f.call_date AS date_called
FROM ranked_calls f
JOIN ranked_calls l
    ON  f.caller_id   = l.caller_id
    AND f.call_date   = l.call_date
    AND f.recipient_id = l.recipient_id  -- first and last recipient match
    AND f.rn_first = 1
    AND l.rn_last  = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    caller_id,
    recipient_id,
    DATE(date_called) AS date_called
FROM phone_log p1
WHERE
    -- this row is the first call of the day for this caller
    date_called = (
        SELECT MIN(date_called)
        FROM phone_log p2
        WHERE p2.caller_id = p1.caller_id
          AND DATE(p2.date_called) = DATE(p1.date_called)
    )
    AND
    -- the recipient on the first call matches the recipient on the last call
    recipient_id = (
        SELECT recipient_id
        FROM phone_log p3
        WHERE p3.caller_id = p1.caller_id
          AND DATE(p3.date_called) = DATE(p1.date_called)
          AND p3.date_called = (
              SELECT MAX(date_called)
              FROM phone_log p4
              WHERE p4.caller_id = p1.caller_id
                AND DATE(p4.date_called) = DATE(p1.date_called)
          )
        LIMIT 1  -- in case of ties on last call timestamp
    );
