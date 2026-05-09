-- ======================================================================
-- Rush Hour Calls
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Redfin
-- Access     : Premium
-- ID         : 2023
-- URL        : https://platform.stratascratch.com/coding/2023-rush-hour-calls
-- ======================================================================

/*
Redfin helps clients to find agents. Each client will have a unique request_id and each request_id has several calls. For each request_id, the first call is an “initial call” and all the following calls are “update calls”.  How many customers have called 3 or more times between 3 PM and 6 PM (initial and update calls combined)?
*/

-- Tables:
--   redfin_call_tracking(call_duration bigint, created_on timestamp without time zone, id bigint, request_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes table: redfin_call_tracking(request_id, created_on TIMESTAMP, ...)
WITH calls_in_window AS (
    SELECT
        request_id,
        COUNT(*) AS call_count
    FROM redfin_call_tracking
    WHERE EXTRACT(HOUR FROM created_on) >= 15   -- 3 PM = 15:00
      AND EXTRACT(HOUR FROM created_on) < 18    -- before 6 PM = 18:00
    GROUP BY request_id
)
SELECT COUNT(*) AS customers_3_or_more_calls
FROM calls_in_window
WHERE call_count >= 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(*) AS customers_3_or_more_calls
FROM (
    SELECT request_id
    FROM redfin_call_tracking
    WHERE EXTRACT(HOUR FROM created_on) >= 15
      AND EXTRACT(HOUR FROM created_on) < 18
    GROUP BY request_id
    HAVING COUNT(*) >= 3
) AS qualified_customers;
