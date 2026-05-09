-- ======================================================================
-- Price Of A Handyman
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 9815
-- URL        : https://platform.stratascratch.com/coding/9815-price-of-a-handyman
-- ======================================================================

/*
Find the price that a small handyman business is willing to pay per employee. Get the result based on the mode of the adword earnings per employee distribution. The distribution is formed from all small handyman businesses as a single group. Small businesses are considered to have not more than ten employees.
*/

-- Tables:
--   google_adwords_earnings(adwords_earnings bigint, business_name text, business_type text, n_employees bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH small_handyman AS (
    -- Filter small handyman businesses (<=10 employees)
    SELECT 
        adwords_earnings / employees AS earnings_per_employee
    FROM businesses
    WHERE category = 'Handyman'
      AND employees <= 10
      AND employees > 0
),
frequency_ranked AS (
    SELECT 
        earnings_per_employee,
        COUNT(*) AS freq,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM small_handyman
    GROUP BY earnings_per_employee
)
SELECT earnings_per_employee AS price_per_employee
FROM frequency_ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT earnings_per_employee AS price_per_employee
FROM (
    SELECT 
        adwords_earnings / employees AS earnings_per_employee,
        COUNT(*) AS freq
    FROM businesses
    WHERE category = 'Handyman'
      AND employees <= 10
      AND employees > 0
    GROUP BY adwords_earnings / employees
) AS freq_table
WHERE freq = (
    SELECT MAX(freq2)
    FROM (
        SELECT COUNT(*) AS freq2
        FROM businesses
        WHERE category = 'Handyman'
          AND employees <= 10
          AND employees > 0
        GROUP BY adwords_earnings / employees
    ) AS max_freq
);
