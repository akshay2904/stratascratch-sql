-- ======================================================================
-- Five-Year Sales Growth Regions
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Visa
-- Access     : Premium
-- ID         : 10550
-- URL        : https://platform.stratascratch.com/coding/10550-five-year-sales-growth-regions
-- ======================================================================

/*
Find all regions where sales have increased for five consecutive years. A region qualifies if, for each of the five years, sales are higher than in the previous year. Return the region name along with the starting year of the five-year growth period.
*/

-- Tables:
--   regional_sales(region_name text, sales double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assume table: regional_sales(region, year, sales)

WITH yearly_sales AS (
    SELECT
        region,
        year,
        sales,
        LAG(sales) OVER (PARTITION BY region ORDER BY year) AS prev_sales,
        LAG(year)  OVER (PARTITION BY region ORDER BY year) AS prev_year
    FROM regional_sales
),
growth_flags AS (
    -- Mark each year as 1 if sales grew vs prior year AND years are consecutive
    SELECT
        region,
        year,
        CASE
            WHEN sales > prev_sales
             AND year = prev_year + 1 THEN 1
            ELSE 0
        END AS grew
    FROM yearly_sales
),
running_growth AS (
    -- Count consecutive growing years ending at each row
    SELECT
        region,
        year,
        grew,
        SUM(CASE WHEN grew = 0 THEN 1 ELSE 0 END)
            OVER (PARTITION BY region ORDER BY year
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS break_group
    FROM growth_flags
),
streak_lengths AS (
    -- Within each unbroken streak, compute how many consecutive grows have occurred
    SELECT
        region,
        year,
        grew,
        SUM(grew) OVER (
            PARTITION BY region, break_group
            ORDER BY year
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS streak
    FROM running_growth
)
-- A streak of 4 consecutive grows means 5 consecutive years of increasing sales.
-- The starting year is (current year - 4).
SELECT DISTINCT
    region,
    year - 4 AS start_year
FROM streak_lengths
WHERE streak >= 4
ORDER BY region, start_year;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Self-join approach: anchor on year y, then verify y+1, y+2, y+3, y+4 all grow
SELECT
    s1.region,
    s1.year AS start_year
FROM regional_sales s1
JOIN regional_sales s2
    ON s2.region = s1.region AND s2.year = s1.year + 1
JOIN regional_sales s3
    ON s3.region = s1.region AND s3.year = s1.year + 2
JOIN regional_sales s4
    ON s4.region = s1.region AND s4.year = s1.year + 3
JOIN regional_sales s5
    ON s5.region = s1.region AND s5.year = s1.year + 4
WHERE
    s2.sales > s1.sales   -- year 2 > year 1
AND s3.sales > s2.sales   -- year 3 > year 2
AND s4.sales > s3.sales   -- year 4 > year 3
AND s5.sales > s4.sales   -- year 5 > year 4
ORDER BY s1.region, s1.year;
