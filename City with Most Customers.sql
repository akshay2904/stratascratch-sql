-- ======================================================================
-- City with Most Customers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 2079
-- URL        : https://platform.stratascratch.com/coding/2079-city-with-most-customers
-- ======================================================================

/*
For each city, find the number of rides in August 2021 that were paid without using a promotional code (i.e., where no discount was applied). Output the city or cities where this number was the highest.
*/

-- Tables:
--   lyft_orders(city text, country text, customer_id text, driver_id text, order_id bigint)
--   lyft_payments(order_date date, order_fare double precision, order_id bigint, promo_code boolean)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_counts AS (
    SELECT
        city,
        COUNT(*) AS ride_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM rides
    WHERE
        DATE_TRUNC('month', ride_date) = '2021-08-01'
        AND (discount IS NULL OR discount = 0)
    GROUP BY city
)
SELECT city, ride_count
FROM city_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT city, COUNT(*) AS ride_count
FROM rides
WHERE
    DATE_TRUNC('month', ride_date) = '2021-08-01'
    AND (discount IS NULL OR discount = 0)
GROUP BY city
HAVING COUNT(*) = (
    SELECT MAX(city_count)
    FROM (
        SELECT COUNT(*) AS city_count
        FROM rides
        WHERE
            DATE_TRUNC('month', ride_date) = '2021-08-01'
            AND (discount IS NULL OR discount = 0)
        GROUP BY city
    ) sub
);
