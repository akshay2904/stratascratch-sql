-- ======================================================================
-- Find the count of verified and non-verified Airbnb hosts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9629
-- URL        : https://platform.stratascratch.com/coding/9629-find-the-count-of-verified-and-non-verified-airbnb-hosts
-- ======================================================================

/*
Find how many hosts are verified by the Airbnb staff and how many aren't. Assume that in each row you have a different host.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    host_identity_verified,
    COUNT(*) AS number_of_hosts
FROM airbnb_listings
GROUP BY host_identity_verified;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    'verified' AS host_identity_verified,
    (SELECT COUNT(*) FROM airbnb_listings WHERE host_identity_verified = 'verified') AS number_of_hosts
UNION ALL
SELECT
    'unconfirmed' AS host_identity_verified,
    (SELECT COUNT(*) FROM airbnb_listings WHERE host_identity_verified = 'unconfirmed') AS number_of_hosts;
