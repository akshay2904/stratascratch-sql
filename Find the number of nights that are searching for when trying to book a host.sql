-- ======================================================================
-- Find the number of nights that are searching for when trying to book a host
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9761
-- URL        : https://platform.stratascratch.com/coding/9761-find-the-number-of-nights-that-are-searching-for-when-trying-to-book-a-host
-- ======================================================================

/*
Find the number of nights that are searched by most people when trying to book a host.
Output the number of nights alongside the total searches.
Order records based on the total searches in descending order.
*/

-- Tables:
--   airbnb_searches(ds date, ds_checkin date, ds_checkout date, filter_neighborhoods text, filter_price_max double precision, filter_price_min double precision, filter_room_types text, id_user text, n_guests_max bigint, n_guests_min bigint, n_nights double precision, n_searches bigint, origin_country text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH search_counts AS (
    SELECT 
        n_nights,
        COUNT(*) AS total_searches,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM airbnb_searches
    WHERE n_nights IS NOT NULL
    GROUP BY n_nights
)
SELECT 
    n_nights,
    total_searches
FROM search_counts
WHERE rnk = 1
ORDER BY total_searches DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    n_nights,
    COUNT(*) AS total_searches
FROM airbnb_searches
WHERE n_nights IS NOT NULL
GROUP BY n_nights
HAVING COUNT(*) = (
    SELECT MAX(search_count)
    FROM (
        SELECT COUNT(*) AS search_count
        FROM airbnb_searches
        WHERE n_nights IS NOT NULL
        GROUP BY n_nights
    ) AS sub
)
ORDER BY total_searches DESC;
