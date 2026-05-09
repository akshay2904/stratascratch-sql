-- ======================================================================
-- European Olympics
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9951
-- URL        : https://platform.stratascratch.com/coding/9951-european-olympics
-- ======================================================================

/*
Find the number of athletes who participated in the Olympics that hosted in European cities.
European cities: Berlin, Athina, Lillehammer, London, Albertville and Paris.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH european_games AS (
    SELECT DISTINCT games
    FROM city
    WHERE city IN ('Berlin', 'Athina', 'Lillehammer', 'London', 'Albertville', 'Paris')
)
SELECT COUNT(DISTINCT a.id) AS num_athletes
FROM person_region a
JOIN games_competitor gc ON a.person_id = gc.person_id
JOIN european_games eg ON gc.games_id = eg.games;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(DISTINCT gc.person_id) AS num_athletes
FROM games_competitor gc
WHERE gc.games_id IN (
    SELECT DISTINCT games
    FROM city
    WHERE city IN ('Berlin', 'Athina', 'Lillehammer', 'London', 'Albertville', 'Paris')
);
