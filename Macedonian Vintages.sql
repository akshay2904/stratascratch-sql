-- ======================================================================
-- Macedonian Vintages
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10039
-- URL        : https://platform.stratascratch.com/coding/10039-macedonian-vintages
-- ======================================================================

/*
Find the vintage years of all wines from the country of Macedonia. The year can be found in the 'title' column. Output the wine (i.e., the 'title') along with the year. The year should be a numeric or int data type.
*/

-- Tables:
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH extracted AS (
    SELECT
        title,
        -- Extract 4-digit year from title using regex
        CAST(SUBSTRING(title FROM '\d{4}') AS INTEGER) AS year
    FROM winemag_p2
    WHERE country = 'Macedonia'
)
SELECT title, year
FROM extracted
WHERE year IS NOT NULL;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    title,
    -- Use regexp_replace to isolate the first 4-digit number in title
    CAST(
        (SELECT SUBSTRING(title FROM '\d{4}'))
    AS INTEGER) AS year
FROM winemag_p2
WHERE country = 'Macedonia'
  AND title ~ '\d{4}';
