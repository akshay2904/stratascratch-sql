-- ======================================================================
-- Name to Medal Connection
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ESPN
-- Access     : Premium
-- ID         : 9952
-- URL        : https://platform.stratascratch.com/coding/9952-name-to-medal-connection
-- ======================================================================

/*
Find the connection between the number of letters in the athlete's first name and the number of medals won for each type for medal, including no medals. Output the length of the name along with the corresponding number of no medals, bronze medals, silver medals, and gold medals.
*/

-- Tables:
--   olympics_athletes_events(age double precision, city text, event text, games text, height double precision, id bigint, medal text, name text, noc text, season text, sex text, sport text, team text, weight double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH name_medals AS (
    SELECT 
        LENGTH(athlete) - LENGTH(REPLACE(athlete, ' ', '')) AS first_name_end,
        -- Extract first name by finding the portion before the first space
        SUBSTRING(athlete FROM 1 FOR 
            CASE WHEN POSITION(' ' IN athlete) > 0 
                 THEN POSITION(' ' IN athlete) - 1 
                 ELSE LENGTH(athlete) 
            END
        ) AS first_name,
        medal
    FROM summer_medals
),
name_length AS (
    SELECT
        LENGTH(first_name) AS name_length,
        medal
    FROM name_medals
)
SELECT
    name_length,
    COUNT(*) FILTER (WHERE medal = 'No Medal') AS no_medals,
    COUNT(*) FILTER (WHERE medal = 'Bronze')   AS bronze_medals,
    COUNT(*) FILTER (WHERE medal = 'Silver')   AS silver_medals,
    COUNT(*) FILTER (WHERE medal = 'Gold')     AS gold_medals
FROM name_length
GROUP BY name_length
ORDER BY name_length;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    LENGTH(
        CASE 
            WHEN POSITION(' ' IN athlete) > 0 
            THEN SUBSTRING(athlete FROM 1 FOR POSITION(' ' IN athlete) - 1)
            ELSE athlete 
        END
    ) AS name_length,
    SUM(CASE WHEN medal = 'No Medal' THEN 1 ELSE 0 END) AS no_medals,
    SUM(CASE WHEN medal = 'Bronze'   THEN 1 ELSE 0 END) AS bronze_medals,
    SUM(CASE WHEN medal = 'Silver'   THEN 1 ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Gold'     THEN 1 ELSE 0 END) AS gold_medals
FROM summer_medals
GROUP BY
    LENGTH(
        CASE 
            WHEN POSITION(' ' IN athlete) > 0 
            THEN SUBSTRING(athlete FROM 1 FOR POSITION(' ' IN athlete) - 1)
            ELSE athlete 
        END
    )
ORDER BY name_length;
