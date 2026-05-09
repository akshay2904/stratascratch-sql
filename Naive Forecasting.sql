-- ======================================================================
-- Naive Forecasting
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 10313
-- URL        : https://platform.stratascratch.com/coding/10313-naive-forecasting
-- ======================================================================

/*
Some forecasting methods are extremely simple and surprisingly effective. Naïve forecast is one of them; we simply set all forecasts to be the value of the last observation. Our goal is to develop a naïve forecast for a new metric called "distance per dollar" defined as the (distance_to_travel/monetary_cost) in our dataset and measure its accuracy.




Our dataset includes both successful and failed requests. For this task, include all rows regardless of request status when aggregating values.




To develop this forecast,  sum "distance to travel"  and "monetary cost" values at a monthly level before calculating "distance per dollar". This value becomes your actual value for the current month. The next step is to populate the forecasted value for each month. This can be achieved simply by getting the previous month's value in a separate column. Now, we have actual and forecasted values. This is your naïve forecast. Let’s evaluate our model by calculating an error matrix called root mean squared error (RMSE). RMSE is defined as sqrt(mean(square(actual - forecast)). Report out the RMSE rounded to the 2nd decimal spot.
*/

-- Tables:
--   uber_request_logs(distance_to_travel double precision, driver_to_client_distance double precision, monetary_cost double precision, request_date date, request_id bigint, request_status text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_agg AS (
    SELECT
        DATE_TRUNC('month', request_date) AS month,
        SUM(distance_to_travel) AS total_distance,
        SUM(monetary_cost)      AS total_cost
    FROM uber_request_logs
    GROUP BY DATE_TRUNC('month', request_date)
),
monthly_dpd AS (
    SELECT
        month,
        total_distance / total_cost AS actual_dpd,
        -- naive forecast: previous month's actual value
        LAG(total_distance / total_cost) OVER (ORDER BY month) AS forecast_dpd
    FROM monthly_agg
)
SELECT
    ROUND(
        SQRT(AVG(POWER(actual_dpd - forecast_dpd, 2)))::NUMERIC,
        2
    ) AS rmse
FROM monthly_dpd
WHERE forecast_dpd IS NOT NULL;  -- exclude first month (no forecast available)

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_agg AS (
    SELECT
        DATE_TRUNC('month', request_date) AS month,
        SUM(distance_to_travel) / SUM(monetary_cost) AS actual_dpd
    FROM uber_request_logs
    GROUP BY DATE_TRUNC('month', request_date)
),
paired AS (
    -- join each month to the previous month to get naive forecast
    SELECT
        curr.month,
        curr.actual_dpd,
        prev.actual_dpd AS forecast_dpd
    FROM monthly_agg curr
    JOIN monthly_agg prev
        ON prev.month = (
            SELECT MAX(p2.month)
            FROM monthly_agg p2
            WHERE p2.month < curr.month
        )
)
SELECT
    ROUND(
        SQRT(AVG((actual_dpd - forecast_dpd) * (actual_dpd - forecast_dpd)))::NUMERIC,
        2
    ) AS rmse
FROM paired;
