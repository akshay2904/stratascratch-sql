-- ======================================================================
-- Find the year in which the shortest athlete participated
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9946
-- URL        : https://platform.stratascratch.com/coding/9946-find-the-year-in-which-the-shortest-athlete-participated
-- ======================================================================

/*
Find the year in which the shortest athlete participated.
Output the year and the corresponding height.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT 
        year,
        height,
        RANK() OVER (ORDER BY height ASC) AS rnk
    FROM olympics_athletes_events
    WHERE height IS NOT NULL
)
SELECT year, height
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT year, height
FROM olympics_athletes_events
WHERE height = (
    SELECT MIN(height)
    FROM olympics_athletes_events
    WHERE height IS NOT NULL
);
