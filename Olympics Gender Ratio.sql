-- ======================================================================
-- Olympics Gender Ratio
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9953
-- URL        : https://platform.stratascratch.com/coding/9953-find-the-gender-ratio-between-the-number-of-men-and-women-who-participated-in-each-olympics
-- ======================================================================

/*
Find the gender ratio between the number of men and women who participated in each Olympics.
Output the Olympics name along with the corresponding number of men, women, and the gender ratio. If there are Olympics with no women, output a NULL instead of a ratio.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH gender_counts AS (
    SELECT
        games,
        COUNT(*) FILTER (WHERE sex = 'M') AS men,
        COUNT(*) FILTER (WHERE sex = 'F') AS women
    FROM athlete_events
    GROUP BY games
)
SELECT
    games AS olympics,
    men,
    women,
    CASE 
        WHEN women = 0 THEN NULL
        ELSE ROUND(men::NUMERIC / women, 2)
    END AS gender_ratio
FROM gender_counts
ORDER BY games;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    g.games AS olympics,
    COALESCE(m.men, 0)  AS men,
    COALESCE(f.women, 0) AS women,
    CASE
        WHEN COALESCE(f.women, 0) = 0 THEN NULL
        ELSE ROUND(COALESCE(m.men, 0)::NUMERIC / f.women, 2)
    END AS gender_ratio
FROM (SELECT DISTINCT games FROM athlete_events) g
LEFT JOIN (
    SELECT games, COUNT(*) AS men
    FROM athlete_events
    WHERE sex = 'M'
    GROUP BY games
) m ON g.games = m.games
LEFT JOIN (
    SELECT games, COUNT(*) AS women
    FROM athlete_events
    WHERE sex = 'F'
    GROUP BY games
) f ON g.games = f.games
ORDER BY g.games;
