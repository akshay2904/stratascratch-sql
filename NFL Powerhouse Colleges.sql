-- ======================================================================
-- NFL Powerhouse Colleges
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9759
-- URL        : https://platform.stratascratch.com/coding/9759-nfl-powerhouse-colleges
-- ======================================================================

/*
Find colleges that produce the most NFL players.  Output the college name and the player count. Order the result based on the player count in descending order. Players that were not drafted into the NFL have 0s as values in the pickround column.
*/

-- Tables:
--   nfl_combine(arms double precision, bench bigint, broad bigint, college text, firstname text, fortyyd double precision, hands double precision, heightfeet bigint, heightinches double precision, heightinchestotal double precision, lastname text, name text, pick text, pickround bigint, picktotal bigint, position text, round bigint, tenyd double precision, threecone double precision, twentyss double precision, twentyyd double precision, vertical double precision, weight bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH drafted_players AS (
    SELECT 
        college,
        COUNT(*) AS player_count
    FROM nfl_draft_picks
    WHERE pickround != 0  -- Exclude undrafted players
      AND college IS NOT NULL
      AND college != ''
    GROUP BY college
)
SELECT 
    college,
    player_count
FROM drafted_players
ORDER BY player_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    college,
    COUNT(*) AS player_count
FROM nfl_draft_picks
WHERE pickround != 0  -- Exclude undrafted players (0 = not drafted)
  AND college IS NOT NULL
  AND college != ''
GROUP BY college
ORDER BY player_count DESC;
