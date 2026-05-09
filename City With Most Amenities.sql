-- ======================================================================
-- City With Most Amenities
-- ======================================================================
-- Difficulty : Hard
-- Companies  : N/A
-- Access     : Premium
-- ID         : 517
-- URL        : https://platform.stratascratch.com/coding/10572-city-with-most-amenities
-- ======================================================================

/*
You're given a dataset of searches for properties on Airbnb. For simplicity, each row represents a unique host.




Your task is to find the city whose hosts collectively list the greatest total number of amenities across all their properties.




Treat amenities as a comma-separated list and count each listed entry as-is, even if the same amenities appear multiple times within the same property's amenities, count each occurrence (do not deduplicate).




If multiple cities tie for the highest total, return return all of those cities. Output the name of the city/cities.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_amenity_counts AS (
    SELECT
        city,
        -- Count commas + 1 to get number of amenities per row, sum across city
        SUM(
            CASE
                WHEN amenities IS NULL OR TRIM(amenities) = '' THEN 0
                ELSE array_length(string_to_array(amenities, ','), 1)
            END
        ) AS total_amenities
    FROM airbnb_search_details
    GROUP BY city
),
ranked AS (
    SELECT
        city,
        total_amenities,
        RANK() OVER (ORDER BY total_amenities DESC) AS rnk
    FROM city_amenity_counts
)
SELECT city
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT city
FROM (
    SELECT
        city,
        SUM(
            CASE
                WHEN amenities IS NULL OR TRIM(amenities) = '' THEN 0
                ELSE array_length(string_to_array(amenities, ','), 1)
            END
        ) AS total_amenities
    FROM airbnb_search_details
    GROUP BY city
) city_totals
WHERE total_amenities = (
    SELECT MAX(total_amenities)
    FROM (
        SELECT
            city,
            SUM(
                CASE
                    WHEN amenities IS NULL OR TRIM(amenities) = '' THEN 0
                    ELSE array_length(string_to_array(amenities, ','), 1)
                END
            ) AS total_amenities
        FROM airbnb_search_details
        GROUP BY city
    ) inner_totals
);
