-- ======================================================================
-- Find the number of athletes that participated in each Olympics season
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9941
-- URL        : https://platform.stratascratch.com/coding/9941-find-the-number-of-athletes-that-participated-in-each-olympics-season
-- ======================================================================

/*
Find the number of athletes that participated in each Olympics season.
Output the season with the corresponding number of athletes.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    season,
    COUNT(DISTINCT id) AS num_athletes
FROM olympics_athletes_events
GROUP BY season
ORDER BY season;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    season,
    COUNT(*) AS num_athletes
FROM (
    SELECT DISTINCT season, id
    FROM olympics_athletes_events
) AS unique_athletes
GROUP BY season
ORDER BY season;
