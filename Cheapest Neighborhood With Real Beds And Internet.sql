-- ======================================================================
-- Cheapest Neighborhood With Real Beds And Internet
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9636
-- URL        : https://platform.stratascratch.com/coding/9636-cheapest-neighborhoods-with-real-beds-and-internet
-- ======================================================================

/*
Find a neighborhood where you can sleep on a real bed in a villa with internet while paying the lowest price possible.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered AS (
    SELECT
        neighbourhood,
        price,
        RANK() OVER (ORDER BY price ASC) AS price_rank
    FROM listings
    WHERE
        bed_type    = 'Real Bed'
        AND property_type = 'Villa'
        AND amenities ILIKE '%internet%'
        AND price IS NOT NULL
)
SELECT
    neighbourhood,
    price
FROM filtered
WHERE price_rank = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    neighbourhood,
    price
FROM listings
WHERE
    bed_type      = 'Real Bed'
    AND property_type  = 'Villa'
    AND amenities ILIKE '%internet%'
    AND price = (
        SELECT MIN(price)
        FROM listings
        WHERE
            bed_type      = 'Real Bed'
            AND property_type  = 'Villa'
            AND amenities ILIKE '%internet%'
            AND price IS NOT NULL
    );
