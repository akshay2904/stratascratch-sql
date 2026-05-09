-- ======================================================================
-- Find districts with the most crime incidents
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9748
-- URL        : https://platform.stratascratch.com/coding/9748-find-districts-with-the-most-crime-incidents
-- ======================================================================

/*
Find districts alongside their incidents.

Output the district name alongside the number of incident occurrences.

Order records based on the number of occurrences in descending order.
*/

-- Tables:
--   sf_crime_incidents_2014_01(address text, category text, date date, day_of_week text, descript text, id bigint, incidnt_num double precision, lat double precision, location text, lon double precision, pd_district text, resolution text, time text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    d.district_name,
    COUNT(i.incident_id) AS occurrences
FROM districts d
LEFT JOIN incidents i ON d.district_id = i.district_id
GROUP BY d.district_id, d.district_name
ORDER BY occurrences DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    d.district_name,
    (SELECT COUNT(*) 
     FROM incidents i 
     WHERE i.district_id = d.district_id) AS occurrences
FROM districts d
ORDER BY occurrences DESC;
