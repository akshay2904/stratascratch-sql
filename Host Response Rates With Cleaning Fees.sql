-- ======================================================================
-- Host Response Rates With Cleaning Fees
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9634
-- URL        : https://platform.stratascratch.com/coding/9634-host-response-rates-with-cleaning-fees
-- ======================================================================

/*
Find the average host response rate with a cleaning fee for each zipcode. Present the results as a percentage along with the zip code value.

Convert the column 'host_response_rate' from TEXT to NUMERIC using type casts and string processing (take missing values as NULL).

Order the result in ascending order based on the average host response rater after cleaning.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH cleaned AS (
    SELECT
        zipcode,
        -- Remove '%' sign and cast to NUMERIC; non-numeric/null become NULL
        NULLIF(REGEXP_REPLACE(host_response_rate, '[^0-9.]', '', 'g'), '')::NUMERIC AS response_rate_num
    FROM listings
    WHERE cleaning_fee IS NOT NULL
      AND cleaning_fee::TEXT != ''
      AND cleaning_fee::TEXT != '0'
)
SELECT
    zipcode,
    ROUND(AVG(response_rate_num), 2) AS avg_host_response_rate
FROM cleaned
GROUP BY zipcode
ORDER BY avg_host_response_rate ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    zipcode,
    ROUND(
        AVG(
            CASE
                WHEN host_response_rate IS NULL OR TRIM(host_response_rate) = '' THEN NULL
                ELSE REPLACE(host_response_rate, '%', '')::NUMERIC
            END
        ), 2
    ) AS avg_host_response_rate
FROM listings
WHERE cleaning_fee IS NOT NULL
  AND TRIM(cleaning_fee::TEXT) != ''
GROUP BY zipcode
ORDER BY avg_host_response_rate ASC;
