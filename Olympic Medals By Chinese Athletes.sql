-- ======================================================================
-- Olympic Medals By Chinese Athletes
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9959
-- URL        : https://platform.stratascratch.com/coding/9959-olympic-medals-by-chinese-athletes
-- ======================================================================

/*
Find the number of medals earned in each category by Chinese athletes from the 2000 to 2016 summer Olympics. For each medal category, calculate the number of medals for each olympic games along with the total number of medals across all years. Sort records by total medals in descending order.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH chinese_medals AS (
    SELECT
        medal,
        year
    FROM olympics_athletes_events
    WHERE
        team = 'China'
        AND season = 'Summer'
        AND year BETWEEN 2000 AND 2016
        AND medal IS NOT NULL
        AND medal != 'NA'
),
medal_year_counts AS (
    SELECT
        medal,
        year,
        COUNT(*) AS medal_count
    FROM chinese_medals
    GROUP BY medal, year
),
totals AS (
    SELECT
        medal,
        SUM(medal_count) AS total_medals
    FROM medal_year_counts
    GROUP BY medal
)
SELECT
    myc.medal,
    myc.year,
    myc.medal_count,
    t.total_medals
FROM medal_year_counts myc
JOIN totals t ON myc.medal = t.medal
ORDER BY t.total_medals DESC, myc.medal, myc.year;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    base.medal,
    base.year,
    COUNT(*) AS medal_count,
    (
        SELECT COUNT(*)
        FROM olympics_athletes_events sub
        WHERE sub.team = 'China'
          AND sub.season = 'Summer'
          AND sub.year BETWEEN 2000 AND 2016
          AND sub.medal IS NOT NULL
          AND sub.medal != 'NA'
          AND sub.medal = base.medal
    ) AS total_medals
FROM olympics_athletes_events base
WHERE
    base.team = 'China'
    AND base.season = 'Summer'
    AND base.year BETWEEN 2000 AND 2016
    AND base.medal IS NOT NULL
    AND base.medal != 'NA'
GROUP BY base.medal, base.year
ORDER BY total_medals DESC, base.medal, base.year;
