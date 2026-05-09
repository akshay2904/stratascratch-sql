-- ======================================================================
-- Norwegian Alpine Skiers
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9955
-- URL        : https://platform.stratascratch.com/coding/9955-norwegian-alpine-skiers
-- ======================================================================

/*
Find all Norwegian alpine skiers who participated in 1992 but didn't participate in 1994. Output unique athlete names.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH participation AS (
    SELECT
        athlete,
        MAX(CASE WHEN year = 1992 THEN 1 ELSE 0 END) AS in_1992,
        MAX(CASE WHEN year = 1994 THEN 1 ELSE 0 END) AS in_1994
    FROM
        winter_games
    WHERE
        sport = 'Alpine Skiing'
        AND country = 'Norway'
        AND year IN (1992, 1994)
    GROUP BY
        athlete
)
SELECT DISTINCT athlete
FROM participation
WHERE in_1992 = 1
  AND in_1994 = 0;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT athlete
FROM winter_games
WHERE sport = 'Alpine Skiing'
  AND country = 'Norway'
  AND year = 1992
  AND athlete NOT IN (
      SELECT DISTINCT athlete
      FROM winter_games
      WHERE sport = 'Alpine Skiing'
        AND country = 'Norway'
        AND year = 1994
  );
