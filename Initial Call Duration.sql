-- ======================================================================
-- Initial Call Duration
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Redfin
-- Access     : Premium
-- ID         : 2021
-- URL        : https://platform.stratascratch.com/coding/2021-initial-call-duration
-- ======================================================================

/*
Redfin helps clients to find agents. Each client will have a unique request_id and each request_id has several calls. For each request_id, the first call is an “initial call” and all the following calls are “update calls”.  What's the average call duration for all initial calls?
*/

-- Tables:
--   redfin_call_tracking(call_duration bigint, created_on timestamp without time zone, id bigint, request_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_calls AS (
    SELECT
        request_id,
        call_duration,
        ROW_NUMBER() OVER (PARTITION BY request_id ORDER BY created_at) AS call_rank
    FROM redfin_calls
)
SELECT
    AVG(call_duration) AS avg_initial_call_duration
FROM ranked_calls
WHERE call_rank = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    AVG(call_duration) AS avg_initial_call_duration
FROM redfin_calls
WHERE (request_id, created_at) IN (
    SELECT
        request_id,
        MIN(created_at) AS first_call_time
    FROM redfin_calls
    GROUP BY request_id
);
