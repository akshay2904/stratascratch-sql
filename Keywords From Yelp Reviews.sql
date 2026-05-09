-- ======================================================================
-- Keywords From Yelp Reviews
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Yelp
-- Access     : Premium
-- ID         : 9612
-- URL        : https://platform.stratascratch.com/coding/9612-keywords-from-yelp-reviews
-- ======================================================================

/*
Find Yelp food reviews containing any of the keywords: 'food', 'pizza', 'sandwich', or 'burger'. List the business name, address, and the state which satisfies the requirement.
*/

-- Tables:
--   yelp_business(address text, business_id text, categories text, city text, is_open bigint, latitude double precision, longitude double precision, name text, neighborhood text, postal_code text, review_count bigint, stars double precision, state text)
--   yelp_reviews(business_name text, cool bigint, funny bigint, review_date date, review_id text, review_text text, stars text, useful bigint, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT DISTINCT
    b.name        AS business_name,
    b.address,
    b.state
FROM business b
JOIN review r ON b.business_id = r.business_id
WHERE b.categories ILIKE '%food%'
   OR b.categories ILIKE '%restaurant%'
   OR b.categories ILIKE '%pizza%'
   OR b.categories ILIKE '%sandwich%'
   OR b.categories ILIKE '%burger%'
AND (
    r.text ILIKE '%food%'
    OR r.text ILIKE '%pizza%'
    OR r.text ILIKE '%sandwich%'
    OR r.text ILIKE '%burger%'
)
ORDER BY b.name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    b.name        AS business_name,
    b.address,
    b.state
FROM business b
WHERE b.business_id IN (
    SELECT r.business_id
    FROM review r
    WHERE r.text ILIKE '%food%'
       OR r.text ILIKE '%pizza%'
       OR r.text ILIKE '%sandwich%'
       OR r.text ILIKE '%burger%'
)
ORDER BY b.name;
