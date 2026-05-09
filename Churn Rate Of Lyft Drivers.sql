-- ======================================================================
-- Churn Rate Of Lyft Drivers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 10016
-- URL        : https://platform.stratascratch.com/coding/10016-churn-rate-of-lyft-drivers
-- ======================================================================

/*
Calculate the overall churn rate for Lyft drivers across all years in the dataset. Churn is defined as the percentage of drivers who have stopped driving for Lyft, as indicated by a recorded end_date in the lyft_drivers table. In your answer, express the churn rate as a ratio, instead of a percentage. For example, 0.1 instead of 10%.
*/

-- Tables:
--   lyft_drivers(end_date date, index bigint, start_date date, yearly_salary bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    ROUND(
        COUNT(end_date)::NUMERIC / COUNT(*), 
        2
    ) AS churn_rate
FROM lyft_drivers;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    ROUND(
        (SELECT COUNT(*) FROM lyft_drivers WHERE end_date IS NOT NULL)::NUMERIC 
        / 
        (SELECT COUNT(*) FROM lyft_drivers),
        2
    ) AS churn_rate;
