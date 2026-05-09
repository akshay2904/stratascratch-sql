-- ======================================================================
-- Median Age Of Gold Medal Winners
-- ======================================================================
-- Difficulty : Medium
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9958
-- URL        : https://platform.stratascratch.com/coding/9958-median-age-of-gold-medal-winners
-- ======================================================================

/*
Find the median age of gold medal winners across all Olympics.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH gold_ages AS (
    SELECT age
    FROM olympics_athletes_events
    WHERE medal = 'Gold'
      AND age IS NOT NULL
),
ranked AS (
    SELECT
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS rn,
        COUNT(*) OVER ()                 AS total
    FROM gold_ages
)
SELECT
    -- Average the one or two middle values to handle both odd and even counts
    ROUND(AVG(age), 2) AS median_age
FROM ranked
WHERE rn IN (
    FLOOR((total + 1) / 2.0),
    CEIL((total + 1) / 2.0)
);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH gold_ages AS (
    SELECT age
    FROM olympics_athletes_events
    WHERE medal = 'Gold'
      AND age IS NOT NULL
    ORDER BY age
),
total_count AS (
    SELECT COUNT(*) AS total FROM gold_ages
),
indexed AS (
    -- Assign sequential row numbers via a self-join count
    SELECT
        g1.age,
        COUNT(g2.age) AS rn   -- counts how many values are <= g1.age
    FROM gold_ages g1
    JOIN gold_ages g2 ON g2.age <= g1.age
    GROUP BY g1.age
)
-- Use PERCENTILE_CONT as the brute-force / built-in aggregate approach
SELECT
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY age)::NUMERIC,
        2
    ) AS median_age
FROM (
    SELECT age
    FROM olympics_athletes_events
    WHERE medal = 'Gold'
      AND age IS NOT NULL
) sub;
