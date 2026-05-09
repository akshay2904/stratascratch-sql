-- ======================================================================
-- Find quarterbacks who have achieved high average game points during their careers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9961
-- URL        : https://platform.stratascratch.com/coding/9961-find-quarterbacks-who-have-achieved-high-average-game-points-during-their-careers
-- ======================================================================

/*
Find quarterbacks who have achieved high average game points during their careers.
Output the quarterback along with the corresponding average points.
Order records by average points in descending order.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH qb_stats AS (
    SELECT
        player,
        AVG(points) AS avg_points
    FROM nfl_stadium_attendance
    WHERE home_qb_name IS NOT NULL
       OR away_qb_name IS NOT NULL
    GROUP BY player
),
ranked AS (
    SELECT
        player,
        avg_points,
        AVG(avg_points) OVER () AS overall_avg
    FROM qb_stats
)
SELECT
    player,
    ROUND(avg_points::NUMERIC, 2) AS avg_points
FROM ranked
WHERE avg_points > overall_avg
ORDER BY avg_points DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    player,
    ROUND(AVG(points)::NUMERIC, 2) AS avg_points
FROM nfl_stadium_attendance
GROUP BY player
HAVING AVG(points) > (
    SELECT AVG(points)
    FROM nfl_stadium_attendance
)
ORDER BY avg_points DESC;
