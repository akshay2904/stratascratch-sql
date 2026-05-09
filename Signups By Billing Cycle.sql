-- ======================================================================
-- Signups By Billing Cycle
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana, Noom
-- Access     : Premium
-- ID         : 2032
-- URL        : https://platform.stratascratch.com/coding/2032-signups-by-billing-cycle
-- ======================================================================

/*
Write a query that returns a table containing the number of signups for each weekday and for each billing cycle frequency. The day of the week standard we expect is from Sunday as 0 to Saturday as 6.




Output the weekday number (e.g., 1, 2, 3) as rows in your table and the billing cycle frequency (e.g., annual, monthly, quarterly) as columns. If there are NULLs in the output replace them with zeroes.
*/

-- Tables:
--   signups(location text, plan_id bigint, signup_id bigint, signup_start_date date, signup_stop_date date)
--   plans(avg_revenue double precision, billing_cycle text, currency text, id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    weekday,
    COALESCE(SUM(CASE WHEN billing_cycle_frequency = 'annual'    THEN cnt END), 0) AS annual,
    COALESCE(SUM(CASE WHEN billing_cycle_frequency = 'monthly'   THEN cnt END), 0) AS monthly,
    COALESCE(SUM(CASE WHEN billing_cycle_frequency = 'quarterly' THEN cnt END), 0) AS quarterly
FROM (
    SELECT
        -- EXTRACT DOW returns 0=Sunday … 6=Saturday, matching the requirement
        EXTRACT(DOW FROM signup_date)::INT AS weekday,
        billing_cycle_frequency,
        COUNT(*) AS cnt
    FROM signups
    GROUP BY weekday, billing_cycle_frequency
) agg
GROUP BY weekday
ORDER BY weekday;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(DOW FROM signup_date)::INT AS weekday,
    COALESCE(
        (SELECT COUNT(*)
         FROM signups s2
         WHERE EXTRACT(DOW FROM s2.signup_date)::INT = EXTRACT(DOW FROM s1.signup_date)::INT
           AND s2.billing_cycle_frequency = 'annual'), 0)    AS annual,
    COALESCE(
        (SELECT COUNT(*)
         FROM signups s2
         WHERE EXTRACT(DOW FROM s2.signup_date)::INT = EXTRACT(DOW FROM s1.signup_date)::INT
           AND s2.billing_cycle_frequency = 'monthly'), 0)   AS monthly,
    COALESCE(
        (SELECT COUNT(*)
         FROM signups s2
         WHERE EXTRACT(DOW FROM s2.signup_date)::INT = EXTRACT(DOW FROM s1.signup_date)::INT
           AND s2.billing_cycle_frequency = 'quarterly'), 0) AS quarterly
FROM signups s1
GROUP BY EXTRACT(DOW FROM signup_date)::INT
ORDER BY weekday;
