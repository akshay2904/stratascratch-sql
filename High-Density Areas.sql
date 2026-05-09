-- ======================================================================
-- High-Density Areas
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Visa
-- Access     : Premium
-- ID         : 10544
-- URL        : https://platform.stratascratch.com/coding/10544-high-density-areas
-- ======================================================================

/*
Identify the top 3 areas with the highest customer density. Customer density = (total number of unique customers in the area / area size).




Your output should include the area name and its calculated customer density, and ties will be ranked the same.
*/

-- Tables:
--   transaction_records(customer_id bigint, store_id bigint, transaction_amount bigint, transaction_date date, transaction_id bigint)
--   stores(area_name text, area_size bigint, store_id bigint, store_location text, store_open_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH density_calc AS (
    SELECT
        a.area_name,
        COUNT(DISTINCT c.customer_id) AS unique_customers,
        a.area_size,
        COUNT(DISTINCT c.customer_id)::NUMERIC / NULLIF(a.area_size, 0) AS customer_density
    FROM areas a
    LEFT JOIN customers c ON c.area_id = a.area_id
    GROUP BY a.area_id, a.area_name, a.area_size
),
ranked AS (
    SELECT
        area_name,
        customer_density,
        DENSE_RANK() OVER (ORDER BY customer_density DESC) AS rnk
    FROM density_calc
)
SELECT
    area_name,
    customer_density
FROM ranked
WHERE rnk <= 3
ORDER BY customer_density DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    area_name,
    customer_density
FROM (
    SELECT
        a.area_name,
        COUNT(DISTINCT c.customer_id)::NUMERIC / NULLIF(a.area_size, 0) AS customer_density
    FROM areas a
    LEFT JOIN customers c ON c.area_id = a.area_id
    GROUP BY a.area_id, a.area_name, a.area_size
) AS density_subquery
WHERE customer_density >= (
    -- Find the minimum density among the top 3 distinct density values
    SELECT MIN(cd)
    FROM (
        SELECT DISTINCT
            COUNT(DISTINCT c2.customer_id)::NUMERIC / NULLIF(a2.area_size, 0) AS cd
        FROM areas a2
        LEFT JOIN customers c2 ON c2.area_id = a2.area_id
        GROUP BY a2.area_id, a2.area_size
        ORDER BY cd DESC
        LIMIT 3
    ) AS top3
)
ORDER BY customer_density DESC;
