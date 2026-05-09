-- ======================================================================
-- Athletes On Single Or Multiple Teams
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9949
-- URL        : https://platform.stratascratch.com/coding/9949-athletes-on-single-or-multiple-teams
-- ======================================================================

/*
Classify each athlete as either on one team or on multiple teams based on the number of team names in the 'team' column. If an athlete is only on one team, classify them as 'One Team', otherwise classify the athlete as 'Multiple Teams'. Athletes on multiple teams will have two teams listed and separated by a / (e.g., Denmark/Sweden). Output unique player names along with the classification.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT DISTINCT
    name,
    CASE
        WHEN team LIKE '%/%' THEN 'Multiple Teams'
        ELSE 'One Team'
    END AS team_classification
FROM athletes;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    name,
    CASE
        WHEN MAX(CASE WHEN team LIKE '%/%' THEN 1 ELSE 0 END) = 1 THEN 'Multiple Teams'
        ELSE 'One Team'
    END AS team_classification
FROM athletes
GROUP BY name;
