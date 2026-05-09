-- ======================================================================
-- Highest Priced Wine In The US
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10044
-- URL        : https://platform.stratascratch.com/coding/10044-highest-priced-wine-in-the-us
-- ======================================================================

/*
Find the highest price in US country for each variety produced in English speaking regions, but not in Spanish speaking regions, with taking into consideration varieties that have earned a minimum of 90 points for every country they're produced in.
Output both the variety and the corresponding highest price.




Let's assume the US is the only English speaking region in the dataset, and Spain, Argentina are the only Spanish speaking regions in the dataset. Let's also assume that the same variety might be listed under several countries so you'll need to remove varieties that show up in both the US and in Spanish speaking countries.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH
-- Varieties where EVERY record (across all countries) has points >= 90
qualified_varieties AS (
    SELECT variety
    FROM wines
    GROUP BY variety
    HAVING MIN(points) >= 90
),

-- Varieties produced in English-speaking regions (US only)
english_varieties AS (
    SELECT DISTINCT variety
    FROM wines
    WHERE country = 'US'
),

-- Varieties produced in Spanish-speaking regions (Spain, Argentina)
spanish_varieties AS (
    SELECT DISTINCT variety
    FROM wines
    WHERE country IN ('Spain', 'Argentina')
),

-- Varieties exclusive to English-speaking (US) and not in Spanish-speaking regions
exclusive_english AS (
    SELECT ev.variety
    FROM english_varieties ev
    LEFT JOIN spanish_varieties sv ON ev.variety = sv.variety
    WHERE sv.variety IS NULL
)

SELECT
    w.variety,
    MAX(w.price) AS highest_price
FROM wines w
-- Only US prices
WHERE w.country = 'US'
  AND w.variety IN (SELECT variety FROM qualified_varieties)
  AND w.variety IN (SELECT variety FROM exclusive_english)
GROUP BY w.variety;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    variety,
    MAX(price) AS highest_price
FROM wines
WHERE country = 'US'
  -- Must be a qualified variety: every record across all countries has >= 90 points
  AND variety IN (
      SELECT variety
      FROM wines
      GROUP BY variety
      HAVING MIN(points) >= 90
  )
  -- Must appear in US (English-speaking)
  AND variety IN (
      SELECT DISTINCT variety
      FROM wines
      WHERE country = 'US'
  )
  -- Must NOT appear in any Spanish-speaking country
  AND variety NOT IN (
      SELECT DISTINCT variety
      FROM wines
      WHERE country IN ('Spain', 'Argentina')
  )
GROUP BY variety;
