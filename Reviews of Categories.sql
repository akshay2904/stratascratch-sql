-- ======================================================================
-- Reviews of Categories
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Yelp
-- Access     : Free
-- ID         : 10049
-- URL        : https://platform.stratascratch.com/coding/10049-reviews-of-categories
-- ======================================================================

/*
Calculate number of reviews for every business category. Output the category along with the total number of reviews. Order by total reviews in descending order.
*/

-- Tables:
--   yelp_business(address text, business_id text, categories text, city text, is_open bigint, latitude double precision, longitude double precision, name text, neighborhood text, postal_code text, review_count bigint, stars double precision, state text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH category_reviews AS (
    SELECT
        TRIM(UNNEST(STRING_TO_ARRAY(b.categories, ';'))) AS category,
        b.review_count
    FROM business b
    WHERE b.categories IS NOT NULL
)
SELECT
    category,
    SUM(review_count) AS total_reviews
FROM category_reviews
WHERE category <> ''
GROUP BY category
ORDER BY total_reviews DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TRIM(UNNEST(STRING_TO_ARRAY(b.categories, ';'))) AS category,
    SUM(b.review_count) AS total_reviews
FROM business b
WHERE b.categories IS NOT NULL
GROUP BY TRIM(UNNEST(STRING_TO_ARRAY(b.categories, ';')))
HAVING TRIM(UNNEST(STRING_TO_ARRAY(b.categories, ';'))) <> ''
ORDER BY total_reviews DESC;
