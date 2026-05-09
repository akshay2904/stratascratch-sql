-- ======================================================================
-- Libraries With Highest Checkouts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9927
-- URL        : https://platform.stratascratch.com/coding/9927-libraries-with-highest-checkouts
-- ======================================================================

/*
Find the highest number of checkouts recorded in April by patrons who registered in 2015 and were between 65 and 74 years old. Return the registration year, the patron's home library, and the highest checkout value. Sort the results by the highest checkout value in descending order.
*/

-- Tables:
--   library_usage(age_range text, circulation_active_month text, circulation_active_year double precision, home_library_code text, home_library_definition text, notice_preference_code text, notice_preference_definition text, outside_of_county boolean, patron_type_code bigint, patron_type_definition text, provided_email_address boolean, supervisor_district double precision, total_checkouts bigint, total_renewals bigint, year_patron_registered bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH april_checkouts AS (
    SELECT
        EXTRACT(YEAR FROM patron_reg_date) AS registration_year,
        home_library_code,
        circulation_active_month,
        circulation_active_year,
        checkouts
    FROM library_usage
    WHERE
        EXTRACT(YEAR FROM patron_reg_date) = 2015
        AND age_range = '65 to 74'
        AND circulation_active_month = 4
),
ranked AS (
    SELECT
        registration_year,
        home_library_code,
        MAX(checkouts) OVER (PARTITION BY home_library_code) AS highest_checkouts
    FROM april_checkouts
)
SELECT DISTINCT
    registration_year,
    home_library_code AS home_library,
    highest_checkouts AS highest_checkout_value
FROM ranked
ORDER BY highest_checkout_value DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM patron_reg_date) AS registration_year,
    home_library_code AS home_library,
    MAX(checkouts) AS highest_checkout_value
FROM library_usage
WHERE
    EXTRACT(YEAR FROM patron_reg_date) = 2015
    AND age_range = '65 to 74'
    AND circulation_active_month = 4
GROUP BY
    EXTRACT(YEAR FROM patron_reg_date),
    home_library_code
ORDER BY highest_checkout_value DESC;
