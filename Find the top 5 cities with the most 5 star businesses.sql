-- ======================================================================
-- Find the top 5 cities with the most 5 star businesses
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Yelp
-- Access     : Premium
-- ID         : 10148
-- URL        : https://platform.stratascratch.com/coding/10148-find-the-top-10-cities-with-the-most-5-star-businesses
-- ======================================================================

/*
Find the top 5 cities with the highest number of 5-star businesses.




The output should include the city name and the total count of 5-star businesses in that city, considering both open and closed businesses. If two or more cities have the same number of 5-star businesses, assign them the same rank, and skip the next rank accordingly. For example, if two cities tie for 1st place, the following city should be ranked 3rd.
*/

-- Tables:
--   yelp_business(address text, business_id text, categories text, city text, is_open bigint, latitude double precision, longitude double precision, name text, neighborhood text, postal_code text, review_count bigint, stars double precision, state text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_counts AS (
    SELECT
        city,
        COUNT(*) AS five_star_count
    FROM business
    WHERE stars = 5
    GROUP BY city
),
ranked AS (
    SELECT
        city,
        five_star_count,
        RANK() OVER (ORDER BY five_star_count DESC) AS rnk
    FROM city_counts
)
SELECT
    city,
    five_star_count,
    rnk
FROM ranked
WHERE rnk <= 5
ORDER BY rnk;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    city,
    five_star_count
FROM (
    SELECT
        city,
        COUNT(*) AS five_star_count,
        -- count how many cities have strictly more 5-star businesses (for rank)
        (
            SELECT COUNT(DISTINCT b2.city)
            FROM business b2
            WHERE b2.stars = 5
            GROUP BY b2.city
            HAVING COUNT(*) > COUNT(b1.business_id)  -- placeholder; rewritten below
        ) AS rnk
    FROM business b1
    WHERE stars = 5
    GROUP BY city
) sub
WHERE (
    -- rank = 1 + number of cities with a higher count
    SELECT COUNT(*)
    FROM (
        SELECT city, COUNT(*) AS cnt
        FROM business
        WHERE stars = 5
        GROUP BY city
    ) other
    WHERE other.cnt > sub.five_star_count
) < 5   -- rank <= 5 means fewer than 5 cities are strictly ahead
ORDER BY five_star_count DESC;
