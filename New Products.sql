-- ======================================================================
-- New Products
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla, Salesforce
-- Access     : Premium
-- ID         : 10318
-- URL        : https://platform.stratascratch.com/coding/10318-new-products
-- ======================================================================

/*
Calculate the net change in the number of products launched by companies in 2020 compared to 2019. Your output should include the company names and the net difference.

(Net difference = Number of products launched in 2020 - The number launched in 2019.)
*/

-- Tables:
--   car_launches(company_name text, product_name text, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_counts AS (
    SELECT
        company_name,
        COUNT(CASE WHEN EXTRACT(YEAR FROM launch_date) = 2020 THEN 1 END) AS products_2020,
        COUNT(CASE WHEN EXTRACT(YEAR FROM launch_date) = 2019 THEN 1 END) AS products_2019
    FROM products
    WHERE EXTRACT(YEAR FROM launch_date) IN (2019, 2020)
    GROUP BY company_name
)
SELECT
    company_name,
    products_2020 - products_2019 AS net_difference
FROM yearly_counts
ORDER BY company_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    COALESCE(t2020.company_name, t2019.company_name) AS company_name,
    COALESCE(t2020.count_2020, 0) - COALESCE(t2019.count_2019, 0) AS net_difference
FROM
    (
        SELECT company_name, COUNT(*) AS count_2020
        FROM products
        WHERE EXTRACT(YEAR FROM launch_date) = 2020
        GROUP BY company_name
    ) AS t2020
FULL OUTER JOIN
    (
        SELECT company_name, COUNT(*) AS count_2019
        FROM products
        WHERE EXTRACT(YEAR FROM launch_date) = 2019
        GROUP BY company_name
    ) AS t2019
    ON t2020.company_name = t2019.company_name
ORDER BY company_name;
