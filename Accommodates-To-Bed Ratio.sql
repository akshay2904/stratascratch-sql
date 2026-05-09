-- ======================================================================
-- Accommodates-To-Bed Ratio
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9624
-- URL        : https://platform.stratascratch.com/coding/9624-accommodates-to-bed-ratio
-- ======================================================================

/*
Find the average accommodates-to-beds ratio for shared rooms in each city. Sort your results by listing cities with the highest ratios first.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    city,
    ROUND(AVG(CASE WHEN beds > 0 THEN accommodates::NUMERIC / beds ELSE NULL END), 4) AS avg_accommodates_to_beds_ratio
FROM listings
WHERE room_type = 'Shared room'
GROUP BY city
ORDER BY avg_accommodates_to_beds_ratio DESC NULLS LAST;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    city,
    ROUND(
        SUM(CASE WHEN beds > 0 THEN accommodates::NUMERIC / beds ELSE NULL END) /
        NULLIF(COUNT(CASE WHEN beds > 0 THEN 1 ELSE NULL END), 0),
        4
    ) AS avg_accommodates_to_beds_ratio
FROM (
    SELECT
        city,
        accommodates,
        beds
    FROM listings
    WHERE room_type = 'Shared room'
) AS shared_rooms
GROUP BY city
ORDER BY avg_accommodates_to_beds_ratio DESC NULLS LAST;
