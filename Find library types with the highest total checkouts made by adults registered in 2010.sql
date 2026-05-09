-- ======================================================================
-- Find library types with the highest total checkouts made by adults registered in 2010
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9926
-- URL        : https://platform.stratascratch.com/coding/9926-find-library-types-with-the-highest-total-checkouts-made-by-adults-registered-in-2010
-- ======================================================================

/*
Find library types with the highest total checkouts made by adults registered in 2010.
Output the year patron registered, home library definition along with the corresponding highest total checkouts.
*/

-- Tables:
--   library_usage(age_range text, circulation_active_month text, circulation_active_year double precision, home_library_code text, home_library_definition text, notice_preference_code text, notice_preference_definition text, outside_of_county boolean, patron_type_code bigint, patron_type_definition text, provided_email_address boolean, supervisor_district double precision, total_checkouts bigint, total_renewals bigint, year_patron_registered bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH adult_2010 AS (
    SELECT
        patron_type_definition,
        home_library_definition,
        year_patron_registered,
        SUM(total_checkouts) AS total_checkouts
    FROM library
    WHERE year_patron_registered = 2010
      AND LOWER(patron_type_definition) LIKE '%adult%'
    GROUP BY patron_type_definition, home_library_definition, year_patron_registered
),
ranked AS (
    SELECT
        year_patron_registered,
        home_library_definition,
        total_checkouts,
        RANK() OVER (ORDER BY total_checkouts DESC) AS rnk
    FROM adult_2010
)
SELECT
    year_patron_registered,
    home_library_definition,
    total_checkouts
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    year_patron_registered,
    home_library_definition,
    SUM(total_checkouts) AS total_checkouts
FROM library
WHERE year_patron_registered = 2010
  AND LOWER(patron_type_definition) LIKE '%adult%'
GROUP BY patron_type_definition, home_library_definition, year_patron_registered
HAVING SUM(total_checkouts) = (
    SELECT MAX(sub.total_checkouts)
    FROM (
        SELECT SUM(total_checkouts) AS total_checkouts
        FROM library
        WHERE year_patron_registered = 2010
          AND LOWER(patron_type_definition) LIKE '%adult%'
        GROUP BY patron_type_definition, home_library_definition, year_patron_registered
    ) sub
);
