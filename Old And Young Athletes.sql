-- ======================================================================
-- Old And Young Athletes
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN, Google
-- Access     : Premium
-- ID         : 9599
-- URL        : https://platform.stratascratch.com/coding/9599-old-and-young-athletes
-- ======================================================================

/*
Find the old-to-young player ratio for each Olympic games. 'Old' is defined as ages 50 and older and 'young' is defined as athletes 25 or younger. Output the Olympic games, number of old athletes, number of young athletes, and the old-to-young ratio.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH age_counts AS (
    SELECT
        games,
        COUNT(*) FILTER (WHERE age >= 50) AS old_athletes,
        COUNT(*) FILTER (WHERE age <= 25) AS young_athletes
    FROM athletes_events
    WHERE age IS NOT NULL
    GROUP BY games
)
SELECT
    games,
    old_athletes,
    young_athletes,
    ROUND(
        old_athletes::NUMERIC / NULLIF(young_athletes, 0), 4
    ) AS old_to_young_ratio
FROM age_counts
ORDER BY games;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    g.games,
    COALESCE(o.old_count, 0) AS old_athletes,
    COALESCE(y.young_count, 0) AS young_athletes,
    ROUND(
        COALESCE(o.old_count, 0)::NUMERIC / NULLIF(COALESCE(y.young_count, 0), 0), 4
    ) AS old_to_young_ratio
FROM (
    SELECT DISTINCT games
    FROM athletes_events
    WHERE age IS NOT NULL
) g
LEFT JOIN (
    SELECT games, COUNT(*) AS old_count
    FROM athletes_events
    WHERE age >= 50
    GROUP BY games
) o ON g.games = o.games
LEFT JOIN (
    SELECT games, COUNT(*) AS young_count
    FROM athletes_events
    WHERE age <= 25
    GROUP BY games
) y ON g.games = y.games
ORDER BY g.games;
