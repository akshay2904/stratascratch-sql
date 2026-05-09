-- ======================================================================
-- Median Price Of Wines
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10043
-- URL        : https://platform.stratascratch.com/coding/10043-median-price-of-wines
-- ======================================================================

/*
Find the median price for each wine variety across both datasets. Output distinct varieties along with the corresponding median price.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)
--   winemag_p2(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, taster_name text, taster_twitter_handle text, title text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH combined AS (
    SELECT variety, price
    FROM winemag_p1
    WHERE variety IS NOT NULL AND price IS NOT NULL
    UNION ALL
    SELECT variety, price
    FROM winemag_p2
    WHERE variety IS NOT NULL AND price IS NOT NULL
),
ranked AS (
    SELECT
        variety,
        price,
        ROW_NUMBER() OVER (PARTITION BY variety ORDER BY price) AS rn,
        COUNT(*)      OVER (PARTITION BY variety)               AS cnt
    FROM combined
)
SELECT
    variety,
    -- Average the one or two middle values to handle both odd and even counts
    AVG(price) AS median_price
FROM ranked
WHERE rn IN (FLOOR((cnt + 1) / 2.0), CEIL((cnt + 1) / 2.0))
GROUP BY variety
ORDER BY variety;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH combined AS (
    SELECT variety, price
    FROM winemag_p1
    WHERE variety IS NOT NULL AND price IS NOT NULL
    UNION ALL
    SELECT variety, price
    FROM winemag_p2
    WHERE variety IS NOT NULL AND price IS NOT NULL
),
counts AS (
    SELECT variety, COUNT(*) AS cnt
    FROM combined
    GROUP BY variety
),
-- For each row, count how many prices are <= it (lower rank) and >= it (upper rank)
-- Median condition: lower_rank >= cnt/2 AND upper_rank >= cnt/2 (i.e., middle values)
median_prices AS (
    SELECT
        c.variety,
        c.price,
        ct.cnt,
        -- Number of rows with price <= current price within same variety
        (SELECT COUNT(*)
         FROM combined c2
         WHERE c2.variety = c.variety AND c2.price <= c.price) AS lower_rank,
        -- Number of rows with price >= current price within same variety
        (SELECT COUNT(*)
         FROM combined c2
         WHERE c2.variety = c.variety AND c2.price >= c.price) AS upper_rank
    FROM combined c
    JOIN counts ct ON ct.variety = c.variety
)
SELECT
    variety,
    AVG(price) AS median_price
FROM median_prices
-- A price is a median candidate when both halves satisfy the median condition
WHERE lower_rank >= cnt / 2.0
  AND upper_rank >= cnt / 2.0
GROUP BY variety
ORDER BY variety;
