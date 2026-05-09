-- ======================================================================
-- Find top crime categories in 2014 based on the number of occurrences
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9746
-- URL        : https://platform.stratascratch.com/coding/9746-find-top-crime-categories-in-2014-based-on-the-number-of-occurrences
-- ======================================================================

/*
Find top crime categories in 2014 based on the number of occurrences.
Output the number of crime occurrences alongside the corresponding category name.
Order records based on the number of occurrences in descending order
*/

-- Tables:
--   sf_crime_incidents_2014_01(address text, category text, date date, day_of_week text, descript text, id bigint, incidnt_num double precision, lat double precision, location text, lon double precision, pd_district text, resolution text, time text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH crime_counts AS (
    SELECT
        category,
        COUNT(*) AS occurrences,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM sf_crime_incidents_2014_01
    GROUP BY category
)
SELECT
    category,
    occurrences
FROM crime_counts
ORDER BY occurrences DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    category,
    COUNT(*) AS occurrences
FROM sf_crime_incidents_2014_01
GROUP BY category
ORDER BY occurrences DESC;
