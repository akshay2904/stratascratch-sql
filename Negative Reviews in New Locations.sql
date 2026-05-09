-- ======================================================================
-- Negative Reviews in New Locations
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Instacart
-- Access     : Premium
-- ID         : 2087
-- URL        : https://platform.stratascratch.com/coding/2087-negative-reviews-in-new-locations
-- ======================================================================

/*
Find stores that were opened in the second half of 2021 with more than 20% of their reviews being negative. A review is considered negative when the score given by a customer is below 5. Output the names of the stores together with the ratio of negative reviews to positive ones.
*/

-- Tables:
--   instacart_reviews(customer_id bigint, id bigint, score bigint, store_id bigint)
--   instacart_stores(id bigint, name text, opening_date date, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH store_stats AS (
    SELECT
        s.store_name,
        COUNT(*) AS total_reviews,
        COUNT(*) FILTER (WHERE r.score < 5) AS negative_reviews,
        COUNT(*) FILTER (WHERE r.score >= 5) AS positive_reviews
    FROM stores s
    JOIN reviews r ON s.store_id = r.store_id
    WHERE s.open_date >= '2021-07-01'
      AND s.open_date <  '2022-01-01'
    GROUP BY s.store_name
)
SELECT
    store_name,
    -- ratio of negative to positive reviews
    ROUND(
        negative_reviews::NUMERIC / NULLIF(positive_reviews, 0), 4
    ) AS negative_to_positive_ratio
FROM store_stats
WHERE negative_reviews::NUMERIC / total_reviews > 0.20
ORDER BY store_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.store_name,
    ROUND(
        SUM(CASE WHEN r.score < 5 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(SUM(CASE WHEN r.score >= 5 THEN 1 ELSE 0 END), 0),
        4
    ) AS negative_to_positive_ratio
FROM stores s
JOIN reviews r ON s.store_id = r.store_id
WHERE s.open_date >= '2021-07-01'
  AND s.open_date <  '2022-01-01'
GROUP BY s.store_name
HAVING
    SUM(CASE WHEN r.score < 5 THEN 1 ELSE 0 END)::NUMERIC
    / COUNT(*) > 0.20
ORDER BY s.store_name;
