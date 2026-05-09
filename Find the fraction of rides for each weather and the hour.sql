-- ======================================================================
-- Find the fraction of rides for each weather and the hour
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 10019
-- URL        : https://platform.stratascratch.com/coding/10019-find-the-probability-of-ordering-a-ride-based-on-the-weather-and-the-hour
-- ======================================================================

/*
Find the fraction (percentage divided by 100) of rides each weather-hour combination constitutes among all weather-hour combinations.

Output the weather, hour along with the corresponding fraction.
*/

-- Tables:
--   lyft_rides(gasoline_cost double precision, hour bigint, index bigint, travel_distance double precision, weather text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    weather,
    hour,
    COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () AS fraction
FROM
    trip_data
GROUP BY
    weather, hour
ORDER BY
    weather, hour;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    weather,
    hour,
    COUNT(*) * 1.0 / (SELECT COUNT(*) FROM trip_data) AS fraction
FROM
    trip_data
GROUP BY
    weather, hour
ORDER BY
    weather, hour;
