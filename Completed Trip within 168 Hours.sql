-- ======================================================================
-- Completed Trip within 168 Hours
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2134
-- URL        : https://platform.stratascratch.com/coding/2134-completed-trip-within-168-hours
-- ======================================================================

/*
For each city and date, determine the percentage of successful signups in the first 7 days of 2022 that completed a trip within 168 hours of the signup date.




A trip is considered completed if the status column in the trip_details table is marked as 'completed', and the actual_time_of_arrival occurs within 168 hours of the signup timestamp. The driver_id column in trip_details corresponds to the rider_id column in signup_events.
*/

-- Tables:
--   signup_events(city_id text, event_name text, rider_id text, timestamp timestamp without time zone)
--   trip_details(actual_time_of_arrival timestamp without time zone, city_id text, client_id text, client_rating double precision, driver_id text, driver_rating double precision, id text, predicted_eta timestamp without time zone, request_at timestamp without time zone, status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH signups AS (
    -- Filter signups to the first 7 days of 2022
    SELECT
        rider_id,
        city,
        signup_timestamp::date AS signup_date,
        signup_timestamp
    FROM signup_events
    WHERE signup_timestamp >= '2022-01-01'
      AND signup_timestamp <  '2022-01-08'
),
trip_flags AS (
    -- For each signup, flag whether a qualifying completed trip exists
    SELECT
        s.rider_id,
        s.city,
        s.signup_date,
        MAX(CASE
            WHEN t.status = 'completed'
             AND t.actual_time_of_arrival <= s.signup_timestamp + INTERVAL '168 hours'
            THEN 1 ELSE 0
        END) AS completed_flag
    FROM signups s
    LEFT JOIN trip_details t
        ON t.driver_id = s.rider_id
    GROUP BY s.rider_id, s.city, s.signup_date
)
SELECT
    city,
    signup_date,
    COUNT(*)                                                   AS total_signups,
    SUM(completed_flag)                                        AS completed_trips,
    ROUND(
        100.0 * SUM(completed_flag) / NULLIF(COUNT(*), 0), 2
    )                                                          AS pct_completed
FROM trip_flags
GROUP BY city, signup_date
ORDER BY city, signup_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    se.city,
    DATE(se.signup_timestamp)                                   AS signup_date,
    COUNT(DISTINCT se.rider_id)                                 AS total_signups,
    COUNT(DISTINCT CASE
        WHEN td.status = 'completed'
         AND td.actual_time_of_arrival <= se.signup_timestamp + INTERVAL '168 hours'
        THEN se.rider_id
    END)                                                        AS completed_trips,
    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN td.status = 'completed'
             AND td.actual_time_of_arrival <= se.signup_timestamp + INTERVAL '168 hours'
            THEN se.rider_id
        END)
        / NULLIF(COUNT(DISTINCT se.rider_id), 0),
        2
    )                                                           AS pct_completed
FROM signup_events se
LEFT JOIN trip_details td
    ON td.driver_id = se.rider_id
WHERE se.signup_timestamp >= '2022-01-01'
  AND se.signup_timestamp <  '2022-01-08'
GROUP BY se.city, DATE(se.signup_timestamp)
ORDER BY se.city, signup_date;
