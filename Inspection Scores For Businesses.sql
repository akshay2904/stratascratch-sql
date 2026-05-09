-- ======================================================================
-- Inspection Scores For Businesses
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9741
-- URL        : https://platform.stratascratch.com/coding/9741-inspection-scores-for-businesses
-- ======================================================================

/*
Find the median inspection score of each business and output the result along with the business name. Order records based on the inspection score in descending order.
Try to come up with your own precise median calculation. In Postgres there is percentile_disc function available, however it's only approximation.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        b.name,
        i.score,
        -- Row number ascending and descending to find median position(s)
        ROW_NUMBER() OVER (PARTITION BY i.business_id ORDER BY i.score ASC)  AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY i.business_id ORDER BY i.score DESC) AS rn_desc,
        COUNT(*) OVER (PARTITION BY i.business_id) AS total_count
    FROM businesses b
    JOIN inspections i ON b.business_id = i.business_id
    WHERE i.score IS NOT NULL
),
median_rows AS (
    SELECT
        name,
        score
    FROM ranked
    -- For odd count: rn_asc = rn_desc (middle row)
    -- For even count: the two middle rows satisfy rn_asc IN (rn_desc, rn_desc+1)
    -- Simplified: keep rows where rn_asc >= rn_desc and rn_asc <= rn_desc + 1
    WHERE rn_asc BETWEEN rn_desc AND rn_desc + 1
       OR rn_desc BETWEEN rn_asc AND rn_asc + 1
)
SELECT
    name,
    -- Average of the one or two middle values gives exact median
    AVG(score) AS median_score
FROM median_rows
GROUP BY name
ORDER BY median_score DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    b.name,
    -- Average the middle value(s) for exact median
    AVG(i.score) AS median_score
FROM businesses b
JOIN inspections i ON b.business_id = i.business_id
WHERE i.score IS NOT NULL
  AND (
      -- This score is a "middle" value:
      -- Number of scores <= this score >= half of total
      -- AND number of scores >= this score >= half of total
      (
          SELECT COUNT(*)
          FROM inspections i2
          WHERE i2.business_id = i.business_id
            AND i2.score IS NOT NULL
            AND i2.score <= i.score
      ) >= (
          SELECT CEIL(COUNT(*) / 2.0)
          FROM inspections i3
          WHERE i3.business_id = i.business_id
            AND i3.score IS NOT NULL
      )
      AND
      (
          SELECT COUNT(*)
          FROM inspections i4
          WHERE i4.business_id = i.business_id
            AND i4.score IS NOT NULL
            AND i4.score >= i.score
      ) >= (
          SELECT CEIL(COUNT(*) / 2.0)
          FROM inspections i5
          WHERE i5.business_id = i.business_id
            AND i5.score IS NOT NULL
      )
  )
GROUP BY b.business_id, b.name
ORDER BY median_score DESC;
