-- ======================================================================
-- Find how the average male height changed between each Olympics from 1896 to 2016
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9957
-- URL        : https://platform.stratascratch.com/coding/9957-find-how-the-average-male-height-changed-between-each-olympics-from-1896-to-2016
-- ======================================================================

/*
Find how the average male height changed between each Olympics from 1896 to 2016.

Output the Olympics year, average height, previous average height, and the corresponding average height difference.

Order records by the year in ascending order.




If avg height for some year is not found, assume that the average height of athletes for that year  is 172.73.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH avg_heights AS (
    SELECT
        year,
        COALESCE(AVG(height), 172.73) AS avg_height
    FROM athletes_and_events
    WHERE sex = 'M'
      AND year BETWEEN 1896 AND 2016
    GROUP BY year
),
with_lag AS (
    SELECT
        year,
        avg_height,
        LAG(avg_height, 1, 172.73) OVER (ORDER BY year) AS prev_avg_height
    FROM avg_heights
)
SELECT
    year,
    avg_height,
    prev_avg_height,
    avg_height - prev_avg_height AS avg_height_diff
FROM with_lag
ORDER BY year ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH avg_heights AS (
    SELECT
        year,
        COALESCE(AVG(height), 172.73) AS avg_height
    FROM athletes_and_events
    WHERE sex = 'M'
      AND year BETWEEN 1896 AND 2016
    GROUP BY year
)
SELECT
    curr.year,
    curr.avg_height,
    COALESCE(prev.avg_height, 172.73) AS prev_avg_height,
    curr.avg_height - COALESCE(prev.avg_height, 172.73) AS avg_height_diff
FROM avg_heights curr
LEFT JOIN avg_heights prev
    ON prev.year = (
        SELECT MAX(year)
        FROM avg_heights
        WHERE year < curr.year
    )
ORDER BY curr.year ASC;
