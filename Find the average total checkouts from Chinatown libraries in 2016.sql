-- ======================================================================
-- Find the average total checkouts from Chinatown libraries in 2016
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9929
-- URL        : https://platform.stratascratch.com/coding/9929-find-the-average-total-checkouts-from-chinatown-libraries-in-2016
-- ======================================================================

/*
Find the average total checkouts from Chinatown libraries in 2016.
*/

-- Tables:
--   library_usage(age_range text, circulation_active_month text, circulation_active_year double precision, home_library_code text, home_library_definition text, notice_preference_code text, notice_preference_definition text, outside_of_county boolean, patron_type_code bigint, patron_type_definition text, provided_email_address boolean, supervisor_district double precision, total_checkouts bigint, total_renewals bigint, year_patron_registered bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

-- Sum checkouts per branch first, then average those totals
WITH branch_totals AS (
    SELECT
        branch_call_num,
        SUM(total_checkouts) AS total
    FROM library_usage
    WHERE LOWER(home_library_definition) LIKE '%chinatown%'
      AND circulation_active_year = 2016
    GROUP BY branch_call_num
)
SELECT ROUND(AVG(total), 2) AS avg_total_checkouts
FROM branch_totals;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

-- Compute branch sums in a subquery, then average
SELECT ROUND(AVG(branch_total), 2) AS avg_total_checkouts
FROM (
    SELECT
        branch_call_num,
        SUM(total_checkouts) AS branch_total
    FROM library_usage
    WHERE LOWER(home_library_definition) LIKE '%chinatown%'
      AND circulation_active_year = 2016
    GROUP BY branch_call_num
) AS chinatown_branches;
