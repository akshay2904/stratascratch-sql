-- ======================================================================
-- Number of Speakers By Language
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Apple, Google
-- Access     : Premium
-- ID         : 10139
-- URL        : https://platform.stratascratch.com/coding/10139-number-of-speakers-by-language
-- ======================================================================

/*
Find the number of speakers of each language by country. Output the country, language, and the corresponding number of speakers. Output the result based on the country in ascending order.
*/

-- Tables:
--   playbook_events(device text, event_name text, event_type text, location text, occurred_at timestamp without time zone, user_id bigint)
--   playbook_users(activated_at date, company_id bigint, created_at timestamp without time zone, language text, state text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    country,
    language,
    ROUND(population * percentage / 100) AS speakers
FROM countrylanguage cl
JOIN country c ON cl.countrycode = c.code
ORDER BY country ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    c.name AS country,
    cl.language,
    ROUND(c.population * cl.percentage / 100) AS speakers
FROM country c, countrylanguage cl
WHERE c.code = cl.countrycode
ORDER BY c.name ASC;
