-- ======================================================================
-- Find the postal code which has the highest average inspection score
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9724
-- URL        : https://platform.stratascratch.com/coding/9724-find-the-postal-code-which-has-the-highest-average-inspection-score
-- ======================================================================

/*
Find the postal code which has the highest average inspection score.
Output the corresponding postal code along with the result.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH avg_scores AS (
    SELECT
        business_postal_code,
        AVG(inspection_score) AS avg_score,
        RANK() OVER (ORDER BY AVG(inspection_score) DESC) AS rnk
    FROM sf_restaurant_health_violations
    WHERE inspection_score IS NOT NULL
      AND business_postal_code IS NOT NULL
    GROUP BY business_postal_code
)
SELECT
    business_postal_code,
    avg_score
FROM avg_scores
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    business_postal_code,
    AVG(inspection_score) AS avg_score
FROM sf_restaurant_health_violations
WHERE inspection_score IS NOT NULL
  AND business_postal_code IS NOT NULL
GROUP BY business_postal_code
HAVING AVG(inspection_score) = (
    SELECT MAX(avg_by_postal)
    FROM (
        SELECT AVG(inspection_score) AS avg_by_postal
        FROM sf_restaurant_health_violations
        WHERE inspection_score IS NOT NULL
          AND business_postal_code IS NOT NULL
        GROUP BY business_postal_code
    ) sub
);
