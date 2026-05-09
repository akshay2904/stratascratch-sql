-- ======================================================================
-- Flight Satisfaction Query
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tata Consultancy
-- Access     : Premium
-- ID         : 2144
-- URL        : https://platform.stratascratch.com/coding/2144-flight-satisfaction-2022
-- ======================================================================

/*
A major airline has enlisted Tata Consultancy's help to improve customer satisfaction on its flights. Their goal is to increase customer satisfaction among people between the ages of 30 and 40.




You've been tasked with calculating the customer satisfaction average for this age group across all three flight classes.




Return the class with the average of satisfaction rounded to the nearest whole number.
*/

-- Tables:
--   survey_results(arrival_delay_min bigint, class text, cust_id bigint, departure_delay_min bigint, flight_distance bigint, satisfaction bigint, type_of_travel text)
--   loyalty_customers(age bigint, cust_id bigint, gender text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    class,
    ROUND(AVG(satisfaction::numeric), 0) AS avg_satisfaction
FROM airline_passenger_satisfaction
WHERE age BETWEEN 30 AND 40
GROUP BY class
ORDER BY class;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    class,
    ROUND(AVG(satisfaction::numeric), 0) AS avg_satisfaction
FROM (
    SELECT class, satisfaction
    FROM airline_passenger_satisfaction
    WHERE age >= 30 AND age <= 40
) AS age_filtered
GROUP BY class
ORDER BY class;
