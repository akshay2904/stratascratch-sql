-- ======================================================================
-- Find the year which had the highest number of players
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9657
-- URL        : https://platform.stratascratch.com/coding/9657-find-the-year-which-had-the-highest-number-of-players
-- ======================================================================

/*
Find the year which had the highest number of players. Output the year along with the number of players.
*/

-- Tables:
--   nfl_combine(arms double precision, bench bigint, broad bigint, college text, firstname text, fortyyd double precision, hands double precision, heightfeet bigint, heightinches double precision, heightinchestotal double precision, lastname text, name text, pick text, pickround bigint, picktotal bigint, position text, round bigint, tenyd double precision, threecone double precision, twentyss double precision, twentyyd double precision, vertical double precision, weight bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_counts AS (
    SELECT
        year,
        COUNT(*) AS num_players,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM players
    GROUP BY year
)
SELECT year, num_players
FROM yearly_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT year, COUNT(*) AS num_players
FROM players
GROUP BY year
HAVING COUNT(*) = (
    SELECT MAX(player_count)
    FROM (
        SELECT COUNT(*) AS player_count
        FROM players
        GROUP BY year
    ) AS yearly_totals
);
