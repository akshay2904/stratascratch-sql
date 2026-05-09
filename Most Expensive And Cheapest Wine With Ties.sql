-- ======================================================================
-- Most Expensive And Cheapest Wine With Ties
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 2147
-- URL        : https://platform.stratascratch.com/coding/2147-most-expensive-and-cheapest-wine-with-ties
-- ======================================================================

/*
Find the cheapest and the most expensive variety in each region. Output the region along with the corresponding most expensive and the cheapest variety. Be aware that there are 2 region columns, the price from that row applies to both of them.




Note: The results set contains ties, so your solution should account for this.




For example in the event of a tie for the cheapest wine your output should look similar to this:




region             | most_expensive_variety | cheapest_variety

region_name | expensive_variety             | cheap_variety_1

region_name | expensive_variety             | cheap_variety_2
*/

-- Tables:
--   winemag_pd(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH combined_regions AS (
    -- Unpivot the two region columns into one
    SELECT price, variety, region_1 AS region FROM winemag_p1 WHERE region_1 IS NOT NULL
    UNION ALL
    SELECT price, variety, region_2 AS region FROM winemag_p1 WHERE region_2 IS NOT NULL
),
region_stats AS (
    SELECT
        region,
        variety,
        price,
        MAX(price) OVER (PARTITION BY region) AS max_price,
        MIN(price) OVER (PARTITION BY region) AS min_price
    FROM combined_regions
    WHERE price IS NOT NULL
),
expensive AS (
    SELECT DISTINCT region, variety AS most_expensive_variety
    FROM region_stats
    WHERE price = max_price
),
cheapest AS (
    SELECT DISTINCT region, variety AS cheapest_variety
    FROM region_stats
    WHERE price = min_price
)
SELECT
    e.region,
    e.most_expensive_variety,
    c.cheapest_variety
FROM expensive e
JOIN cheapest c ON e.region = c.region
ORDER BY e.region, e.most_expensive_variety, c.cheapest_variety;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH combined_regions AS (
    SELECT price, variety, region_1 AS region FROM winemag_p1 WHERE region_1 IS NOT NULL
    UNION ALL
    SELECT price, variety, region_2 AS region FROM winemag_p1 WHERE region_2 IS NOT NULL
),
region_min_max AS (
    SELECT
        region,
        MAX(price) AS max_price,
        MIN(price) AS min_price
    FROM combined_regions
    WHERE price IS NOT NULL
    GROUP BY region
),
expensive AS (
    SELECT DISTINCT c.region, c.variety AS most_expensive_variety
    FROM combined_regions c
    JOIN region_min_max rm ON c.region = rm.region AND c.price = rm.max_price
),
cheapest AS (
    SELECT DISTINCT c.region, c.variety AS cheapest_variety
    FROM combined_regions c
    JOIN region_min_max rm ON c.region = rm.region AND c.price = rm.min_price
)
SELECT
    e.region,
    e.most_expensive_variety,
    c.cheapest_variety
FROM expensive e
JOIN cheapest c ON e.region = c.region
ORDER BY e.region, e.most_expensive_variety, c.cheapest_variety;
