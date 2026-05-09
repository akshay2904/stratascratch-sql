-- ======================================================================
-- Best Wines By Points-To-Price
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10032
-- URL        : https://platform.stratascratch.com/coding/10032-best-wines-by-points-to-price
-- ======================================================================

/*
Find the wine with the highest points to price ratio. Output the title, points, price, and the corresponding points-to-price ratio.
*/

-- Tables:
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        title,
        points,
        price,
        points::numeric / price AS points_to_price_ratio,
        RANK() OVER (ORDER BY points::numeric / price DESC) AS rnk
    FROM wine_reviews
    WHERE price IS NOT NULL AND price > 0
)
SELECT
    title,
    points,
    price,
    points_to_price_ratio
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    title,
    points,
    price,
    points::numeric / price AS points_to_price_ratio
FROM wine_reviews
WHERE price IS NOT NULL AND price > 0
  AND points::numeric / price = (
      SELECT MAX(points::numeric / price)
      FROM wine_reviews
      WHERE price IS NOT NULL AND price > 0
  );
