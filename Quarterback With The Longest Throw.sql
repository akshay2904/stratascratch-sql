-- ======================================================================
-- Quarterback With The Longest Throw
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9966
-- URL        : https://platform.stratascratch.com/coding/9966-quarterback-with-the-longest-throw
-- ======================================================================

/*
Find the quarterback who threw the longest throw in 2016. Output the quarterback name along with their corresponding longest throw.




The lg column shows the quarterback’s longest completion. If the value has a trailing t, ignore the t and use the numeric part when determining the longest throw.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH parsed AS (
    SELECT
        player,
        CAST(REPLACE(lg, 't', '') AS INTEGER) AS longest_throw
    FROM passing
    WHERE year = 2016
),
ranked AS (
    SELECT
        player,
        longest_throw,
        RANK() OVER (ORDER BY longest_throw DESC) AS rnk
    FROM parsed
)
SELECT player, longest_throw
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    player,
    CAST(REPLACE(lg, 't', '') AS INTEGER) AS longest_throw
FROM passing
WHERE year = 2016
  AND CAST(REPLACE(lg, 't', '') AS INTEGER) = (
      SELECT MAX(CAST(REPLACE(lg, 't', '') AS INTEGER))
      FROM passing
      WHERE year = 2016
  );
