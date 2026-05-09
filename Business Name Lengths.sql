-- ======================================================================
-- Business Name Lengths
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 10131
-- URL        : https://platform.stratascratch.com/coding/10131-business-name-lengths
-- ======================================================================

/*
Find the number of words in each business name. Avoid counting special symbols as words (e.g. &). Output the business name and its count of words.
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use regexp_count to count sequences of alphanumeric characters (words, ignoring symbols like &)
SELECT 
    name,
    COALESCE(
        (SELECT COUNT(*) 
         FROM regexp_matches(name, '[A-Za-z0-9]+', 'g')),
        0
    ) AS word_count
FROM business;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Split the name into tokens, filter out non-alphanumeric tokens, then count
SELECT
    name,
    COUNT(word) AS word_count
FROM (
    SELECT
        b.name,
        -- Extract each space-separated token
        unnest(string_to_array(b.name, ' ')) AS word
    FROM business b
) tokens
WHERE word ~ '[A-Za-z0-9]'  -- only count tokens that contain at least one alphanumeric char
GROUP BY name;
