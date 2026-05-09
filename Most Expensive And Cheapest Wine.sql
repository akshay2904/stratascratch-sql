-- ======================================================================
-- Most Expensive And Cheapest Wine
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10041
-- URL        : https://platform.stratascratch.com/coding/10041-most-expensive-and-cheapest-wine
-- ======================================================================

/*
Find the cheapest and the most expensive variety in each region. Output the region along with the corresponding most expensive and the cheapest variety. Be aware that there are 2 region columns, the price from that row applies to both of them.




Note: The results set contains no ties.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        region_1,
        region_2,
        variety,
        price,
        -- Rank by price within each region_1
        MIN(price) OVER (PARTITION BY region_1) AS min_price_r1,
        MAX(price) OVER (PARTITION BY region_1) AS max_price_r1,
        MIN(price) OVER (PARTITION BY region_2) AS min_price_r2,
        MAX(price) OVER (PARTITION BY region_2) AS max_price_r2
    FROM winemag_p1
    WHERE price IS NOT NULL
),
-- Unpivot both region columns into a single region column
region_unpivoted AS (
    SELECT region_1 AS region, variety, price,
           min_price_r1 AS min_price, max_price_r1 AS max_price
    FROM ranked
    WHERE region_1 IS NOT NULL
    UNION ALL
    SELECT region_2 AS region, variety, price,
           min_price_r2 AS min_price, max_price_r2 AS max_price
    FROM ranked
    WHERE region_2 IS NOT NULL
),
extremes AS (
    SELECT
        region,
        MAX(CASE WHEN price = max_price THEN variety END) AS most_expensive_variety,
        MAX(CASE WHEN price = min_price THEN variety END) AS cheapest_variety
    FROM region_unpivoted
    GROUP BY region
)
SELECT region, most_expensive_variety, cheapest_variety
FROM extremes
WHERE most_expensive_variety IS NOT NULL
  AND cheapest_variety IS NOT NULL
ORDER BY region;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH all_regions AS (
    -- Combine both region columns into one
    SELECT region_1 AS region, variety, price
    FROM winemag_p1
    WHERE region_1 IS NOT NULL AND price IS NOT NULL
    UNION ALL
    SELECT region_2 AS region, variety, price
    FROM winemag_p1
    WHERE region_2 IS NOT NULL AND price IS NOT NULL
),
region_min_max AS (
    SELECT region, MIN(price) AS min_price, MAX(price) AS max_price
    FROM all_regions
    GROUP BY region
),
cheapest AS (
    SELECT ar.region, ar.variety AS cheapest_variety
    FROM all_regions ar
    JOIN region_min_max rmm
      ON ar.region = rmm.region AND ar.price = rmm.min_price
),
most_expensive AS (
    SELECT ar.region, ar.variety AS most_expensive_variety
    FROM all_regions ar
    JOIN region_min_max rmm
      ON ar.region = rmm.region AND ar.price = rmm.max_price
)
SELECT c.region, me.most_expensive_variety, c.cheapest_variety
FROM cheapest c
JOIN most_expensive me ON c.region = me.region
ORDER BY c.region;
