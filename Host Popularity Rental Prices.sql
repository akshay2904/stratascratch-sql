-- ======================================================================
-- Host Popularity Rental Prices
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9632
-- URL        : https://platform.stratascratch.com/coding/9632-host-popularity-rental-prices
-- ======================================================================

/*
You are given a table named airbnb_host_searches that contains listings shown to users during Airbnb property searches. Each record represents a property listing (not the user's search query). Determine the minimum, average, and maximum rental prices for each host popularity rating based on the property's number_of_reviews.




The host’s popularity rating is defined as below:

•   0 reviews: "New"

•   1 to 5 reviews: "Rising"

•   6 to 15 reviews: "Trending Up"

•   16 to 40 reviews: "Popular"

•   More than 40 reviews: "Hot"




Tip: The id column in the table refers to the listing ID.




Output host popularity rating and their minimum, average and maximum rental prices. Order the solution by the minimum price.
*/

-- Tables:
--   airbnb_host_searches(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH rated_listings AS (
    SELECT
        price,
        CASE
            WHEN number_of_reviews = 0        THEN 'New'
            WHEN number_of_reviews <= 5       THEN 'Rising'
            WHEN number_of_reviews <= 15      THEN 'Trending Up'
            WHEN number_of_reviews <= 40      THEN 'Popular'
            ELSE                                   'Hot'
        END AS host_pop_rating
    FROM (
        -- Deduplicate listings by id to avoid counting same listing multiple times
        SELECT DISTINCT id, price, number_of_reviews
        FROM airbnb_host_searches
    ) unique_listings
)
SELECT
    host_pop_rating,
    MIN(price)  AS min_price,
    AVG(price)  AS avg_price,
    MAX(price)  AS max_price
FROM rated_listings
GROUP BY host_pop_rating
ORDER BY min_price;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    CASE
        WHEN number_of_reviews = 0        THEN 'New'
        WHEN number_of_reviews BETWEEN 1 AND 5   THEN 'Rising'
        WHEN number_of_reviews BETWEEN 6 AND 15  THEN 'Trending Up'
        WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
        ELSE                                           'Hot'
    END AS host_pop_rating,
    MIN(price)  AS min_price,
    AVG(price)  AS avg_price,
    MAX(price)  AS max_price
FROM (
    -- Deduplicate by listing id first
    SELECT DISTINCT id, price, number_of_reviews
    FROM airbnb_host_searches
) AS unique_listings
GROUP BY
    CASE
        WHEN number_of_reviews = 0        THEN 'New'
        WHEN number_of_reviews BETWEEN 1 AND 5   THEN 'Rising'
        WHEN number_of_reviews BETWEEN 6 AND 15  THEN 'Trending Up'
        WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
        ELSE                                           'Hot'
    END
ORDER BY min_price;
