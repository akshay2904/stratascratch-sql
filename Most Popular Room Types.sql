-- ======================================================================
-- Most Popular Room Types
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9763
-- URL        : https://platform.stratascratch.com/coding/9763-most-popular-room-types
-- ======================================================================

/*
Find the room types that are searched by most people. Output the room type alongside the number of searches for it. If the filter for room types has more than one room type, consider only unique room types as a separate row. Sort the result based on the number of searches in descending order.
*/

-- Tables:
--   airbnb_searches(ds date, ds_checkin date, ds_checkout date, filter_neighborhoods text, filter_price_max double precision, filter_price_min double precision, filter_room_types text, id_user text, n_guests_max bigint, n_guests_min bigint, n_nights double precision, n_searches bigint, origin_country text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH unnested AS (
    -- Split comma-separated or multi-value room types into individual rows
    SELECT TRIM(UNNEST(STRING_TO_ARRAY(filter_room_types, ','))) AS room_type
    FROM airbnb_searches
    WHERE filter_room_types IS NOT NULL
      AND filter_room_types <> ''
)
SELECT
    room_type,
    COUNT(*) AS num_searches
FROM unnested
WHERE room_type <> ''
GROUP BY room_type
ORDER BY num_searches DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TRIM(room_type_val) AS room_type,
    COUNT(*) AS num_searches
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(filter_room_types, ',')) AS room_type_val
    FROM airbnb_searches
    WHERE filter_room_types IS NOT NULL
      AND filter_room_types <> ''
) AS split_types
WHERE TRIM(room_type_val) <> ''
GROUP BY TRIM(room_type_val)
ORDER BY num_searches DESC;
