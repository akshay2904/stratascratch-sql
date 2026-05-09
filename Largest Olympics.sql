-- ======================================================================
-- Largest Olympics
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9942
-- URL        : https://platform.stratascratch.com/coding/9942-largest-olympics
-- ======================================================================

/*
Find the Olympics with the highest number of unique athletes. The Olympics game is a combination of the year and the season, and is found in the games column. Output the Olympics along with the corresponding number of athletes. The id column uniquely identifies an athlete.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH athlete_counts AS (
    SELECT 
        games,
        COUNT(DISTINCT id) AS num_athletes,
        RANK() OVER (ORDER BY COUNT(DISTINCT id) DESC) AS rnk
    FROM athlete_events
    GROUP BY games
)
SELECT games, num_athletes
FROM athlete_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT games, COUNT(DISTINCT id) AS num_athletes
FROM athlete_events
GROUP BY games
HAVING COUNT(DISTINCT id) = (
    SELECT MAX(athlete_count)
    FROM (
        SELECT COUNT(DISTINCT id) AS athlete_count
        FROM athlete_events
        GROUP BY games
    ) AS sub
);
