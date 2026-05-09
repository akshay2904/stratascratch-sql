-- ======================================================================
-- Average Customers Per City
-- ======================================================================
-- Difficulty : Medium
-- Companies  : LinkedIn
-- Access     : Premium
-- ID         : 2055
-- URL        : https://platform.stratascratch.com/coding/2055-average-customers-per-city
-- ======================================================================

/*
Write a query that will return all cities with more customers than the average number of  customers of all cities that have at least one customer. For each such city, return the country name,  the city name, and the number of customers
*/

-- Tables:
--   linkedin_customers(business_name text, city_id bigint, id bigint)
--   linkedin_city(city_name text, country_id bigint, id bigint)
--   linkedin_country(country_name text, id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_customer_counts AS (
    SELECT
        ci.city_id,
        ci.city,
        co.country,
        COUNT(cu.customer_id) AS customer_count
    FROM city ci
    JOIN country co ON ci.country_id = co.country_id
    JOIN customer cu ON ci.city_id = cu.city_id  -- INNER JOIN ensures only cities with >= 1 customer
    GROUP BY ci.city_id, ci.city, co.country
),
avg_customers AS (
    SELECT AVG(customer_count) AS avg_count
    FROM city_customer_counts
)
SELECT
    ccc.country,
    ccc.city,
    ccc.customer_count
FROM city_customer_counts ccc
CROSS JOIN avg_customers av
WHERE ccc.customer_count > av.avg_count
ORDER BY ccc.customer_count DESC, ccc.country, ccc.city;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    co.country,
    ci.city,
    COUNT(cu.customer_id) AS customer_count
FROM city ci
JOIN country co ON ci.country_id = co.country_id
JOIN customer cu ON ci.city_id = cu.city_id
GROUP BY co.country, ci.city
HAVING COUNT(cu.customer_id) > (
    -- average customers per city, only among cities that have at least one customer
    SELECT AVG(city_total)
    FROM (
        SELECT COUNT(customer_id) AS city_total
        FROM customer
        GROUP BY city_id
    ) AS city_counts
)
ORDER BY customer_count DESC, co.country, ci.city;
