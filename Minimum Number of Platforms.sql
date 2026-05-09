-- ======================================================================
-- Minimum Number of Platforms
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Deloitte, Goldman Sachs
-- Access     : Premium
-- ID         : 2082
-- URL        : https://platform.stratascratch.com/coding/2082-minimum-number-of-platforms
-- ======================================================================

/*
You are given a day worth of scheduled departure and arrival times of trains at one train station. One platform can only accommodate one train from the beginning of the minute it's scheduled to arrive until the end of the minute it's scheduled to depart. Find the minimum number of platforms necessary to accommodate the entire scheduled traffic.
*/

-- Tables:
--   train_arrivals(arrival_time text, train_id bigint)
--   train_departures(departure_time text, train_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Table assumed: train_schedule(train_id, arrival_time, departure_time)
-- Times are stored as integers (minutes from midnight) or as TIME type.
-- A platform is occupied from the START of arrival_minute through END of departure_minute,
-- meaning two trains overlap if their intervals [arrival, departure] overlap inclusively.

WITH events AS (
    -- +1 for each arrival, -1 for each departure
    -- Departures are processed AFTER arrivals in the same minute (arrival has priority)
    SELECT arrival_time  AS event_time, 1  AS event_type FROM train_schedule
    UNION ALL
    SELECT departure_time AS event_time, -1 AS event_type FROM train_schedule
),
running AS (
    SELECT
        event_time,
        event_type,
        SUM(event_type) OVER (
            ORDER BY event_time, event_type DESC  -- arrivals (+1) before departures (-1) at same minute
        ) AS platforms_in_use
    FROM events
)
SELECT MAX(platforms_in_use) AS min_platforms_required
FROM running;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- For each train, count how many other trains are simultaneously present at the station.
-- Train A and Train B overlap if A.arrival <= B.departure AND A.departure >= B.arrival
-- (inclusive on both ends, since platform is held from start of arrival to end of departure minute)

SELECT MAX(concurrent_trains) AS min_platforms_required
FROM (
    SELECT
        t1.train_id,
        COUNT(t2.train_id) AS concurrent_trains
    FROM train_schedule t1
    JOIN train_schedule t2
      ON t1.arrival_time  <= t2.departure_time   -- t1 arrives before or as t2 departs
     AND t1.departure_time >= t2.arrival_time    -- t1 departs after or as t2 arrives
    GROUP BY t1.train_id
) AS overlap_counts;
