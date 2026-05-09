-- ======================================================================
-- Average Number Of Points
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9965
-- URL        : https://platform.stratascratch.com/coding/9965-average-number-of-points
-- ======================================================================

/*
Find the average number of points earned per quarterback appearance in each year. Each row represents one appearance of one quarterback in one game. Output the year and quarterback name along with the corresponding average points.
Sort records by the year in descending order.
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
        EXTRACT(YEAR FROM g.date)::INT AS year,
        nfl.player_name AS quarterback,
        AVG(nfl.points) OVER (
            PARTITION BY EXTRACT(YEAR FROM g.date), nfl.player_name
        ) AS avg_points
    FROM nfl_quarterbacks nfl
    JOIN games g ON nfl.game_id = g.game_id
)
SELECT DISTINCT
    year,
    quarterback,
    avg_points
FROM qb_stats
ORDER BY year DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM g.date)::INT AS year,
    nfl.player_name AS quarterback,
    AVG(nfl.points) AS avg_points
FROM nfl_quarterbacks nfl
JOIN games g ON nfl.game_id = g.game_id
GROUP BY
    EXTRACT(YEAR FROM g.date),
    nfl.player_name
ORDER BY year DESC;
