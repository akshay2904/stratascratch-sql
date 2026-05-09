-- ======================================================================
-- Find the unique room types
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9642
-- URL        : https://platform.stratascratch.com/coding/9642-find-the-number-of-unique-properties
-- ======================================================================

/*
Find the unique room types(filter room types column). Output each unique room types in its own row.
*/

-- Tables:
--   airbnb_searches(ds date, ds_checkin date, ds_checkout date, filter_neighborhoods text, filter_price_max double precision, filter_price_min double precision, filter_room_types text, id_user text, n_guests_max bigint, n_guests_min bigint, n_nights double precision, n_searches bigint, origin_country text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT DISTINCT TRIM(room_type) AS room_type
FROM airbnb_search_details
ORDER BY room_type;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT room_type
FROM airbnb_search_details
GROUP BY room_type
ORDER BY room_type;
