-- ======================================================================
-- Find months with the highest number of checkouts for main libraries in 2013
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9928
-- URL        : https://platform.stratascratch.com/coding/9928-find-months-with-the-highest-number-of-checkouts-for-main-libraries-in-2013
-- ======================================================================

/*
Find months with the highest number of checkouts for main libraries in 2013.
Output the circulation active month along with the corresponding total monthly checkouts.
Order results based on total monthly checkouts in descending order.
*/

-- Tables:
--   library_usage(age_range text, circulation_active_month text, circulation_active_year double precision, home_library_code text, home_library_definition text, notice_preference_code text, notice_preference_definition text, outside_of_county boolean, patron_type_code bigint, patron_type_definition text, provided_email_address boolean, supervisor_district double precision, total_checkouts bigint, total_renewals bigint, year_patron_registered bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_totals AS (
    SELECT
        circulation_active_month,
        SUM(checkouts) AS total_monthly_checkouts,
        RANK() OVER (ORDER BY SUM(checkouts) DESC) AS rnk
    FROM library_usage
    WHERE home_library_definition = 'Main Library'
      AND circulation_active_year = 2013
    GROUP BY circulation_active_month
)
SELECT
    circulation_active_month,
    total_monthly_checkouts
FROM monthly_totals
WHERE rnk = 1
ORDER BY total_monthly_checkouts DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    circulation_active_month,
    SUM(checkouts) AS total_monthly_checkouts
FROM library_usage
WHERE home_library_definition = 'Main Library'
  AND circulation_active_year = 2013
GROUP BY circulation_active_month
HAVING SUM(checkouts) = (
    SELECT MAX(monthly_sum)
    FROM (
        SELECT SUM(checkouts) AS monthly_sum
        FROM library_usage
        WHERE home_library_definition = 'Main Library'
          AND circulation_active_year = 2013
        GROUP BY circulation_active_month
    ) AS sub
)
ORDER BY total_monthly_checkouts DESC;
