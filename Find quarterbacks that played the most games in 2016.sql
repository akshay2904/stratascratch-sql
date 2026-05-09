-- ======================================================================
-- Find quarterbacks that played the most games in 2016
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9968
-- URL        : https://platform.stratascratch.com/coding/9968-find-how-many-games-quarterbacks-played-in-2016
-- ======================================================================

/*
Find quarterbacks that played the most games in 2016.
Output all the quarterbacks along with the corresponding number of appearances.
But sort the records by the number of appearances in descending order.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH game_counts AS (
    SELECT 
        name,
        COUNT(*) AS appearances,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM nfl_offensive_stats
    WHERE year = 2016
      AND position = 'QB'
    GROUP BY name
)
SELECT name, appearances
FROM game_counts
WHERE rnk = 1
ORDER BY appearances DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT name, COUNT(*) AS appearances
FROM nfl_offensive_stats
WHERE year = 2016
  AND position = 'QB'
GROUP BY name
HAVING COUNT(*) = (
    SELECT MAX(game_count)
    FROM (
        SELECT COUNT(*) AS game_count
        FROM nfl_offensive_stats
        WHERE year = 2016
          AND position = 'QB'
        GROUP BY name
    ) sub
)
ORDER BY appearances DESC;
