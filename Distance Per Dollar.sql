-- ======================================================================
-- Distance Per Dollar
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 10302
-- URL        : https://platform.stratascratch.com/coding/10302-distance-per-dollar
-- ======================================================================

/*
You’re given a dataset of Uber rides with the traveling distance (distance_to_travel) and cost (monetary_cost) for each ride. First, find the difference between the distance-per-dollar for each ride and the monthly distance-per-dollar for that year-month.




Distance-per-dollar for each ride is defined as the distance traveled divided by the cost of the ride. Monthly distance-per-dollar is defined as the total distance traveled in that month divided by the total cost for that month.




Use the calculated difference on each date to calculate absolute average difference in distance-per-dollar metric on monthly basis (year-month).




The output should include the year-month (YYYY-MM) and the absolute average difference in distance-per-dollar (Absolute value to be rounded to the 2nd decimal).




You should also count both success and failed request_status as the distance and cost values are populated for all ride requests. Also, assume that all dates are unique in the dataset. Order your results by earliest request date first.
*/

-- Tables:
--   uber_request_logs(distance_to_travel double precision, driver_to_client_distance double precision, monetary_cost double precision, request_date date, request_id bigint, request_status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ride_metrics AS (
    SELECT
        TO_CHAR(request_date, 'YYYY-MM') AS year_month,
        request_date,
        -- Distance-per-dollar for each individual ride
        distance_to_travel / monetary_cost AS ride_dpd,
        -- Monthly distance-per-dollar using window functions
        SUM(distance_to_travel) OVER (PARTITION BY TO_CHAR(request_date, 'YYYY-MM')) /
        SUM(monetary_cost)      OVER (PARTITION BY TO_CHAR(request_date, 'YYYY-MM')) AS monthly_dpd
    FROM uber_request_logs
),
diff_calc AS (
    SELECT
        year_month,
        ABS(ride_dpd - monthly_dpd) AS abs_diff
    FROM ride_metrics
)
SELECT
    year_month,
    ROUND(AVG(abs_diff)::NUMERIC, 2) AS avg_abs_difference
FROM diff_calc
GROUP BY year_month
ORDER BY year_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    r.year_month,
    ROUND(AVG(ABS(r.ride_dpd - m.monthly_dpd))::NUMERIC, 2) AS avg_abs_difference
FROM (
    -- Per-ride distance-per-dollar
    SELECT
        TO_CHAR(request_date, 'YYYY-MM') AS year_month,
        request_date,
        distance_to_travel / monetary_cost AS ride_dpd
    FROM uber_request_logs
) r
JOIN (
    -- Monthly distance-per-dollar
    SELECT
        TO_CHAR(request_date, 'YYYY-MM') AS year_month,
        SUM(distance_to_travel) / SUM(monetary_cost) AS monthly_dpd
    FROM uber_request_logs
    GROUP BY TO_CHAR(request_date, 'YYYY-MM')
) m ON r.year_month = m.year_month
GROUP BY r.year_month
ORDER BY r.year_month;
