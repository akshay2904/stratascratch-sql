-- ======================================================================
-- Actual vs Predicted Arrival Time
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft, Uber
-- Access     : Premium
-- ID         : 2135
-- URL        : https://platform.stratascratch.com/coding/2135-actual-vs-predicted-arrival-time
-- ======================================================================

/*
Calculate the 90th percentile difference between Actual and Predicted arrival time in minutes for all completed trips within the first 14 days of 2022.
*/

-- Tables:
--   trip_details(actual_time_of_arrival timestamp without time zone, city_id text, client_id text, client_rating double precision, driver_id text, driver_rating double precision, id text, predicted_eta timestamp without time zone, request_at timestamp without time zone, status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH trip_differences AS (
    SELECT
        EXTRACT(EPOCH FROM (actual_arrival_time - predicted_arrival_time)) / 60.0 AS diff_minutes
    FROM trips
    WHERE status = 'completed'
      AND actual_arrival_time >= '2022-01-01'
      AND actual_arrival_time <  '2022-01-15'  -- first 14 days: Jan 1–14
),
percentile_calc AS (
    SELECT
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY diff_minutes) AS p90_diff_minutes
    FROM trip_differences
)
SELECT
    ROUND(p90_diff_minutes::numeric, 2) AS p90_arrival_diff_minutes
FROM percentile_calc;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        CAST(
            PERCENTILE_CONT(0.90) WITHIN GROUP (
                ORDER BY
                    EXTRACT(EPOCH FROM (actual_arrival_time - predicted_arrival_time)) / 60.0
            ) AS numeric
        ), 2
    ) AS p90_arrival_diff_minutes
FROM trips
WHERE status = 'completed'
  AND actual_arrival_time >= '2022-01-01 00:00:00'
  AND actual_arrival_time <= '2022-01-14 23:59:59';  -- explicitly bound to 14th day end
