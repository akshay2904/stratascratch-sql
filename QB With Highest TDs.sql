-- ======================================================================
-- QB With Highest TDs
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9967
-- URL        : https://platform.stratascratch.com/coding/9967-qb-with-highest-tds
-- ======================================================================

/*
Output all the quarterbacks along with the corresponding number of touchdowns (TDs) for 2016. Sort the records based on the number of TDs in descending order.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT
    quarterback,
    SUM(touchdowns) AS total_touchdowns
FROM nfl_stats
WHERE season_year = 2016
  AND position = 'QB'
GROUP BY quarterback
ORDER BY total_touchdowns DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    quarterback,
    (
        SELECT SUM(s2.touchdowns)
        FROM nfl_stats s2
        WHERE s2.quarterback = s1.quarterback
          AND s2.season_year = 2016
          AND s2.position = 'QB'
    ) AS total_touchdowns
FROM nfl_stats s1
WHERE s1.season_year = 2016
  AND s1.position = 'QB'
GROUP BY quarterback
ORDER BY total_touchdowns DESC;
