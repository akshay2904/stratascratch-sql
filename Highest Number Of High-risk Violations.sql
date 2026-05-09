-- ======================================================================
-- Highest Number Of High-risk Violations
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9736
-- URL        : https://platform.stratascratch.com/coding/9736-highest-number-of-high-risk-violations
-- ======================================================================

/*
Find details of the business with the highest number of high-risk violations. Output all columns from the dataset considering business_id which consist 'high risk' phrase in risk_category column.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH high_risk_counts AS (
    SELECT
        *,
        COUNT(*) OVER (PARTITION BY business_id) AS violation_count,
        RANK() OVER (ORDER BY COUNT(*) OVER (PARTITION BY business_id) DESC) AS rnk
    FROM inspections
    WHERE LOWER(risk_category) LIKE '%high risk%'
)
SELECT * EXCEPT(violation_count, rnk)
FROM high_risk_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT *
FROM inspections
WHERE LOWER(risk_category) LIKE '%high risk%'
  AND business_id = (
      SELECT business_id
      FROM inspections
      WHERE LOWER(risk_category) LIKE '%high risk%'
      GROUP BY business_id
      ORDER BY COUNT(*) DESC
      LIMIT 1
  );
