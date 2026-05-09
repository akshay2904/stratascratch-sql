-- ======================================================================
-- QBs With Most Attempts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9970
-- URL        : https://platform.stratascratch.com/coding/9970-qbs-with-most-attempts
-- ======================================================================

/*
Find quarterbacks that made most attempts to throw the ball in 2016.
Output the quarterback along with the corresponding number of attempts.
Sort records by the number of attempts in descending order.
*/

-- Tables:
--   qbstats_2015_2016(att bigint, cmp bigint, game_points bigint, home_away text, int bigint, lg text, loss bigint, qb text, rate double precision, sack bigint, td bigint, yds bigint, year bigint, ypa double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT player, SUM(attempt_number) AS total_attempts
FROM nfl_quarterback_stats
WHERE year = 2016
GROUP BY player
ORDER BY total_attempts DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT player, SUM(attempt_number) AS total_attempts
FROM (
    SELECT player, attempt_number
    FROM nfl_quarterback_stats
    WHERE year = 2016
) AS qb_2016
GROUP BY player
ORDER BY total_attempts DESC;
