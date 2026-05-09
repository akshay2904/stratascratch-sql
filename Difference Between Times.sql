-- ======================================================================
-- Difference Between Times
-- ======================================================================
-- Difficulty : Medium
-- Companies  : EY, Tata Consultancy, Deloitte
-- Access     : Premium
-- ID         : 2064
-- URL        : https://platform.stratascratch.com/coding/2064-difference-between-times
-- ======================================================================

/*
In a marathon, gun time is counted from the moment of the formal start of the race while net time is counted from the moment a runner crosses a starting line. Both variables are in seconds.




You are asked to check if the interval between the two times is different for male and female runners. First, calculate the average absolute difference between the gun time and net time. Group the results by available genders (male and female). Output the absolute difference between those two values.
*/

-- Tables:
--   marathon_male(age bigint, div_tot text, gun_time bigint, hometown text, net_time bigint, num bigint, pace bigint, person_name text, place bigint)
--   marathon_female(age bigint, div_tot text, gun_time bigint, hometown text, net_time bigint, num bigint, pace bigint, person_name text, place bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH gender_avg AS (
    SELECT
        gender,
        AVG(ABS(gun_time - net_time)) AS avg_diff
    FROM marathon_male_female
    GROUP BY gender
),
pivoted AS (
    SELECT
        MAX(CASE WHEN gender = 'M' THEN avg_diff END) AS male_avg,
        MAX(CASE WHEN gender = 'F' THEN avg_diff END) AS female_avg
    FROM gender_avg
)
SELECT
    ABS(male_avg - female_avg) AS absolute_difference
FROM pivoted;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ABS(
        (SELECT AVG(ABS(gun_time - net_time))
         FROM marathon_male_female
         WHERE gender = 'M')
        -
        (SELECT AVG(ABS(gun_time - net_time))
         FROM marathon_male_female
         WHERE gender = 'F')
    ) AS absolute_difference;
