-- ======================================================================
-- Daily Violation Counts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9740
-- URL        : https://platform.stratascratch.com/coding/9740-daily-violation-counts
-- ======================================================================

/*
Determine the change in the number of daily violations by calculating the difference between the count of current and previous violations by inspection date.

Output the inspection date and the change in the number of daily violations. Order your results by the earliest inspection date first.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_counts AS (
    SELECT
        inspection_date,
        COUNT(*) AS daily_violations
    FROM chicago_food_inspections
    WHERE violation_id IS NOT NULL
    GROUP BY inspection_date
)
SELECT
    inspection_date,
    daily_violations - LAG(daily_violations) OVER (ORDER BY inspection_date) AS violation_change
FROM daily_counts
ORDER BY inspection_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    curr.inspection_date,
    curr.daily_violations - prev.daily_violations AS violation_change
FROM (
    SELECT
        inspection_date,
        COUNT(*) AS daily_violations
    FROM chicago_food_inspections
    WHERE violation_id IS NOT NULL
    GROUP BY inspection_date
) curr
LEFT JOIN (
    SELECT
        inspection_date,
        COUNT(*) AS daily_violations
    FROM chicago_food_inspections
    WHERE violation_id IS NOT NULL
    GROUP BY inspection_date
) prev
    ON prev.inspection_date = (
        -- find the immediately preceding inspection date for each current date
        SELECT MAX(sub.inspection_date)
        FROM chicago_food_inspections sub
        WHERE sub.inspection_date < curr.inspection_date
    )
ORDER BY curr.inspection_date;
