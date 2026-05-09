-- ======================================================================
-- Call Declines
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Ring Central
-- Access     : Premium
-- ID         : 2020
-- URL        : https://platform.stratascratch.com/coding/2020-call-declines
-- ======================================================================

/*
Which company had the biggest month call decline from March to April 2020? Return the company_id and calls difference for the company with the highest decline.
*/

-- Tables:
--   rc_calls(call_date timestamp without time zone, call_id bigint, user_id bigint)
--   rc_users(company_id bigint, status text, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_calls AS (
    SELECT
        company_id,
        DATE_TRUNC('month', date) AS month,
        COUNT(*) AS call_count
    FROM calls
    WHERE DATE_TRUNC('month', date) IN (
        DATE '2020-03-01',
        DATE '2020-04-01'
    )
    GROUP BY company_id, DATE_TRUNC('month', date)
),
pivoted AS (
    SELECT
        company_id,
        MAX(CASE WHEN month = DATE '2020-03-01' THEN call_count ELSE 0 END) AS march_calls,
        MAX(CASE WHEN month = DATE '2020-04-01' THEN call_count ELSE 0 END) AS april_calls
    FROM monthly_calls
    GROUP BY company_id
),
ranked AS (
    SELECT
        company_id,
        april_calls - march_calls AS calls_diff,
        RANK() OVER (ORDER BY (april_calls - march_calls) ASC) AS rnk
    FROM pivoted
)
SELECT
    company_id,
    calls_diff
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    company_id,
    april_calls - march_calls AS calls_diff
FROM (
    SELECT
        company_id,
        SUM(CASE WHEN EXTRACT(MONTH FROM date) = 3 AND EXTRACT(YEAR FROM date) = 2020 THEN 1 ELSE 0 END) AS march_calls,
        SUM(CASE WHEN EXTRACT(MONTH FROM date) = 4 AND EXTRACT(YEAR FROM date) = 2020 THEN 1 ELSE 0 END) AS april_calls
    FROM calls
    WHERE EXTRACT(YEAR FROM date) = 2020
      AND EXTRACT(MONTH FROM date) IN (3, 4)
    GROUP BY company_id
) AS company_monthly
WHERE (april_calls - march_calls) = (
    SELECT MIN(april_calls - march_calls)
    FROM (
        SELECT
            company_id,
            SUM(CASE WHEN EXTRACT(MONTH FROM date) = 3 AND EXTRACT(YEAR FROM date) = 2020 THEN 1 ELSE 0 END) AS march_calls,
            SUM(CASE WHEN EXTRACT(MONTH FROM date) = 4 AND EXTRACT(YEAR FROM date) = 2020 THEN 1 ELSE 0 END) AS april_calls
        FROM calls
        WHERE EXTRACT(YEAR FROM date) = 2020
          AND EXTRACT(MONTH FROM date) IN (3, 4)
        GROUP BY company_id
    ) AS sub
);
