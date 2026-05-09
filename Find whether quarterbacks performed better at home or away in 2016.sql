-- ======================================================================
-- Find whether quarterbacks performed better at home or away in 2016
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9964
-- URL        : https://platform.stratascratch.com/coding/9964-find-whether-quarterbacks-performed-better-at-home-or-away-in-2016
-- ======================================================================

/*
Find whether quarterbacks performed better at home or away in 2016.
Output the quarterback along with the corresponding maximum home and away points.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH home_away AS (
    SELECT
        quarterback,
        MAX(CASE WHEN home_away = 'Home' THEN fantasy_points END) AS max_home_points,
        MAX(CASE WHEN home_away = 'Away' THEN fantasy_points END) AS max_away_points
    FROM nfl_quarterbacks
    WHERE EXTRACT(YEAR FROM game_date) = 2016
    GROUP BY quarterback
)
SELECT
    quarterback,
    max_home_points,
    max_away_points,
    CASE
        WHEN max_home_points > max_away_points THEN 'Home'
        WHEN max_away_points > max_home_points THEN 'Away'
        ELSE 'Tie'
    END AS better_performance
FROM home_away
ORDER BY quarterback;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    h.quarterback,
    h.max_home_points,
    a.max_away_points,
    CASE
        WHEN h.max_home_points > a.max_away_points THEN 'Home'
        WHEN a.max_away_points > h.max_home_points THEN 'Away'
        ELSE 'Tie'
    END AS better_performance
FROM
    (
        SELECT quarterback, MAX(fantasy_points) AS max_home_points
        FROM nfl_quarterbacks
        WHERE home_away = 'Home'
          AND EXTRACT(YEAR FROM game_date) = 2016
        GROUP BY quarterback
    ) h
JOIN
    (
        SELECT quarterback, MAX(fantasy_points) AS max_away_points
        FROM nfl_quarterbacks
        WHERE home_away = 'Away'
          AND EXTRACT(YEAR FROM game_date) = 2016
        GROUP BY quarterback
    ) a
ON h.quarterback = a.quarterback
ORDER BY h.quarterback;
